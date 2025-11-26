import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'group_metrics_state.dart';
import 'metrics_repository.dart';

/// 그룹 통계 Notifier
class GroupMetricsNotifier extends Notifier<GroupMetricsState> {
  @override
  GroupMetricsState build() {
    return const GroupMetricsState();
  }

  /// 그룹 누적 통계 조회
  Future<void> fetchGroupSummary(int groupId) async {
    if (groupId <= 0) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final metricsRepo = ref.read(metricsRepositoryProvider);
      final summary = await metricsRepo.fetchGroupSummary(groupId);

      debugPrint('[GroupMetricsNotifier] 그룹 통계 조회 성공');

      state = state.copyWith(
        summary: summary,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('[GroupMetricsNotifier] 그룹 통계 조회 실패: $e');
      state = state.copyWith(
        isLoading: false,
        error: '그룹 통계 조회 실패: $e',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    debugPrint('[GroupMetricsNotifier] 상태 초기화');
    state = const GroupMetricsState();
  }
}

/// 그룹 통계 Provider
final groupMetricsProvider =
    NotifierProvider<GroupMetricsNotifier, GroupMetricsState>(
        GroupMetricsNotifier.new);
