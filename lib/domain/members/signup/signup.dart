import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup.freezed.dart';
part 'signup.g.dart';

/// 회원가입 시 서버로 보내는 사용자 정보 DTO
@freezed
class Signup with _$Signup {
  const factory Signup({
    required String username,
    required String email,
    required String password,
    required List<int> agreedTermIds,
  }) = _Signup;

  /// JSON으로부터 Signup 객체를 생성하는 팩토리 생성자
  factory Signup.fromJson(Map<String, dynamic> json) => _$SignupFromJson(json);
}
