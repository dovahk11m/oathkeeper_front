/// 모든 소셜 로그인 방식이 따라야 하는 통일된 규격 (인터페이스)
///
/// 이 어댑터는 각 소셜 로그인 SDK의 복잡한 과정을 숨기고,
/// 서버에 전달해야 할 "인증 코드"(Authorization Code 또는 Access Token)를
/// 반환하는 단 하나의 책임만 가집니다.
abstract class SocialLoginAdapter {
  Future<String> login();
}
