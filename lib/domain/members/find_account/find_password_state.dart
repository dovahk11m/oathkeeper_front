import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_password_state.freezed.dart';

@freezed
class FindPasswordState with _$FindPasswordState {
  const factory FindPasswordState({
    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 성공 시 표시될 메시지
    String? successMessage,

    /// 에러 발생 시 표시될 메시지
    String? error,
  }) = _FindPasswordState;
}
