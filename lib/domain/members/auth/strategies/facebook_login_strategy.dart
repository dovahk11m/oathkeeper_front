import 'package:dio/dio.dart';

import 'login_strategy.dart';

class FacebookLoginStrategy implements LoginStrategy {
  final String code;

  FacebookLoginStrategy({required this.code});

  @override
  Future<Response> execute(Dio dio) {
    return dio.post('/member/facebook/doLogin', data: {'code': code});
  }
}
