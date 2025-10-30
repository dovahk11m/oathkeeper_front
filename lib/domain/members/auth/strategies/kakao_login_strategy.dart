import 'package:dio/dio.dart';

import 'login_strategy.dart';

class KakaoLoginStrategy implements LoginStrategy {
  final String code;

  KakaoLoginStrategy({required this.code});

  @override
  Future<Response> execute(Dio dio) {
    return dio.post('/member/kakao/doLogin', data: {'code': code});
  }
}
