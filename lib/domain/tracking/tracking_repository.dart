import 'package:dio/dio.dart';

import 'tracking_dto.dart';

/// 위치 업로드/조회 리포지터리
class TrackingRepository {
  final Dio _dio;

  TrackingRepository(this._dio);

  /// 위치 배치 업로드: POST /api/track/tracks/bulk
  Future<TrackUploadResult> uploadBatch(TrackBatchRequest req) async {
    final resp = await _dio.post('/track/tracks/bulk', data: req.toJson());
    final data = resp.data is Map ? (resp.data['data'] ?? resp.data) : resp.data;
    return TrackUploadResult.fromJson(data);
  }

  /// (레거시 호환) 단일 포인트 업로드 -> 배치 업로드로 래핑
  @Deprecated('Use uploadBatch with TrackBatchRequest')
  Future<TrackUploadResult> upload(TrackingDto dto, {int? participantId}) async {
    final pid = participantId ?? dto.memberId;
    final point = TrackPoint(
      lat: dto.lat,
      lng: dto.lng,
      ts: dto.ts,
      speedMps: dto.speed,
      accuracyM: dto.accuracy,
    );
    final batch = TrackBatchRequest(participantId: pid, points: [point]);
    return uploadBatch(batch);
  }

  /// (레거시) 서버 GET 최근 위치는 폐기됨. 일단 빈 목록을 반환.
  @Deprecated('Use WebSocket /topic/plans/{planId}/live for live data')
  Future<List<TrackingDto>> fetchRecent({
    required int planId,
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
  }) async {
    return [];
  }
}
