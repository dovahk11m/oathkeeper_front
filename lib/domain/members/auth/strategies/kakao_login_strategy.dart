import 'package:dio/dio.dart';
import 'package:oath_client/domain/members/auth/social_login.dart';

import 'login_strategy.dart';

// kakao_login_strategy.dart
class KakaoLoginStrategy implements LoginStrategy {
  final String accessToken; // code → accessToken

  KakaoLoginStrategy({required this.accessToken});

  @override
  Future<Response> execute(Dio dio) {
    return dio.post('/member/kakao/token', // 엔드포인트 수정
        data: {'access_token': accessToken} // 필드명 수정
        );
  }
}
