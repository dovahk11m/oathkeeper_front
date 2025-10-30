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
    loadPlans();
    return const PlanState();
  }

  /// 목록 로드
  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final plans = await _repository.getPlans();
      state = state.copyWith(plans: plans, isLoading: false);
    } catch (e) {
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
      // 1. 플랜 생성
      final plan = await _repository.createPlan(
        title: title,
        planDatetime: planDatetime,
        location: location,
        lateFineAmount: lateFineAmount,
        tags: tags,
      );

      // 2. 참가자 추가
      if (participantIds != null && participantIds.isNotEmpty) {
        await Future.wait(
          participantIds.map((memberId) =>
            _repository.addParticipant(planId: plan.id, memberId: memberId)
          ),
        );

        // 3. 업데이트된 플랜 조회
        final updatedPlan = await _repository.getPlanById(plan.id);

        // 4. 목록 갱신
        await loadPlans();

        state = state.copyWith(isLoading: false);
        return updatedPlan;
      }

      // 참가자 없으면 바로 반환
      await loadPlans();
      state = state.copyWith(isLoading: false);
      return plan;
    } catch (e) {
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
      await _repository.confirmPlace(
        planId: planId,
        location: location,
        latitude: latitude,
        longitude: longitude,
      );
      await loadPlanDetail(planId);
      await loadPlans();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
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
