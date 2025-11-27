import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

import 'status_chip.dart';

/// 실시간 지도 하단 컨트롤 패널
class MapControlPanel extends StatelessWidget {
  final bool shareMyLocation;
  final int onlineCount;
  final NaverMapController? mapController;
  final ValueChanged<bool> onShareChanged;

  const MapControlPanel({
    super.key,
    required this.shareMyLocation,
    required this.onlineCount,
    required this.mapController,
    required this.onShareChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => _moveToMyLocation(context),
                  icon: const Icon(Icons.my_location),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                StatusChip(
                    icon: Icons.visibility,
                    label: shareMyLocation ? '공유 중' : '공유 꺼짐',
                    color: shareMyLocation ? Colors.green : Colors.grey),
                const SizedBox(width: 8),
                StatusChip(
                    icon: Icons.people_alt,
                    label: '접속 $onlineCount',
                    color: Colors.blueGrey),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Text('내 위치 공유'),
                const SizedBox(width: 8),
                Switch(value: shareMyLocation, onChanged: onShareChanged),
              ]),
            ]),
      ),
    );
  }

  Future<void> _moveToMyLocation(BuildContext context) async {
    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      final p = NLatLng(pos.latitude, pos.longitude);
      final m = mapController;
      if (m != null) {
        await m.updateCamera(
          NCameraUpdate.scrollAndZoomTo(target: p, zoom: 16)
            ..setAnimation(
                animation: NCameraAnimation.easing,
                duration: const Duration(milliseconds: 600)),
        );
      }
    } catch (_) {}
  }
}
