import 'package:freezed_annotation/freezed_annotation.dart';

import 'group_metrics_summary.dart';

part 'group_metrics_state.freezed.dart';

/// 그룹 통계 상태
@freezed
class GroupMetricsState with _$GroupMetricsState {
  const factory GroupMetricsState({
    @Default(false) bool isLoading,
    GroupMetricsSummary? summary,
    String? error,
  }) = _GroupMetricsState;
}
