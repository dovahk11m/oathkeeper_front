import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_metrics_summary.freezed.dart';
part 'group_metrics_summary.g.dart';

/// 그룹 AI 요약 응답 (서버 API 스펙: METRIC_API.md)
///
/// 서버 응답 예시:
/// ```json
/// {
///   "groupId": 1,
///   "summary": "AI 요약 텍스트",
///   "status": "PENDING|COMPLETED|FAILED",
///   "lastUpdatedAt": "2025-11-26T10:00:00",
///   "reason": "상태 메시지"
/// }
/// ```
@freezed
class GroupMetricsSummary with _$GroupMetricsSummary {
  const factory GroupMetricsSummary({
    required int groupId,
    String? summary, // AI 요약 텍스트 (COMPLETED 시에만 존재)
    required String status, // PENDING, COMPLETED, FAILED
    required String lastUpdatedAt, // ISO 8601 형식
    String? reason, // PENDING/FAILED 시 상태 메시지
  }) = _GroupMetricsSummary;

  factory GroupMetricsSummary.fromJson(Map<String, dynamic> json) =>
      _$GroupMetricsSummaryFromJson(json);
}
