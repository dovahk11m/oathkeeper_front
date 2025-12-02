import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'group_metrics_state.dart';
import 'metrics_repository.dart';

/// 그룹 통계 Notifier (폴링 지원)
class GroupMetricsNotifier extends Notifier<GroupMetricsState> {
  Timer? _pollingTimer;

  @override
  GroupMetricsState build() {
    // Notifier가 dispose될 때 폴링 중단
    ref.onDispose(() {
      _stopPolling();
    });
    return const GroupMetricsState();
  }

  /// 그룹 누적 통계 조회 (폴링 시작)
  Future<void> fetchGroupSummary(int groupId) async {
    if (groupId <= 0) return;

    // 기존 폴링 중단
    _stopPolling();

    state = state.copyWith(isLoading: true, error: null);

    try {
      final metricsRepo = ref.read(metricsRepositoryProvider);
      final summary = await metricsRepo.fetchGroupSummary(groupId);

      debugPrint(
          '[GroupMetricsNotifier] 그룹 통계 조회 성공: status=${summary.status}');

      state = state.copyWith(
        summary: summary,
        isLoading: false,
      );

      // 상태에 따라 폴링 시작/중단
      if (summary.status == 'PENDING') {
        debugPrint('[GroupMetricsNotifier] PENDING 상태 - 2초 후 재호출');
        _startPolling(groupId);
      } else {
        debugPrint('[GroupMetricsNotifier] ${summary.status} 상태 - 폴링 중단');
        _stopPolling();
      }
    } catch (e) {
      debugPrint('[GroupMetricsNotifier] 그룹 통계 조회 실패: $e');
      state = state.copyWith(
        isLoading: false,
        error: '그룹 통계 조회 실패: $e',
      );
      _stopPolling();
    }
  }

  /// 폴링 시작 (2초 간격, 재귀적 Future.delayed 사용)
  void _startPolling(int groupId) {
    _stopPolling(); // 기존 폴링 중단
    _scheduleNextPoll(groupId);
  }

  /// 다음 폴링 스케줄링 (재귀적)
  void _scheduleNextPoll(int groupId) {
    _pollingTimer = Timer(const Duration(seconds: 2), () async {
      // 이전 요청이 완료된 후에만 다음 폴링 실행
      await fetchGroupSummary(groupId);

      // PENDING 상태면 다음 폴링 스케줄링 (재귀)
      if (state.summary?.status == 'PENDING') {
        _scheduleNextPoll(groupId);
      }
    });
  }

  /// 폴링 중단
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// 상태 초기화
  void reset() {
    debugPrint('[GroupMetricsNotifier] 상태 초기화');
    _stopPolling();
    state = const GroupMetricsState();
  }
}

/// 그룹 통계 Provider
final groupMetricsProvider =
    NotifierProvider<GroupMetricsNotifier, GroupMetricsState>(
        GroupMetricsNotifier.new);
