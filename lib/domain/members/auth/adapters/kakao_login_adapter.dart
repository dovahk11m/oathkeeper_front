// KakaoLoginAdapter.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:oath_client/domain/members/auth/social_login_adapter.dart';

class KakaoLoginAdapter implements SocialLoginAdapter {
  // 1. SDK가 초기화되었는지 확인하는 플래그
  static bool _isInitialized = false;

  // 2. 어댑터 내부에 SDK 초기화 메서드 생성
  Future<void> _initialize() async {
    // 이미 초기화되었다면 중복 실행 방지
    if (_isInitialized) return;

    try {
      // .env 파일 로드
      await dotenv.load(fileName: ".env");
      final kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];

      if (kakaoNativeAppKey == null) {
        throw Exception('KAKAO_NATIVE_APP_KEY is not set in .env file');
      }

      // 카카오 SDK 초기화
      KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);
      _isInitialized = true;
      print('Kakao SDK in Adapter Initialized.');
    } catch (e) {
      print('Kakao SDK in Adapter Failed to Initialize: $e');
      rethrow;
    }
  }

  @override
  Future<String> login() async {
    // 3. 로그인 시도 시, 먼저 SDK 초기화 보장
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
      print('카카오 로그인 실패: $e');
      rethrow;
    }
  }
}
