import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../groups/group_repository.dart';
import 'plan_list_state.dart';

/// 약속 목록 Notifier
class PlanListNotifier extends Notifier<PlanListState> {
  @override
  PlanListState build() {
    return const PlanListState();
  }

  /// 그룹 내 약속 목록 조회
  Future<void> fetchGroupPlans(int groupId, {String? status}) async {
    if (groupId <= 0) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final groupRepo = ref.read(groupRepositoryProvider);
      final response = await groupRepo.fetchGroupPlans(groupId, status: status);

      debugPrint('[PlanListNotifier] 약속 목록 조회 성공: ${response.items.length}개');

      state = state.copyWith(
        plans: response.items,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('[PlanListNotifier] 약속 목록 조회 실패: $e');
      state = state.copyWith(
        isLoading: false,
        error: '약속 목록 조회 실패: $e',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    debugPrint('[PlanListNotifier] 상태 초기화');
    state = const PlanListState();
  }
}

/// 약속 목록 Provider
final planListProvider =
    NotifierProvider<PlanListNotifier, PlanListState>(PlanListNotifier.new);
