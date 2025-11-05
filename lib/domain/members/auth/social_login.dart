import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_login.freezed.dart';
part 'social_login.g.dart';

@freezed
class SocialLogin with _$SocialLogin {
  const factory SocialLogin({
    required String code,
  }) = _SocialLogin;

  factory SocialLogin.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginFromJson(json);
}
