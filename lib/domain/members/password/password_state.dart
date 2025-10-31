import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_state.freezed.dart';

@freezed
class PasswordState with _$PasswordState {
  const factory PasswordState({
    @Default(false) bool isLoading,
    @Default(false) bool isPasswordChecked,
    @Default(false) bool isSuccess,
    String? errorMessage,
    String? verifiedPassword, // 비밀번호 확인 시, 검증된 현재 비밀번호를 저장
  }) = _PasswordState;
}
