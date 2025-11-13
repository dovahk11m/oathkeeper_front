// lib/view/live_map/live_map_page.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import 'package:oath_client/common/utils/http_util.dart'; // dioProvider
import 'package:oath_client/domain/members/member.dart'; // authProvider
import 'package:oath_client/domain/tracking/tracking_dto.dart';
import 'package:oath_client/domain/tracking/tracking_provider.dart';
import 'package:oath_client/domain/members/members_repository.dart';

/// 실기기 2대 테스트면 PC의 LAN IP를 사용
const _wsUrl =
    String.fromEnvironment('WS_URL', defaultValue: 'ws://10.0.0.2:8080/ws');
const _naverClientId =
    String.fromEnvironment('NAVER_CLIENT_ID', defaultValue: 'xb8jm8rjaa');

class LiveMapPage extends ConsumerStatefulWidget {
  final int planId;
  const LiveMapPage({super.key, required this.planId});

  @override
  ConsumerState<LiveMapPage> createState() => _LiveMapPageState();
}

class _LiveMapPageState extends ConsumerState<LiveMapPage> {
  // Naver Map init
  late final Future<void> _naverInit = FlutterNaverMap().init(
    clientId: _naverClientId,
    onAuthFailed: (e) => debugPrint('NaverMap auth failed: $e'),
  );

  NaverMapController? _map;

  // 다른 멤버 마커
  final Map<int, NMarker> _markers = {};

  // 내 마커
  NMarker? _myMarker;
  double _myAlpha = 0; // OFF: 0, ON: 1

  // STOMP/타이머
  StompClient? _stomp;
  Timer? _pollTimer;
  Timer? _uploadTimer;
  Timer? _presencePruner;

  // 내 ID
  int? _myMemberId;

  // 공유 스위치
  bool _shareMyLocation = false;

  // 최근 업로드 위치 (미세 이동 업로드 생략)
  NLatLng? _lastUploaded;

  // presence: 최근 10초 내 신호면 접속자로 간주
  final Map<int, DateTime> _lastSeen = {};
  static const _presenceWindow = Duration(seconds: 10);

  // 이름 캐시
  final Map<int, String> _nameCache = {};

  @override
  void initState() {
    super.initState();
    _initMyMemberIdFromToken();
  }

  Future<void> _initMyMemberIdFromToken() async {
    final token = await ref.read(authProvider.notifier).getAccessToken() ?? '';
    final id = _memberIdFromToken(token);
    if (mounted) {
      setState(() {
        _myMemberId = id;
      });
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _uploadTimer?.cancel();
    _presencePruner?.cancel();
    _stomp?.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _naverInit,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('실시간 지도 • 약속#${widget.planId}'),
          ),
          body: Stack(
            children: [
              NaverMap(
                options: const NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.1796, 129.0756),
                    zoom: 13,
                  ),
                  locationButtonEnable: true,
                ),
                onMapReady: (c) async {
                  _map = c;
                  _setTrackingMode(NLocationTrackingMode.noFollow);

                  // 이름 선로딩 (참여자 목록)
                  await _preloadNamesAndRefreshCaptions();

                  // STOMP 연결
                  await _connectStomp();

                  // 초회 폴링
                  await _loadRecentAll();

                  // 보강 폴링
                  _pollTimer?.cancel();
                  _pollTimer = Timer.periodic(
                      const Duration(seconds: 8), (_) => _loadRecentAll());

                  // presence 프루닝: 1초마다
                  _presencePruner?.cancel();
                  _presencePruner =
                      Timer.periodic(const Duration(seconds: 1), (_) {
                    final now = DateTime.now();
                    // 오래된 것은 접속 해제 처리 + 마커 숨김
                    final expired = <int>[];
                    _lastSeen.forEach((id, ts) {
                      if (now.difference(ts) > _presenceWindow) expired.add(id);
                    });
                    for (final id in expired) {
                      _lastSeen.remove(id);
                      if (id != _myMemberId) {
                        // 완전 제거(플러그인에 제거 API는 없어 alpha=0 + 맵에서 제거하는 식)
                        final m = _markers.remove(id);
                        try {
                          m?.setAlpha(0);
                        } catch (_) {}
                      }
                    }
                    if (mounted) setState(() {});
                  });
                },
                onCameraIdle: () => _loadRecentAll(),
              ),

