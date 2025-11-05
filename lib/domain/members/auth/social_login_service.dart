import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// SocialLoginService를 제공하는 Provider
final socialLoginServiceProvider = Provider<SocialLoginService>((ref) {
  return SocialLoginService();
});

/// 소셜 로그인 SDK와 관련된 모든 로직을 전담하는 서비스 클래스
class SocialLoginService {
  bool _isKakaoInitialized = false;

  /// [카카오 SDK 초기화]
  ///
  /// 처음 카카오 로그인을 시도할 때 단 한번만 실행됩니다.
  Future<void> _initKakao() async {
    if (_isKakaoInitialized) return;

    // runApp() 호출 전 Flutter Engine과 상호작용하기 위해 필요
    WidgetsFlutterBinding.ensureInitialized();
    // Kakao SDK 초기화
    KakaoSdk.init(nativeAppKey: 'YOUR_NATIVE_APP_KEY');
    _isKakaoInitialized = true;
  }

  /// [카카오 로그인]
  ///
  /// 카카오 SDK를 호출하여 Access Token을 받아온다.
  /// 실패 시 Exception을 발생시킨다.
  Future<String> signInWithKakao() async {
    await _initKakao(); // 사용 직전 초기화 (Lazy Initialization)
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      return token.accessToken;
    } catch (e) {
      rethrow; // 에러를 그대로 호출한 쪽(AuthProvider)으로 다시 던져서 처리
    }
  }

  /// [페이스북 로그인]
  ///
  /// 페이스북 SDK를 호출하여 Access Token을 받아온다.
  /// 실패 시 Exception을 발생시킨다.
  Future<String> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        return accessToken.tokenString;
      } else {
        throw Exception('페이스북 로그인을 취소했습니다.');
      }
    } catch (e) {
      rethrow; // 에러를 그대로 호출한 쪽(AuthProvider)으로 다시 던져서 처리
    }
  }
}
