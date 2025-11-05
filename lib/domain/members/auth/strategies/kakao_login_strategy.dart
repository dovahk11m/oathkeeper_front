import 'package:dio/dio.dart';
import 'package:oath_client/domain/members/auth/social_login.dart';

import 'login_strategy.dart';

class KakaoLoginStrategy implements LoginStrategy {
  final String code;

  KakaoLoginStrategy({required this.code});

  @override
  Future<Response> execute(Dio dio) {
    final request = SocialLogin(code: code);
    return dio.post('/member/kakao/doLogin', data: request.toJson());
  }
}
