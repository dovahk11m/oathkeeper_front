// lib/view/live_map/live_map_page.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
// [수정] http_util.dart 파일의 경로를 새로운 위치로 변경합니다.
import 'package:oath_client/common/utils/http_util.dart'; // dioProvider
import 'package:oath_client/common/utils/platform_defaults.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart'; // authProvider
import 'package:oath_client/domain/members/members_repository.dart';
import 'package:oath_client/domain/tracking/live_location_dto.dart';
import 'package:oath_client/domain/tracking/tracking_dto.dart';
import 'package:oath_client/domain/tracking/tracking_provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

/// 실기기 2대 테스트면 PC의 LAN IP를 사용
final _wsUrl = String.fromEnvironment(
  'WS_URL',
  defaultValue: PlatformDefaults.wsLiveMap,
);
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
                // onCameraIdle: () => _loadRecentAll(), // Deprecated
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
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

      // presence: join 즉시 브로드캐스트 (제거됨)
      // _sendPresence('join');

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

      // presence: leave 즉시 브로드캐스트 (제거됨)
      // _sendPresence('leave');
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
          // 1. 실시간 위치 업데이트 구독 (최신 스펙)
          _stomp?.subscribe(
            destination: '/topic/plans/${widget.planId}/live',
            callback: (frame) {
              if (frame.body == null) return;
              try {
                final data = LiveLocationDto.fromJson(jsonDecode(frame.body!));
                _handleLiveLocation(data);
              } catch (e) {
                debugPrint('LiveLocation parse error: $e');
              }
            },
          );

          // 2. 이벤트 알림 구독 (GPS 정체, 도착 등)
          _stomp?.subscribe(
            destination: '/topic/plans/${widget.planId}/events',
            callback: (frame) {
              if (frame.body == null) return;
              try {
                final event = jsonDecode(frame.body!) as Map<String, dynamic>;
                _handleEvent(event);
              } catch (e) {
                debugPrint('Event parse error: $e');
              }
            },
          );
        },
      ),
    )..activate();
  }

  // 구 Presence 로직 제거됨 (_sendPresence 등)

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

  // ---------- 폴링 (제거됨) ----------
  // Future<void> _loadRecentAll() async { ... }

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

        // [수정] TrackingDto(Deprecated) -> TrackBatchRequest
        final point = TrackPoint(
          lat: pos.latitude,
          lng: pos.longitude,
          ts: now,
          speedMps: pos.speed,
          accuracyM: pos.accuracy,
          source: 'GPS',
        );
        final batch = TrackBatchRequest(
          participantId: _myMemberId ?? 0,
          points: [point],
        );

        await repo.uploadBatch(batch);

        _updateMyMarker(here, ts: now.toLocal());
        _touchPresence(_myMemberId ?? -1);

        // Presence ping 제거됨 (서버 자동 관리)
      } catch (e) {
        // 로깅 (개발 중 디버깅용)
        debugPrint('[위치 업로드 실패] $e');

        // 사용자에게 안내
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('위치 공유 중 오류가 발생했습니다'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // 상태 복구
        _stopUploadLoop();
        if (mounted) {
          setState(() {
            _shareMyLocation = false;
            _myAlpha = 0;
          });
        }
        _removeMyMarkerImmediate();
        // _sendPresence('leave'); // 제거됨
      }
    });
  }

  void _stopUploadLoop() {
    _uploadTimer?.cancel();
    _uploadTimer = null;
    _lastUploaded = null;
  }

  // ---------- 수신 처리 ----------

  /// 실시간 위치 수신 처리
  void _handleLiveLocation(LiveLocationDto data) {
    // 내 위치는 내가 직접 찍으므로 무시
    if (data.memberId == _myMemberId) return;

    // 이름 캐싱 (서버가 보내줌)
    if (data.username.isNotEmpty) {
      _nameCache[data.memberId] = data.username;
    }

    // 마커 업데이트
    final pos = NLatLng(data.lat, data.lng);
    final ts = DateTime.tryParse(data.lastLiveTs)?.toLocal();

    _updateMemberMarker(data.memberId, pos, ts: ts);
    _touchPresence(data.memberId);
  }

  /// 이벤트 처리 (GPS 정체, 도착 등)
  void _handleEvent(Map<String, dynamic> event) {
    final eventType = event['eventType'] as String?;
    final message = event['message'] as String?;
    final username = event['username'] as String?;

    if (message != null && mounted) {
      Color snackColor = Colors.black87;
      if (eventType == 'PARTICIPANT_ARRIVED') {
        snackColor = Colors.green;
      } else if (eventType == 'GPS_STATIONARY') {
        snackColor = Colors.orange;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: snackColor,
          duration: const Duration(seconds: 4),
        ),
      );
    }

    debugPrint('[Event] $eventType / $username / $message');
  }

  /// 다른 멤버 마커 업데이트
  void _updateMemberMarker(int memberId, NLatLng pos, {DateTime? ts}) async {
    final map = _map;
    if (map == null) return;

    try {
      // 마커 없으면 생성
      if (!_markers.containsKey(memberId)) {
        final marker = NMarker(
          id: 'm_$memberId',
          position: pos,
          iconTintColor: Colors.blueAccent, // 다른 사람은 파란색 계열
        );

        // 캡션 설정
        final name = _nameCache[memberId] ?? 'Member $memberId';
        marker.setCaption(NOverlayCaption(text: name));

        await map.addOverlay(marker);
        _markers[memberId] = marker;
      }

      final m = _markers[memberId]!;
      m.setPosition(pos);
      m.setAlpha(1); // 보이게

      // 캡션 업데이트 (이름이 갱신되었을 수 있음)
      final name = _nameCache[memberId] ?? 'Member $memberId';
      String captionText = name;
      if (ts != null) {
        captionText += '\n${_formatTime(ts)}';
      }
      m.setCaption(NOverlayCaption(text: captionText));
    } catch (e) {
      debugPrint('Marker update failed: $e');
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
      _myMarker?.setAlpha(0);
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

  // ---------- 시간 포맷 ----------

  String _formatTime(DateTime dt) {
    // HH:mm:ss
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
