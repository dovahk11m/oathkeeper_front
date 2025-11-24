import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_plan.freezed.dart';
part 'simple_plan.g.dart';

/// 약속 목록 조회용 간단한 DTO
@freezed
class SimplePlan with _$SimplePlan {
  const factory SimplePlan({
    required int planId,
    required String title,
    required String planDatetime,
  }) = _SimplePlan;

  factory SimplePlan.fromJson(Map<String, dynamic> json) =>
      _$SimplePlanFromJson(json);
}

/// 약속 목록 응답 (페이징 포함)
@freezed
class PlanListResponse with _$PlanListResponse {
  const factory PlanListResponse({
    required List<SimplePlan> items,
    required int currentPage,
    required int totalPages,
    required int totalElements,
    required bool isFirst,
    required bool isLast,
  }) = _PlanListResponse;

  factory PlanListResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanListResponseFromJson(json);
}
