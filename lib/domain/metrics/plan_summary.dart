import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_summary.freezed.dart';
part 'plan_summary.g.dart';

/// Spring API 응답 DTO - 약속 요약 데이터
@freezed
class PlanSummaryData with _$PlanSummaryData {
  const factory PlanSummaryData({
    required int id,
    required String title,
    required String summary,
  }) = _PlanSummaryData;

  factory PlanSummaryData.fromJson(Map<String, dynamic> json) =>
      _$PlanSummaryDataFromJson(json);
}

/// Spring API 응답 DTO - 전체 응답
@freezed
class PlanSummaryResponse with _$PlanSummaryResponse {
  const factory PlanSummaryResponse({
    required bool success,
    PlanSummaryData? data,
    String? message,
  }) = _PlanSummaryResponse;

  factory PlanSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanSummaryResponseFromJson(json);
}
