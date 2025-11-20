import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/plans/plan.dart';
import 'package:oath_client/domain/plans/plan_repository.dart';
import 'package:oath_client/domain/plans/plan_state.dart';

/// 플랜 상태
final planProvider = NotifierProvider<PlanNotifier, PlanState>(() {
  return PlanNotifier();
});

class PlanNotifier extends Notifier<PlanState> {
  late final PlanRepository _repository;

  @override
  PlanState build() {
    _repository = ref.read(planRepositoryProvider);
    Future.microtask(() => loadPlans());
    return const PlanState();
  }

  /// 목록 로드
  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('[PlanProvider] 약속 목록 로드 시작');
      final plans = await _repository.getPlans();
      print('[PlanProvider] 약속 목록 로드 완료: ${plans.length}개');
      state = state.copyWith(plans: plans, isLoading: false);
    } catch (e) {
      print('[PlanProvider] 약속 목록 로드 실패: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 상세 로드
  Future<void> loadPlanDetail(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final plan = await _repository.getPlanById(id);
      state = state.copyWith(selectedPlan: plan, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 생성 (참가자 포함)
  Future<Plan?> createPlanWithParticipants({
    required String title,
    required DateTime planDatetime,
    String? location,
    int? lateFineAmount,
    List<String>? tags,
    List<int>? participantIds,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('[PlanProvider] 약속 생성 시작: $title');

      // 1. 플랜 생성
      final plan = await _repository.createPlan(
        title: title,
        planDatetime: planDatetime,
        location: location,
        lateFineAmount: lateFineAmount,
        tags: tags,
      );

      print('[PlanProvider] 약속 생성 완료: ${plan.id}');

      // 2. 참가자 추가
      if (participantIds != null && participantIds.isNotEmpty) {
        print('[PlanProvider] 참가자 추가 시작: $participantIds');
        try {
          for (final memberId in participantIds) {
            print(
                '[PlanProvider] 참가자 추가 중: memberId=$memberId, planId=${plan.id}');
            await _repository.addParticipant(
                planId: plan.id, memberId: memberId);
          }
          print('[PlanProvider] 참가자 추가 완료');
        } catch (e) {
          print('[PlanProvider] 참가자 추가 실패: $e');
        }

        // 3. 업데이트된 플랜 조회 시도 (실패해도 계속 진행)
        Plan? updatedPlan;
        try {
          print('[PlanProvider] 업데이트된 플랜 조회 시도: ${plan.id}');
          updatedPlan = await _repository.getPlanById(plan.id);
          print('[PlanProvider] 플랜 조회 성공');
        } catch (e) {
          print('[PlanProvider] 플랜 조회 실패 (무시하고 계속): $e');
          updatedPlan = plan;
        }

        // 4. 목록 갱신
        await loadPlans();

        state = state.copyWith(isLoading: false);
        print('[PlanProvider] 약속 생성 및 참가자 추가 완료');
        return updatedPlan;
      }

      // 참가자 없으면 바로 반환
      await loadPlans();
      state = state.copyWith(isLoading: false);
      print('[PlanProvider] 약속 생성 완료 (참가자 없음)');
      return plan;
    } catch (e) {
      print('[PlanProvider] 약속 생성 실패: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
      return null;
    }
  }

  /// 수정
  Future<void> updatePlan({
    required int id,
    String? title,
    DateTime? planDatetime,
    String? location,
    int? lateFineAmount,
    List<String>? tags,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updatePlan(
        id: id,
        title: title,
        planDatetime: planDatetime,
        location: location,
        lateFineAmount: lateFineAmount,
        tags: tags,
      );
      await loadPlans();
      if (state.selectedPlan?.id == id) {
        await loadPlanDetail(id);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 삭제
  Future<void> deletePlan(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deletePlan(id);
      await loadPlans();
      if (state.selectedPlan?.id == id) {
        state = state.copyWith(selectedPlan: null);
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 장소 확정
  Future<void> confirmPlace({
    required int planId,
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('[PlanProvider] 장소 확정 시작: planId=$planId, location=$location');
      await _repository.confirmPlace(
        planId: planId,
        location: location,
        latitude: latitude,
        longitude: longitude,
      );
      print('[PlanProvider] 장소 확정 완료');

      print('[PlanProvider] 약속 상세 조회 시작');
      await loadPlanDetail(planId);
      print('[PlanProvider] 약속 상세 조회 완료');

      print('[PlanProvider] 약속 목록 갱신 시작');
      await loadPlans();
      print('[PlanProvider] 약속 목록 갱신 완료');

      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('[PlanProvider] 장소 확정 실패: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  /// 참가자 추가
  Future<void> addParticipant({
    required int planId,
    required int memberId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.addParticipant(planId: planId, memberId: memberId);
      await loadPlanDetail(planId);
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 참가자 삭제
  Future<void> removeParticipant({
    required int planId,
    required int participantId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.removeParticipant(
        planId: planId,
        participantId: participantId,
      );
      await loadPlanDetail(planId);
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 참가 수락/거절
  Future<void> updateParticipantStatus({
    required int participantId,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateParticipantStatus(
        participantId: participantId,
        status: status,
      );
      if (state.selectedPlan != null) {
        await loadPlanDetail(state.selectedPlan!.id);
      }
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 출발 기록
  Future<void> recordDeparture(int participantId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.recordDeparture(participantId);
      if (state.selectedPlan != null) {
        await loadPlanDetail(state.selectedPlan!.id);
      }
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 도착 기록
  Future<void> recordArrival(int participantId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.recordArrival(participantId);
      if (state.selectedPlan != null) {
        await loadPlanDetail(state.selectedPlan!.id);
      }
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 플랜 수동 완료 (생성자가 직접 종료)
  Future<void> completePlan(int planId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.completePlan(planId);
      // 상세/목록 갱신
      await loadPlanDetail(planId);
      await loadPlans();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  /// 출발 제안
  Future<void> suggestDeparture({
    required int participantId,
    required String transportMethod,
    required int expectedTravelTimeMinutes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.suggestDeparture(
        participantId: participantId,
        transportMethod: transportMethod,
        expectedTravelTimeMinutes: expectedTravelTimeMinutes,
      );
      if (state.selectedPlan != null) {
        await loadPlanDetail(state.selectedPlan!.id);
      }
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 지각 벌금 조회
  Future<int?> getLateFine(int participantId) async {
    try {
      return await _repository.getLateFine(participantId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}
