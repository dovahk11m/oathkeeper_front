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
  }) = _PlanState;
}

