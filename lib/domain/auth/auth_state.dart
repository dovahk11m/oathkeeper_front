import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    // 인증된 사용자 정보
    Auth? auth,
    // 로딩 상태
    @Default(false) bool isLoading,
    // 에러 메시지
    String? error,
  }) = _AuthState;
}
