// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_plan.freezed.dart';
part 'simple_plan.g.dart';

/// 약속 목록 조회용 간단한 DTO
@freezed
class SimplePlan with _$SimplePlan {
  const SimplePlan._();

  const factory SimplePlan({
    required int planId,
    required String title,
    required String planDatetime,
    String? status, // PLANNING, CONFIRMED, COMPLETED, CANCELLED
  }) = _SimplePlan;

  factory SimplePlan.fromJson(Map<String, dynamic> json) =>
      _$SimplePlanFromJson(json);

  bool get isCompleted => status?.toUpperCase() == 'COMPLETED';
}

/// 약속 목록 응답 (페이징 포함)
@freezed
class PlanListResponse with _$PlanListResponse {
  const factory PlanListResponse({
    @JsonKey(name: 'content') required List<SimplePlan> items,
    @JsonKey(name: 'page') required int currentPage,
    @JsonKey(name: 'totalPage') required int totalPages,
    required int totalElements,
    @JsonKey(name: 'last') required bool isLast,
  }) = _PlanListResponse;

  factory PlanListResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanListResponseFromJson(json);
}
