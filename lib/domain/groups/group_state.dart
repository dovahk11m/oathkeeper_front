import 'package:freezed_annotation/freezed_annotation.dart';

import 'group_summary.dart';

part 'group_state.freezed.dart';

@freezed
class GroupState with _$GroupState {
  const factory GroupState({
    // 그룹 목록 데이터
    @Default([]) List<GroupSummary> groups,
    // 로딩 상태
    @Default(false) bool isLoading,
    // 에러 메시지
    String? error,
  }) = _GroupState;
}
