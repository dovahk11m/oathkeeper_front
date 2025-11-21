import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oath_client/domain/plans/plan.dart';

part 'plan_state.freezed.dart';

/// 플랜 화면 상태
@freezed
class PlanState with _$PlanState {
  const factory PlanState({
    @Default([]) List<Plan> plans,
    Plan? selectedPlan,
    @Default(false) bool isLoading,
    String? error,

    // AI 요약 관련 상태
    @Default(false) bool isSummaryLoading, // 요약 로딩 중
    String? summaryStatus, // NONE, IN_PROGRESS, COMPLETED, FAILED
    Map<String, dynamic>? summary, // 요약 결과
  }) = _PlanState;
}