              // 좌상단 접속자
              Positioned(top: 12, left: 12, child: _onlinePill()),

              // 하단 컨트롤
              Positioned(
                  left: 12, right: 12, bottom: 12, child: _bottomPanel()),
            ],
          ),
        );
      },
    );
  }

  // ---------- UI ----------

  Widget _onlinePill() {
    final count = _lastSeen.length;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.people_alt, size: 16),
          const SizedBox(width: 6),
          Text('접속자 $count명',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _bottomPanel() {
    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('실시간 위치',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                  tooltip: '내 위치로 이동',
                  onPressed: () async {
                    try {
                      final pos = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.best);
                      final p = NLatLng(pos.latitude, pos.longitude);
                      final m = _map;
                      if (m != null) {
                        await m.updateCamera(
                          NCameraUpdate.scrollAndZoomTo(target: p, zoom: 16)
                            ..setAnimation(
                                animation: NCameraAnimation.easing,
                                duration: const Duration(milliseconds: 600)),
                        );
                      }
                    } catch (_) {}
                  },
                  icon: const Icon(Icons.my_location),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _statusChip(
                    icon: Icons.visibility,
                    label: _shareMyLocation ? '공유 중' : '공유 꺼짐',
                    color: _shareMyLocation ? Colors.green : Colors.grey),
                const SizedBox(width: 8),
                _statusChip(
                    icon: Icons.people_alt,
                    label: '접속 ${_lastSeen.length}',
                    color: Colors.blueGrey),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Text('내 위치 공유'),
                const SizedBox(width: 8),
                Switch(value: _shareMyLocation, onChanged: (v) => _setShare(v)),
              ]),
            ]),
      ),
    );
  }

  Widget _statusChip(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // ---------- 공유 토글 ----------

  Future<void> _setShare(bool v) async {
    if (v) {
      final ok = await _ensurePermissionWithPrompt();
      if (!ok) {
        if (mounted) setState(() => _shareMyLocation = false);
        return;
      }
      if (mounted) {
        setState(() {
          _shareMyLocation = true;
          _myAlpha = 1;
        });
      }

      // 켜자마자 즉시 마커 + 카메라 이동
      await _placeMyMarkerImmediately();

      // presence: join 즉시 브로드캐스트
      _sendPresence('join');

      _startUploadLoop();
    } else {
      if (mounted) {
        setState(() {
          _shareMyLocation = false;
          _myAlpha = 0;
        });
      }
      _stopUploadLoop();
      _removeMyMarkerImmediate();

      // 내 쪽 리스트에서 즉시 제거
      final myId = _myMemberId;
      if (myId != null) _lastSeen.remove(myId);
      if (mounted) setState(() {});

      // presence: leave 즉시 브로드캐스트 (상대 기기에서 바로 숨김)
      _sendPresence('leave');
    }
  }

  // ---------- 권한 ----------

  Future<bool> _ensurePermissionWithPrompt() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      if (!await Geolocator.isLocationServiceEnabled()) {
        _toast('위치 서비스가 꺼져 있습니다.');
        return false;
      }
    }
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.denied ||
        p == LocationPermission.deniedForever) {
      _toast('위치 권한이 없습니다.');
      return false;
    }
    return true;
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- STOMP ----------

  Future<void> _connectStomp() async {
    final token = await ref.read(authProvider.notifier).getAccessToken() ?? '';
    final wsUrlWithToken = '$_wsUrl?token=$token';

    _stomp = StompClient(
      config: StompConfig(
        url: wsUrlWithToken,
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        onConnect: (_) {
          // 위치 브로드캐스트
          _stomp?.subscribe(
            destination: '/topic/room/${widget.planId}',
            callback: (frame) {
              if (frame.body == null) return;
              final d = TrackingDto.fromJson(jsonDecode(frame.body!));
              _handleIncoming(d);
            },
          );

          // presence 브로드캐스트
          _stomp?.subscribe(
            destination: '/topic/room/${widget.planId}/presence',
            callback: (frame) {
              if (frame.body == null) return;
              final msg = jsonDecode(frame.body!) as Map<String, dynamic>;
              final type =
                  (msg['type'] ?? '').toString(); // 'join' | 'leave' | 'ping'
              final int? who = (msg['memberId'] is int)
                  ? msg['memberId'] as int
                  : int.tryParse('${msg['memberId']}');

              if (who == null) return;

              if (type == 'leave') {
                _lastSeen.remove(who);
                if (who != _myMemberId) {
                  // 다른 사람 마커 숨김 + 맵에서 제거 느낌으로 캐시 제거
                  final m = _markers.remove(who);
                  try {
                    m?.setAlpha(0);
                  } catch (_) {}
                }
                if (mounted) setState(() {});
              } else {
                // join/ping → 최근 신호
                _touchPresence(who);
              }
            },
          );

          // 내가 이미 공유 ON이면 join 알림
          if (_shareMyLocation) {
            _sendPresence('join');
          }
        },
      ),
    )..activate();
  }

  void _sendPresence(String type) {
    try {
      final id = _myMemberId ?? -1;
      final body = jsonEncode({'type': type, 'memberId': id});
      _stomp?.send(
          destination: '/app/room/${widget.planId}/presence', body: body);
    } catch (_) {}
  }

  // ---------- 이름 선로딩 ----------

  Future<void> _preloadNamesAndRefreshCaptions() async {
    try {
      final dio = ref.read(dioProvider);
      final repo = MembersRepository(dio);
      final map = await repo.fetchNameMapByPlan(widget.planId);
      if (map.isNotEmpty) {
        _nameCache.addAll(map);
        // 떠 있는 마커들 캡션 즉시 갱신
        _markers.forEach((id, marker) {
          final nm = _nameCache[id];
          if (nm != null && nm.isNotEmpty) {
            marker.setCaption(NOverlayCaption(text: nm));
          }
        });
        if (mounted) setState(() {});
      }
    } catch (_) {}
  }

  // ---------- 폴링 ----------

  Future<void> _loadRecentAll() async {
    if (_map == null) return;
    final repo = ref.read(trackingRepositoryProvider);
    const minLng = -180.0, minLat = -90.0, maxLng = 180.0, maxLat = 90.0;
    final list = await repo.fetchRecent(
      planId: widget.planId,
      minLng: minLng,
      minLat: minLat,
      maxLng: maxLng,
      maxLat: maxLat,
    );
    for (final d in list) {
      _handleIncoming(d);
    }
  }

  // ---------- 업로드 루프 ----------

  void _startUploadLoop() {
    _uploadTimer?.cancel();
    if (!_shareMyLocation) return;

    _uploadTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        final here = NLatLng(pos.latitude, pos.longitude);

        // ~3m 이내면 업로드 생략
        if (_lastUploaded != null) {
          final dLat = (here.latitude - _lastUploaded!.latitude).abs();
          final dLng = (here.longitude - _lastUploaded!.longitude).abs();
          if (dLat < 0.00003 && dLng < 0.00003) {
            _updateMyMarker(here, ts: DateTime.now());
            return;
          }
        }
        _lastUploaded = here;

        final repo = ref.read(trackingRepositoryProvider);
        final now = DateTime.now().toUtc();
        final dto = TrackingDto(
          planId: widget.planId,
          memberId: _myMemberId ?? 0,
          lat: pos.latitude,
          lng: pos.longitude,
          accuracy: pos.accuracy,
          speed: pos.speed,
          heading: pos.heading,
          ts: now,
        );
        await repo.upload(dto);

        _updateMyMarker(here, ts: now.toLocal());
        _touchPresence(_myMemberId ?? -1);

        // 서버가 presence를 지원하지 않더라도 주기적 ping
        _sendPresence('ping');
      } catch (_) {
        _stopUploadLoop();
        if (mounted) {
          setState(() {
            _shareMyLocation = false;
            _myAlpha = 0;
          });
        }
        _removeMyMarkerImmediate();
        _sendPresence('leave');
      }
    });
  }

  void _stopUploadLoop() {
    _uploadTimer?.cancel();
    _uploadTimer = null;
    _lastUploaded = null;
  }

  // ---------- 수신/마커/프레즌스 ----------

  void _handleIncoming(TrackingDto d) {
    _touchPresence(d.memberId);

    final pos = NLatLng(d.lat, d.lng);

    // 캡션용 이름 + 시간
    final displayName = _nameCache[d.memberId] ?? 'member#${d.memberId}';
    final timeStr = _formatTime((d.ts ?? DateTime.now().toUtc()).toLocal());
    final captionText = '$displayName · $timeStr';

    // 내 위치는 공유 ON일 때만 보인다
    if (d.memberId == _myMemberId) {
      if (_shareMyLocation)
        _updateMyMarker(pos, forcedCaption: captionText, ts: d.ts?.toLocal());
      return;
    }

    // 다른 멤버
    final existing = _markers[d.memberId];
    if (existing != null) {
      existing
        ..setAlpha(1)
        ..setPosition(pos)
        ..setCaption(NOverlayCaption(text: captionText));
    } else {
      final m = NMarker(id: 'm_${d.memberId}', position: pos)
        ..setCaption(NOverlayCaption(text: captionText));
      _markers[d.memberId] = m;
      _map?.addOverlay(m);

      // 이름 비동기 보강: 처음엔 member#id라도, 이름이 오면 곧바로 갱신
      if (!_nameCache.containsKey(d.memberId)) {
        _ensureUsernameCaption(d.memberId);
      }
    }
  }

  void _updateMyMarker(NLatLng pos, {String? forcedCaption, DateTime? ts}) {
    if (!_shareMyLocation) return;

    final timeStr = _formatTime((ts ?? DateTime.now()).toLocal());
    final myName = _nameCache[_myMemberId ?? -1]; // 필요 시 실명 표시
    final label = forcedCaption ??
        (myName != null ? '$myName · $timeStr' : '나 · $timeStr');

    if (_myMarker == null) {
      _myMarker = NMarker(
        id: 'me',
        position: pos,
        captionOffset: 8,
      )
        ..setCaption(NOverlayCaption(text: label))
        ..setAlpha(_myAlpha);
      _map?.addOverlay(_myMarker!);
    } else {
      _myMarker!
        ..setPosition(pos)
        ..setAlpha(_myAlpha)
        ..setCaption(NOverlayCaption(text: label));
    }
  }

  void _removeMyMarkerImmediate() {
    try {
      _myMarker?..setAlpha(0);
    } catch (_) {}
    _myMarker = null;
  }

  void _touchPresence(int memberId) {
    _lastSeen[memberId] = DateTime.now();
    if (mounted) setState(() {});
  }

  // ---------- 지도 트래킹 모드 (void 반환 → await 금지) ----------

  void _setTrackingMode(NLocationTrackingMode mode) {
    final m = _map;
    if (m != null) {
      m.setLocationTrackingMode(mode);
    }
  }

  // ---------- 즉시 마커 & 카메라 이동 ----------

  Future<void> _placeMyMarkerImmediately() async {
    try {
      Position? pos = await Geolocator.getLastKnownPosition();
      pos ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 2),
      );
      if (pos == null) return;

      final here = NLatLng(pos.latitude, pos.longitude);
      _lastUploaded = here;

      _updateMyMarker(here, ts: DateTime.now());

      _touchPresence(_myMemberId ?? -1);

      final m = _map;
      if (m != null) {
        await m.updateCamera(
          NCameraUpdate.scrollAndZoomTo(target: here, zoom: 16)
            ..setAnimation(
                animation: NCameraAnimation.easing,
                duration: const Duration(milliseconds: 600)),
        );
      }
    } catch (_) {}
  }

  // ---------- JWT 파싱 ----------

  int? _memberIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload) as Map<String, dynamic>;
      final raw = map['memberId'] ?? map['id'] ?? map['uid'] ?? map['sub'];
      if (raw is int) return raw;
      return int.tryParse('$raw');
    } catch (_) {
      return null;
    }
  }

  // ---------- 이름 조회 & 캡션 교체 ----------

  Future<void> _ensureUsernameCaption(int memberId) async {
    if (_nameCache.containsKey(memberId)) return;
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('/members/$memberId');
      final data = res.data is Map ? res.data['data'] : null;

      // username → email → member#id
      String label = '';
      if (data is Map) {
        label = (data['username']?.toString() ?? '').trim();
        if (label.isEmpty) {
          label = (data['email']?.toString() ?? '').trim();
        }
      }
      if (label.isEmpty) label = 'member#$memberId';

      _nameCache[memberId] = label;

      final m = _markers[memberId];
      if (m != null) {
        // 최근 시각 포함해서 다시 세팅
        final timeStr = _formatTime(DateTime.now());
        m.setCaption(NOverlayCaption(text: '$label ·/n $timeStr'));
      }
    } catch (_) {
      // 실패 시 폴백 유지
    }
  }

  // ---------- 시간 포맷 ----------

  String _formatTime(DateTime dt) {
    // HH:mm:ss
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
