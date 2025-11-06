import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:oath_client/domain/members/auth/social_login_adapter.dart';

class KakaoLoginAdapter implements SocialLoginAdapter {
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    await dotenv.load(fileName: ".env");
    final kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
    if (kakaoNativeAppKey == null) {
      throw Exception('KAKAO_NATIVE_APP_KEY is not set in .env file');
    }

    WidgetsFlutterBinding.ensureInitialized();
    KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
    _isInitialized = true;
  }

  @override
  Future<String> login() async {
    await _initialize();
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      return token.accessToken;
    } catch (e) {
      rethrow;
    }
  }
}
