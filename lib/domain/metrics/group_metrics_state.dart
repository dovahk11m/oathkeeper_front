import 'package:freezed_annotation/freezed_annotation.dart';

import 'group_metrics_summary.dart';
import 'metrics_state.dart'; // SummaryStatus 사용

part 'group_metrics_state.freezed.dart';

/// 그룹 통계 상태
@freezed
class GroupMetricsState with _$GroupMetricsState {
  const factory GroupMetricsState({
    // 로딩 상태
    @Default(false) bool isLoading,
    // 요약 상태 (PENDING, COMPLETED, FAILED)
    @Default(SummaryStatus.idle) SummaryStatus summaryStatus,
    // 요약 데이터
    GroupMetricsSummary? summary,
    // 에러 메시지
    String? error,
  }) = _GroupMetricsState;
}
