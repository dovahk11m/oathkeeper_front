import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_metrics_summary.freezed.dart';
part 'group_metrics_summary.g.dart';

/// 그룹 누적 통계 세부 정보
@freezed
class GroupSummaryData with _$GroupSummaryData {
  const factory GroupSummaryData({
    @JsonKey(name: 'total_plans_analyzed') int? totalPlansAnalyzed,
    @JsonKey(name: 'total_records') int? totalRecords,
    @JsonKey(name: 'total_distance_km') double? totalDistanceKm,
    @JsonKey(name: 'avg_distance_per_plan_km') double? avgDistancePerPlanKm,
    @JsonKey(name: 'total_late_minutes') int? totalLateMinutes,
    @JsonKey(name: 'avg_late_minutes_per_plan') double? avgLateMinutesPerPlan,
  }) = _GroupSummaryData;

  factory GroupSummaryData.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryDataFromJson(json);
}

/// 그룹 통계 응답 (API 응답 data 필드)
@freezed
class GroupMetricsSummary with _$GroupMetricsSummary {
  const factory GroupMetricsSummary({
    @JsonKey(name: 'group_id') int? groupId,
    @JsonKey(name: 'summary_status')
    String? summaryStatus, // PENDING, COMPLETED, FAILED
    @JsonKey(name: 'summary') String? summary,
    @JsonKey(name: 'summary_last_updated_at') String? summaryLastUpdatedAt,
    @JsonKey(name: 'total_plans_completed') int? totalPlansCompleted,
    @JsonKey(name: 'group_summary') GroupSummaryData? groupSummary,
    @JsonKey(name: 'text_summary') String? textSummary,
    String? message,
  }) = _GroupMetricsSummary;

  factory GroupMetricsSummary.fromJson(Map<String, dynamic> json) =>
      _$GroupMetricsSummaryFromJson(json);
}
