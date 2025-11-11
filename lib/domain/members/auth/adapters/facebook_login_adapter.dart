import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:oath_client/domain/members/auth/social_login_adapter.dart';

class FacebookLoginAdapter implements SocialLoginAdapter {
  @override
  Future<String> login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      return result.accessToken!.tokenString;
    } else {
      throw Exception('페이스북 로그인을 취소했습니다.');
    }
  }
}
