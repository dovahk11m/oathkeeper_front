import 'package:freezed_annotation/freezed_annotation.dart';
import 'simple_plan.dart';

part 'plan_list_state.freezed.dart';

/// 약속 목록 상태
@freezed
class PlanListState with _$PlanListState {
  const factory PlanListState({
    @Default([]) List<SimplePlan> plans,
    @Default(false) bool isLoading,
    String? error,
  }) = _PlanListState;
}
