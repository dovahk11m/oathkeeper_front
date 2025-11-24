import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'metrics_repository.dart';
import 'metrics_state.dart';

/// 메트릭 Notifier - 폴링 로직 포함
class MetricsNotifier extends Notifier<MetricsState> {
  Timer? _pollingTimer;

  @override
  MetricsState build() {
    // Notifier가 dispose될 때 폴링 중단
    ref.onDispose(() {
      cancelSummaryPolling();
    });
    return const MetricsState();
  }

  /// AI 요약 폴링 시작
  Future<void> pollPlanSummary(int planId) async {
    debugPrint('[MetricsNotifier] AI 요약 폴링 시작: planId=$planId');

    // 기존 폴링 취소
    cancelSummaryPolling();

    // 로딩 상태로 전환
    state = state.copyWith(
      isSummaryLoading: true,
      summaryStatus: SummaryStatus.processing,
      error: null,
    );

    // 첫 번째 요청 즉시 실행
    await _fetchSummary(planId);

    // 폴링 시작 (3초 간격)
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _fetchSummary(planId);
    });
  }

  /// 요약 조회 (내부 메서드)
  Future<void> _fetchSummary(int planId) async {
    try {
      final repo = ref.read(metricsRepositoryProvider);
      final response = await repo.fetchPlanSummary(planId);

      // 완료 상태 확인: success && data != null
      final isCompleted = response.success && response.data != null;
      // 생성 중 상태 확인: success && data == null && message != null
      final isProcessing =
          response.success && response.data == null && response.message != null;

      if (isCompleted && response.data != null) {
        // 완료 → 폴링 중단
        debugPrint('[MetricsNotifier] AI 요약 완료');
        cancelSummaryPolling();
        state = state.copyWith(
          isSummaryLoading: false,
          summaryStatus: SummaryStatus.completed,
          summaryText: response.data!.summary,
          summaryPlanId: response.data!.id,
          summaryTitle: response.data!.title,
          error: null,
        );
      } else if (isProcessing) {
        // 계속 대기
        debugPrint('[MetricsNotifier] AI 요약 생성 중... (${response.message})');
      } else {
        // 예상치 못한 응답
        debugPrint('[MetricsNotifier] 예상치 못한 응답: $response');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      String errorMessage;

      if (statusCode == 404) {
        errorMessage = '활성화된 약속이 없습니다.';
      } else if (statusCode == 409) {
        errorMessage = '아직 메트릭 데이터가 집계되지 않았습니다.';
      } else if (statusCode == 500) {
        errorMessage = 'AI 요약 생성에 실패했습니다.';
      } else {
        errorMessage = '요약 조회 중 오류가 발생했습니다: ${e.message}';
      }

      debugPrint(
          '[MetricsNotifier] 에러 발생: $errorMessage (status: $statusCode)');

      // 에러 → 폴링 중단
      cancelSummaryPolling();
      state = state.copyWith(
        isSummaryLoading: false,
        summaryStatus: SummaryStatus.failed,
        error: errorMessage,
      );
    } catch (e) {
      debugPrint('[MetricsNotifier] 예외 발생: $e');

      // 에러 → 폴링 중단
      cancelSummaryPolling();
      state = state.copyWith(
        isSummaryLoading: false,
        summaryStatus: SummaryStatus.failed,
        error: '요약 조회 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 폴링 중단
  void cancelSummaryPolling() {
    if (_pollingTimer != null) {
      debugPrint('[MetricsNotifier] 폴링 중단');
      _pollingTimer?.cancel();
      _pollingTimer = null;
    }
  }

  /// 상태 초기화
  void resetSummary() {
    cancelSummaryPolling();
    state = const MetricsState();
  }
}

/// 메트릭 Provider
final metricsProvider =
    NotifierProvider<MetricsNotifier, MetricsState>(MetricsNotifier.new);
