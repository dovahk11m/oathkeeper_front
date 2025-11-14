// lib/domain/tracking/tracking_repository.dart
import 'package:dio/dio.dart';
import 'tracking_dto.dart';

class TrackingRepository {
  final Dio _dio;
  TrackingRepository(this._dio);

  Future<List<TrackingDto>> fetchRecent({
    required int planId,
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
  }) async {
    final r = await _dio.get(
      'http://192.168.0.187:8080/api/location/recent',
      queryParameters: {
        'planId': planId,
        'bbox': '$minLng,$minLat,$maxLng,$maxLat',
      },
    );

    // ✅ 서버 래퍼 {success, data, message} 처리
    final body = r.data;
    final listJson = (body is Map && body['data'] is List)
        ? body['data'] as List
        : (body as List); // 혹시 바로 리스트가 오면 그대로 처리

    return listJson
        .cast<Map<String, dynamic>>()
        .map(TrackingDto.fromJson)
        .toList();
  }

  Future<void> upload(TrackingDto dto) async {
    await _dio.post(
      'http://192.168.0.187:8080/api/location/update',
      data: dto.toUploadJson(),
    );
  }
}
