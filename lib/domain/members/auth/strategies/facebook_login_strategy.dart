import 'package:dio/dio.dart';
import 'package:oath_client/domain/members/auth/social_login.dart';

import 'login_strategy.dart';

class FacebookLoginStrategy implements LoginStrategy {
  // [수정] code -> accessToken으로 파라미터명 변경
  final String accessToken;

  FacebookLoginStrategy({required this.accessToken});

  @override
  Future<Response> execute(Dio dio) {
    print('🔵 [FB Strategy] 실행됨. 서버에 아래 데이터로 요청 전송:');
    print({'access_token': accessToken});

    // [수정] API 명세에 맞는 URL과 데이터 형식으로 수정
    return dio.post(
      '/member/facebook/doLogin',
      data: {'access_token': accessToken},
    );
  }
}
