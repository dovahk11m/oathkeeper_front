import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/utils/http_util.dart';
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
          final transformed =
              _transformPlanResponse(json as Map<String, dynamic>);
          return Plan.fromJson(transformed);
        }).toList();
      }

      return [];
    } catch (e) {
      print('[PlanRepo] 약속 목록 조회 실패: $e');
      throw _handleError(e);
    }
  }

  // PlanRepository 내부에 추가
  Future<int?> fetchActivePlanIdByGroup(int groupId) async {
    try {
      // ✅ 1안: 서버가 “활성 플랜 1건”을 돌려주는 전용 라우트가 있을 때
      // 기대 응답: { success:true, data:{ id:4, ... } }
      final res = await _dio.get('/plans/group/$groupId/active');

      if (res.data is Map && res.data['success'] == true) {
        final data = res.data['data'];
        if (data is Map && data['id'] != null) {
          return (data['id'] as num).toInt();
        }
      }

      // ✅ 2안(대체): 전용 라우트가 없다면 목록에서 “가장 가까운 미래/진행중”을 고르기
      // 예: /plans?groupId=...&size=20&sort=planDatetime,desc
      final listRes = await _dio.get(
        '/plans',
        queryParameters: {
          'groupId': groupId,
          'size': 20,
          'sort': 'planDatetime,desc', // 필요에 맞게 조정
        },
      );
      if (listRes.data is Map && listRes.data['success'] == true) {
        final List items = (listRes.data['data'] as List?) ?? [];
        if (items.isEmpty) return null;

        // 서버 응답을 Plan 모델 스키마로 변환해서 비교
        final plans = items.map((e) {
          final transformed = _transformPlanResponse(e as Map<String, dynamic>);
          return Plan.fromJson(transformed);
        }).toList();

        // 1) 상태가 진행중(예: PLANNING/CONFIRMED/OPEN 등)인 것 우선
        const activeStatuses = {'PLANNING', 'CONFIRMED', 'OPEN', 'ACTIVE'};
        plans.sort((a, b) => a.planDatetime.compareTo(b.planDatetime));
        final now = DateTime.now();

        // 미래이면서 active 상태인 것 중 가장 가까운 것
        final futureActive = plans.firstWhere(
          (p) =>
              p.planDatetime.isAfter(now) && activeStatuses.contains(p.status),
          orElse: () => plans.first,
        );
        return futureActive.id;
      }

      return null;
    } catch (_) {
      return null;
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

      final transformed =
          _transformPlanResponse(planData as Map<String, dynamic>);
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

  /// AI 요약 보고서 조회 (폴링)
  ///
  /// 서버 응답에 따라 status code가 다르므로 Dio Response 객체 전체를 반환한다.
  /// - 200 OK: 요약 완료. response.data에 요약 내용 포함.
  /// - 202 Accepted: 요약 처리 중. response.data는 null일 수 있음.
  Future<Response> getPlanSummary(int planId) async {
    try {
      print('[PlanRepo] AI 요약 요청: planId=$planId');
      final response = await _dio.get('/plans/$planId/summary');
      print('[PlanRepo] AI 요약 응답: ${response.statusCode}');
      return response;
    } catch (e) {
      print('[PlanRepo] AI 요약 요청 실패: $e');
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
    DateTime? _parseDateTime(dynamic raw) {
      if (raw == null) return null;
      if (raw is DateTime) return raw;
      if (raw is String && raw.isNotEmpty) {
        try {
          return DateTime.parse(raw);
        } catch (_) {
          // 일부 API가 "2025-11-20 10:00" 형태라면 공백을 T로 치환해 시도
          try {
            return DateTime.parse(raw.replaceFirst(' ', 'T'));
          } catch (_) {
            return null;
          }
        }
      }
      return null;
    }

    // date+time 조합 혹은 planDatetime 단일 필드 지원
    final date = apiData['date'] as String?;
    final time = apiData['time'] as String?;
    final planDatetimeRaw = apiData['planDatetime'] ?? apiData['plan_datetime'];

    DateTime? planDatetimeDt;
    if (planDatetimeRaw != null) {
      planDatetimeDt = _parseDateTime(planDatetimeRaw);
    }
    planDatetimeDt ??=
        (date != null && time != null) ? _parseDateTime('${date}T${time}') : null;
    planDatetimeDt ??= DateTime.now();

    // completedAt 처리 (각종 키 지원)
    final completedAtRaw = apiData['completedAt'] ??
        apiData['completed_at'] ??
        apiData['completedAtUtc'] ??
        apiData['completed_at_utc'] ??
        apiData['completedDatetime'] ??
        apiData['completed_datetime'];
    DateTime? completedAtDt = _parseDateTime(completedAtRaw);

    // participants 변환
    final rawParticipants = apiData['participants'] as List<dynamic>?;
    final transformedParticipants = rawParticipants?.map((p) {
          final participant = p as Map<String, dynamic>;
          return {
            'id': participant['id'],
            'memberId': participant['memberId'],
            'memberNickname': participant['memberNickname'] ??
                participant['nickname'] ??
                '이름 없음',
            'memberProfileImageUrl': participant['memberProfileImageUrl'],
            'participantStatus': participant['participantStatus'] ?? 'PENDING',
            'transportMethod': participant['transportMethod'],
            'expectedTravelTimeMinutes':
                participant['expectedTravelTimeMinutes'],
            'expectedDepartureTime': participant['expectedDepartureTime'],
            'actualDepartureTime': participant['actualDepartureTime'],
            'actualArrivalTime': participant['actualArrivalTime'],
            'arrivalStatus': participant['arrivalStatus'],
            'timeBurdenMinutes': participant['timeBurdenMinutes'],
          };
        }).toList() ??
        [];

    final rawStatus = apiData['status'] ?? apiData['planStatus'] ?? 'PLANNING';
    final normalizedStatus = rawStatus.toString().toUpperCase();

    if (completedAtDt == null && normalizedStatus == 'COMPLETED') {
      // 서버가 완료 시간을 주지 않는 경우, 최소한 플랜 시간 이후라는 가정으로 fallback
      completedAtDt = planDatetimeDt;
    }

    return {
      'id': apiData['id'] ?? 0,
      'title': apiData['title'] ?? '',
      'planDatetime': planDatetimeDt.toIso8601String(),
      'status': normalizedStatus,
      'location': apiData['location'],
      'placeLatitude': apiData['placeLatitude'],
      'placeLongitude': apiData['placeLongitude'],
      'lateFineAmount': apiData['lateFineAmount'],
      'creatorMember': {
        // 서버 응답에 creatorMember가 있으면 사용, 없으면 로그인 정보 fallback
        'id': (apiData['creatorMember'] is Map
                ? (apiData['creatorMember']['id'] ??
                    _ref.read(authProvider).auth?.id)
                : _ref.read(authProvider).auth?.id) ??
            0,
        'email': (apiData['creatorMember'] is Map
                ? (apiData['creatorMember']['email'] ??
                    _ref.read(authProvider).auth?.email)
                : _ref.read(authProvider).auth?.email) ??
            '',
        'nickname': (apiData['creatorMember'] is Map
                ? (apiData['creatorMember']['nickname'] ??
                    _ref.read(authProvider).auth?.username)
                : _ref.read(authProvider).auth?.username) ??
            '',
        'profileImageUrl': (apiData['creatorMember'] is Map
            ? apiData['creatorMember']['profileImageUrl']
            : null),
      },
      'participants': transformedParticipants,
      'tags': apiData['tags'] ?? [],
      'completedAt': completedAtDt?.toIso8601String(),
    };
  }

  /// 플랜 완료 여부 사전 검증 (리뷰 작성 전에 호출)
  Future<bool> isPlanCompleted(int planId) async {
    try {
      final res = await _dio.get('/plans/$planId');
      if (res.data['success'] != true) return false;
      final data = res.data['data'];
      if (data is Map) {
        final status = (data['status'] ?? data['planStatus'] ?? '')
            .toString()
            .toUpperCase();
        final completedAt = data['completedAt'];
        return status == 'COMPLETED' &&
            completedAt is String &&
            completedAt.isNotEmpty;
      }
      return false;
    } catch (_) {
      return false;
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
          if (planDatetime != null)
            'planDatetime': planDatetime.toIso8601String(),
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
          'longitude': longitude,
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
      print('[PlanRepo] 참가자 추가 응답: \${response.data}');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '참가자 추가 실패');
      }
    } catch (e) {
      print('[PlanRepo] 참가자 추가 실패: $e');
      if (e is DioException) {
        print('[PlanRepo] 상태: \${e.response?.statusCode}');
        print('[PlanRepo] 응답: \${e.response?.data}');
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

  /// 플랜 수동 완료 (생성자가 수동으로 플랜을 완료할 때 사용)
  Future<void> completePlan(int planId) async {
    try {
      await _dio.post('/plans/$planId/complete');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 지각 벌금 조회
  Future<int> getLateFine(int participantId) async {
    try {
      final response =
          await _dio.get('/plans/participants/$participantId/late-fine');
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
