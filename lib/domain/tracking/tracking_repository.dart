import 'package:dio/dio.dart';
import 'tracking_dto.dart';

// 기본값: 에뮬레이터에서 호스트 PC 접속(안드로이드: 10.0.2.2)
const _apiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://10.0.2.2:8080',
);

class TrackingRepository {
  final Dio _dio;
  TrackingRepository(this._dio);

  Future<List<TrackingDto>> fetchRecent({
    required int planId,
    required double minLng, required double minLat,
    required double maxLng, required double maxLat,
  }) async {
    final r = await _dio.get(
      '$_apiBase/api/location/recent',
      queryParameters: {'planId': planId, 'bbox': '$minLng,$minLat,$maxLng,$maxLat'},
    );
    final list = (r.data as List).cast<Map<String, dynamic>>();
    return list.map(TrackingDto.fromJson).toList();
  }

  Future<void> upload(TrackingDto dto) async {
    await _dio.post('$_apiBase/api/location/update', data: dto.toUploadJson());
  }
}
