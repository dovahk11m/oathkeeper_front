import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:oath_client/domain/members/auth/social_login_adapter.dart';

class FacebookLoginAdapter implements SocialLoginAdapter {
  @override
  Future<String> login() async {
    print('🟡 [FB 1] Facebook login() 호출됨');
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        print('🟡 [FB 2] 토큰 받음: ${accessToken.tokenString}');
        return accessToken.tokenString;
      } else {
        print(
            '🔴 [페이스북 로그인 취소/실패] Status: ${result.status}, Message: ${result.message}');
        throw Exception('페이스북 로그인을 취소했거나 실패했습니다: ${result.message}');
      }
    } catch (e, stackTrace) {
      print('🔴 [페이스북 로그인 실패] $e');
      print('🔴 [스택] $stackTrace');
      rethrow;
    }
  }
}
