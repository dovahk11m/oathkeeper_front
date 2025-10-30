import 'package:dio/dio.dart';

/// 모든 로그인 전략이 구현해야 하는 인터페이스(추상 클래스)
abstract class LoginStrategy {
  /// 이 메소드는 실제 로그인 API를 호출하고, 성공 시 Dio의 Response 객체를 반환해야 합니다.
  Future<Response> execute(Dio dio);
}
