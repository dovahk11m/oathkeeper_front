import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/domain/plans/plan.dart';
import 'package:oath_client/domain/plans/participant.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository(ref.read(dioProvider), ref);
});

/// 플랜 API
class PlanRepository {
  final Dio _dio;
  final Ref _ref;

  PlanRepository(this._dio, this._ref);

  /// 목록
  Future<List<Plan>> getPlans() async {
    try {
      print('[PlanRepo] 약속 목록 요청');
      final response = await _dio.get('/plans');
      print('[PlanRepo] 약속 목록 응답: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '목록 조회 실패');
      }

      final data = response.data['data'];
      if (data == null) return [];

      if (data is List) {
        return data.map((json) {
          final transformed = _transformPlanResponse(json as Map<String, dynamic>);
          return Plan.fromJson(transformed);
        }).toList();
      }

      return [];
    } catch (e) {
      print('[PlanRepo] 약속 목록 조회 실패: $e');
      throw _handleError(e);
    }
  }

  /// 상세
  Future<Plan> getPlanById(int id) async {
    try {
      print('[PlanRepo] 약속 상세 조회 요청: $id');
      final response = await _dio.get('/plans/$id');
      print('[PlanRepo] 약속 상세 조회 응답: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '상세 조회 실패');
      }

      final planData = response.data['data'];
      if (planData == null) {
        throw Exception('약속 데이터가 없습니다');
      }

      final transformed = _transformPlanResponse(planData as Map<String, dynamic>);
      return Plan.fromJson(transformed);
    } catch (e) {
      print('[PlanRepo] 약속 상세 조회 실패: $e');
      if (e is DioException) {
        print('[PlanRepo] 상태: ${e.response?.statusCode}');
        print('[PlanRepo] 응답: ${e.response?.data}');
      }
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
      // 현재 로그인한 사용자 ID 가져오기
      final memberId = _ref.read(authProvider).auth?.id;
      if (memberId == null) {
        throw Exception('로그인이 필요합니다');
      }

      // API 스펙에 맞는 형식으로 요청 데이터 구성
      final requestData = <String, dynamic>{
        'creatorMemberId': memberId,
        'title': title,
        'planDatetime': planDatetime.toIso8601String(),
        'status': 'PLANNING',
      };

      if (location != null && location.isNotEmpty) {
        requestData['location'] = location;
      }
      if (lateFineAmount != null) {
        requestData['lateFineAmount'] = lateFineAmount;
      }
      if (tags != null && tags.isNotEmpty) {
        requestData['tags'] = tags;
      }

      print('[PlanRepo] 약속 생성 요청');
      print('[PlanRepo] URL: POST /plans');
      print('[PlanRepo] 데이터: $requestData');

      final response = await _dio.post('/plans', data: requestData);

      print('[PlanRepo] 응답 성공: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '약속 생성 실패');
      }

      final planData = response.data['data'];
      if (planData == null) {
        throw Exception('응답 데이터가 없습니다');
      }

      print('[PlanRepo] 약속 생성 완료: ID ${planData['id']}');

      // API 응답을 Plan 모델에 맞게 변환
      // API 스펙: {id, date, time, title, location, placeLatitude, placeLongitude, participants}
      // Plan 모델: {id, title, planDatetime, status, location, ...}
      final transformedData = _transformPlanResponse(planData);

      return Plan.fromJson(transformedData);
    } catch (e) {
      print('[PlanRepo] 약속 생성 실패: $e');
      if (e is DioException) {
        print('[PlanRepo] 상태: ${e.response?.statusCode}');
        print('[PlanRepo] 응답: ${e.response?.data}');
      }
      throw _handleError(e);
    }
  }

  /// API 응답을 Plan 모델 형식으로 변환
  Map<String, dynamic> _transformPlanResponse(Map<String, dynamic> apiData) {
    // API 스펙의 date, time을 planDatetime으로 변환
    final date = apiData['date'] as String?;
    final time = apiData['time'] as String?;

    String planDatetime;
    if (date != null && time != null) {
      planDatetime = '${date}T$time';
    } else {
      planDatetime = DateTime.now().toIso8601String();
    }

    // id가 null이면 임시로 0 사용 (서버 버그로 보임)
    final planId = apiData['id'];
    if (planId == null) {
      print('[PlanRepo] 경고: 서버가 id를 null로 반환했습니다');
    }

    // participants 변환
    final rawParticipants = apiData['participants'] as List<dynamic>?;
    final transformedParticipants = rawParticipants?.map((p) {
      final participant = p as Map<String, dynamic>;
      return {
        'id': participant['id'],
        'memberId': participant['memberId'],
        'memberNickname': participant['memberNickname'] ?? participant['nickname'] ?? '이름 없음',
        'memberProfileImageUrl': participant['memberProfileImageUrl'],
        'participantStatus': participant['participantStatus'] ?? 'PENDING',
        'transportMethod': participant['transportMethod'],
        'expectedTravelTimeMinutes': participant['expectedTravelTimeMinutes'],
        'expectedDepartureTime': participant['expectedDepartureTime'],
        'actualDepartureTime': participant['actualDepartureTime'],
        'actualArrivalTime': participant['actualArrivalTime'],
        'arrivalStatus': participant['arrivalStatus'],
        'timeBurdenMinutes': participant['timeBurdenMinutes'],
      };
    }).toList() ?? [];

    return {
      'id': planId ?? 0,
      'title': apiData['title'] ?? '',
      'planDatetime': planDatetime,
      'status': 'PLANNING',
      'location': apiData['location'],
      'placeLatitude': apiData['placeLatitude'],
      'placeLongitude': apiData['placeLongitude'],
      'lateFineAmount': apiData['lateFineAmount'],
      'creatorMember': {
        'id': _ref.read(authProvider).auth?.id ?? 0,
        'email': _ref.read(authProvider).auth?.email ?? '',
        'nickname': _ref.read(authProvider).auth?.username ?? '',
      },
      'participants': transformedParticipants,
      'tags': apiData['tags'] ?? [],
    };
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
      print('[PlanRepo] 참가자 추가 요청: planId=$planId, memberId=$memberId');
      final response = await _dio.post(
        '/plans/$planId/participants',
        data: {'memberId': memberId},
      );
      print('[PlanRepo] 참가자 추가 응답: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '참가자 추가 실패');
      }
    } catch (e) {
      print('[PlanRepo] 참가자 추가 실패: $e');
      if (e is DioException) {
        print('[PlanRepo] 상태: ${e.response?.statusCode}');
        print('[PlanRepo] 응답: ${e.response?.data}');
      }
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

  /// 출발 제안
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

  /// 에러 메시지 파싱
  String _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          if (data.containsKey('message') && data['message'] != null) {
            return data['message'] as String;
          }
          if (data.containsKey('error')) {
            return data['error']?['message'] ?? '알 수 없는 오류가 발생했습니다.';
          }
        }
      }
      return '서버 연결에 실패했습니다.';
    }
    return e.toString();
  }
}
