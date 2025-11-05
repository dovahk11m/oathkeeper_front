import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:oath_client/domain/tracking/tracking_dto.dart';
import 'package:oath_client/domain/tracking/tracking_provider.dart';
import 'package:oath_client/domain/members/member.dart'; // authProvider
import 'package:stomp_dart_client/stomp_dart_client.dart';

/// env.dart 없이 사용: 필요 시 --dart-define로 덮어쓰기
const _wsUrl = String.fromEnvironment('WS_URL', defaultValue: 'ws://10.0.2.2:8080/ws');
const _naverClientId = String.fromEnvironment('NAVER_CLIENT_ID', defaultValue: 'xb8jm8rjaa');

class LiveMapPage extends ConsumerStatefulWidget {
  final int planId;
  const LiveMapPage({super.key, required this.planId});

  @override
  ConsumerState<LiveMapPage> createState() => _LiveMapPageState();
}

class _LiveMapPageState extends ConsumerState<LiveMapPage> {
  // 네이버맵 SDK 지연 초기화
  late final Future<void> _naverInit = FlutterNaverMap().init(
    clientId: _naverClientId,
    onAuthFailed: (e) {},
  );

  NaverMapController? _map;
  final Map<int, NMarker> _markers = {};
  StompClient? _stomp;
  Timer? _poll;
  Timer? _sender;
  bool _shareMyLocation = true;

  @override
  void dispose() {
    _poll?.cancel();
    _sender?.cancel();
    _stomp?.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _naverInit,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          // 초기화 대기 중 스켈레톤/로딩 표시
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('실시간 지도 • plan#${widget.planId}')),
          body: Stack(
            children: [
              NaverMap(
                options: const NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.1796, 129.0756), zoom: 13,
                  ),
                  locationButtonEnable: true,
                ),
                onMapReady: (c) async {
                  _map = c;
                  await _ensureLocationPermission();
                  await _loadByBBox();
                  await _connectStomp();
                  _poll = Timer.periodic(const Duration(seconds: 8), (_) => _loadByBBox());
                  _startUploadLoop();
                },
                onCameraIdle: _loadByBBox,
              ),
              Positioned(top: 12, right: 12, child: _shareToggle()),
            ],
          ),
        );
      },
    );
  }

  Widget _shareToggle() {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Row(children: [
        const Padding(padding: EdgeInsets.only(left: 10), child: Text('내 위치 공유')),
        Switch(
          value: _shareMyLocation,
          onChanged: (v) {
            setState(() => _shareMyLocation = v);
            if (v) {
              _startUploadLoop();
            } else {
              _sender?.cancel();
            }
          },
        ),
      ]),
    );
  }

  Future<void> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) { await Geolocator.openLocationSettings(); }
    final p = await Geolocator.requestPermission();
    if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return;
  }

  Future<void> _connectStomp() async {
    final token = await ref.read(authProvider.notifier).getAccessToken();

    _stomp = StompClient(
      config: StompConfig(
        url: _wsUrl,
        onConnect: (_) {
          _stomp?.subscribe(
            destination: '/topic/room/${widget.planId}',
            callback: (f) {
              if (f.body == null) return;
              final d = TrackingDto.fromJson(jsonDecode(f.body!));
              _upsert(d);
            },
          );
        },
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    )..activate();
  }

  void _upsert(TrackingDto d) {
    final id = d.memberId;
    final pos = NLatLng(d.lat, d.lng);

    if (_markers.containsKey(id)) {
      _markers[id]?.setPosition(pos);
    } else {
      final marker = NMarker(id: 'm_$id', position: pos)
        ..setCaption(NOverlayCaption(text: 'member#$id'));
      _markers[id] = marker;
      _map?.addOverlay(marker);
    }
  }

  Future<void> _loadByBBox() async {
    if (_map == null) return;
    final repo = ref.read(trackingRepositoryProvider);

    // 서버가 planId별 최신 1건만 반환한다는 전제
    const minLng = -180.0, minLat = -90.0, maxLng = 180.0, maxLat = 90.0;

    final list = await repo.fetchRecent(
      planId: widget.planId,
      minLng: minLng, minLat: minLat,
      maxLng: maxLng, maxLat: maxLat,
    );
    for (final d in list) { _upsert(d); }
  }

  void _startUploadLoop() {
    _sender?.cancel();
    if (!_shareMyLocation) return;

    _sender = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        if (pos.accuracy > 50) return;

        final repo = ref.read(trackingRepositoryProvider);
        final dto = TrackingDto(
          planId: widget.planId,
          memberId: 0, // 서버가 토큰으로 식별
          lat: pos.latitude,
          lng: pos.longitude,
          accuracy: pos.accuracy,
          speed: pos.speed,
          heading: pos.heading,
          ts: DateTime.now().toUtc(),
        );
        await repo.upload(dto);
      } catch (_) {/* ignore */}
    });
  }
}
