import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/plans/plan.dart';
import 'package:oath_client/domain/plans/participant.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository(ref.read(dioProvider));
});

/// 플랜 API 통신
class PlanRepository {
  final Dio _dio;

  PlanRepository(this._dio);

  /// 목록 조회
  Future<List<Plan>> getPlans() async {
    try {
      final response = await _dio.get('/plans/');
      final data = response.data['data'] as List;
      return data.map((json) => Plan.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 상세 조회
  Future<Plan> getPlanById(int id) async {
    try {
      final response = await _dio.get('/plans/$id');
      return Plan.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 생성
  Future<Plan> createPlan({
    required String title,
    required DateTime planDatetime,
    String? location,
    int? lateFineAmount,
    List<String>? tags,
  }) async {
    try {
      final response = await _dio.post(
        '/plans/',
        data: {
          'title': title,
          'planDatetime': planDatetime.toIso8601String(),
          'status': 'PLANNING',
          if (location != null) 'location': location,
          if (lateFineAmount != null) 'lateFineAmount': lateFineAmount,
          if (tags != null) 'tags': tags,
        },
      );
      return Plan.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 수정
  Future<Plan> updatePlan({
    required int id,
    String? title,
    DateTime? planDatetime,
    String? location,
    int? lateFineAmount,
    List<String>? tags,
  }) async {
    try {
      final response = await _dio.put(
        '/plans/$id',
        data: {
          if (title != null) 'title': title,
          if (planDatetime != null) 'planDatetime': planDatetime.toIso8601String(),
          if (location != null) 'location': location,
          if (lateFineAmount != null) 'lateFineAmount': lateFineAmount,
          if (tags != null) 'tags': tags,
        },
      );
      return Plan.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 삭제
  Future<void> deletePlan(int id) async {
    try {
      await _dio.delete('/plans/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 장소 확정
  Future<Plan> confirmPlace({
    required int planId,
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post(
        '/plans/$planId/confirm-place',
        data: {
          'location': location,
          'placeLatitude': latitude,
          'placeLongitude': longitude,
        },
      );
      return Plan.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 참가자 추가
  Future<void> addParticipant({
    required int planId,
    required int memberId,
  }) async {
    try {
      await _dio.post(
        '/plans/$planId/participants',
        data: {'memberId': memberId},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 참가자 목록
  Future<List<Participant>> getParticipants(int planId) async {
    try {
      final response = await _dio.get('/plans/$planId/participants');
      final data = response.data['data'] as List;
      return data.map((json) => Participant.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 참가자 삭제
  Future<void> removeParticipant({
    required int planId,
    required int participantId,
  }) async {
    try {
      await _dio.delete('/plans/$planId/participants/$participantId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 참가 상태 변경
  Future<void> updateParticipantStatus({
    required int participantId,
    required String status,
  }) async {
    try {
      await _dio.put(
        '/plans/participants/$participantId/status',
        data: {'status': status},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 출발 기록
  Future<void> recordDeparture(int participantId) async {
    try {
      await _dio.post('/plans/participants/$participantId/departure');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 도착 기록
  Future<void> recordArrival(int participantId) async {
    try {
      await _dio.post('/plans/participants/$participantId/arrival');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 출발 시간 제안
  Future<void> suggestDeparture({
    required int participantId,
    required String transportMethod,
    required int expectedTravelTimeMinutes,
  }) async {
    try {
      await _dio.post(
        '/plans/participants/$participantId/suggest-departure',
        data: {
          'transportMethod': transportMethod,
          'expectedTravelTimeMinutes': expectedTravelTimeMinutes,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 지각 벌금 조회
  Future<int> getLateFine(int participantId) async {
    try {
      final response = await _dio.get('/plans/participants/$participantId/late-fine');
      return response.data['data'] as int;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 에러 처리
  String _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
          return data['error']?['message'] ?? '알 수 없는 오류가 발생했습니다.';
        }
      }
      return '서버 연결에 실패했습니다.';
    }
    return e.toString();
  }
}

