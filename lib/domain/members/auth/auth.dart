import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_enum.dart';

part 'auth.freezed.dart';

part 'auth.g.dart';

/// 로그인 시 서버로부터 받아오는 사용자 인증 정보 DTO
@freezed
class Auth with _$Auth {
  const factory Auth({
    required int id,
    required String username,
    String? profileImageUrl,
    required String email,
    required Role role,
    SocialType? socialType,
    required Status status,

    // 서버 응답 필드 이름(is_premium)과 Dart 필드 이름(isPremium)이 다를 경우
    @Default(false) bool isPremium,
  }) = _Auth;

  /// JSON으로부터 AuthDto 객체를 생성하는 팩토리 생성자
  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}
