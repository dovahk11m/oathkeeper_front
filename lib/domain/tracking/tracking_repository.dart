import 'package:dio/dio.dart';
import 'package:oath_client/common/api_response.dart';

import 'tracking_dto.dart';

/// 위치 업로드/조회 리포지터리
class TrackingRepository {
  final Dio _dio;

  TrackingRepository(this._dio);

  /// 위치 배치 업로드: POST /api/track/tracks/bulk
  Future<TrackUploadResult> uploadBatch(TrackBatchRequest req) async {
    final resp = await _dio.post('/track/tracks/bulk', data: req.toJson());

    // 1. 응답 타입 검증
    if (resp.data is! Map<String, dynamic>) {
      throw FormatException(
        '서버 응답 형식 오류: Map 예상, ${resp.data.runtimeType} 수신',
      );
    }

    // 2. 공용 ApiResponse 파서 사용
    final apiResp = ApiResponse.fromJson(
      resp.data as Map<String, dynamic>,
      (json) => TrackUploadResult.fromJson(json),
    );

    // 3. 서버 success 필드 검증
    if (!apiResp.success) {
      throw Exception(
        '위치 업로드 실패: ${apiResp.message}', // 서버 메시지 활용
      );
    }

    // 4. data null 체크
    if (apiResp.data == null) {
      throw Exception('위치 업로드 실패: 응답 데이터 없음');
    }

    return apiResp.data!;
  }

  /// (레거시 호환) 단일 포인트 업로드 -> 배치 업로드로 래핑
  @Deprecated('Use uploadBatch with TrackBatchRequest')
  Future<TrackUploadResult> upload(TrackingDto dto,
      {int? participantId}) async {
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
