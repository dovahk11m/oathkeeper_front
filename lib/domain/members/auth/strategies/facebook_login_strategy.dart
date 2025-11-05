import 'package:dio/dio.dart';
import 'package:oath_client/domain/members/auth/social_login.dart';

import 'login_strategy.dart';

class FacebookLoginStrategy implements LoginStrategy {
  final String code;

  FacebookLoginStrategy({required this.code});

  @override
  Future<Response> execute(Dio dio) {
    final request = SocialLogin(code: code);
    return dio.post('/member/facebook/doLogin', data: request.toJson());
  }
}
