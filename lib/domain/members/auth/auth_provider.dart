import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/utils/http_util.dart';
import 'package:oath_client/domain/members/auth/adapters/facebook_login_adapter.dart';
import 'package:oath_client/domain/members/auth/adapters/kakao_login_adapter.dart';
import 'package:oath_client/domain/members/auth/strategies/facebook_login_strategy.dart';
import 'package:oath_client/domain/members/auth/strategies/kakao_login_strategy.dart';
import 'package:oath_client/domain/members/auth/strategies/login_strategy.dart';

import 'auth.dart';
import 'auth_state.dart';

// =======================================================================
// 1. 의존성 주입을 위한 Provider
// =======================================================================
final secureStorageProvider = Provider((_) => const FlutterSecureStorage());

// =======================================================================
// 2. 창고 관리자 (Notifier)
// =======================================================================
class AuthNotifier extends Notifier<AuthState> {
  late final Dio _dio = ref.read(dioProvider);
  late final FlutterSecureStorage _storage = ref.read(secureStorageProvider);

  final KakaoLoginAdapter _kakaoLoginAdapter = KakaoLoginAdapter();
  final FacebookLoginAdapter _facebookLoginAdapter = FacebookLoginAdapter();

  static const _accessTokenKey = 'ACCESS_TOKEN';

  @override
  AuthState build() {
    _tryAutoLogin();
    return const AuthState();
  }

  /// 비즈니스 로직 =====================================================

  /// [카카오 로그인] - UI에서 호출
  Future<void> signInWithKakao() async {
    print('🔵 [Kakao 1] signInWithKakao 시작');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🔵 [Kakao 2] 카카오 SDK 로그인 시도');
      // [수정] 카카오 어댑터로부터 액세스 토큰을 받습니다.
      final accessToken = await _kakaoLoginAdapter.login();
      print('🔵 [Kakao 3] 카카오 액세스 토큰 받음: $accessToken');

      // [수정] 카카오 로그인 전략에 액세스 토큰을 전달합니다.
      await login(KakaoLoginStrategy(accessToken: accessToken));
      print('🔵 [Kakao 4] 서버 로그인 완료');
    } catch (e, stackTrace) {
      print('🔴 [에러] $e');
      print('🔴 [스택] $stackTrace');
      state = state.copyWith(isLoading: false, error: '카카오 로그인 실패: $e');
    }
  }

  /// [페이스북 로그인] - UI에서 호출
  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final accessToken = await _facebookLoginAdapter.login();
      await login(FacebookLoginStrategy(accessToken: accessToken));
    } catch (e) {
      debugPrint('[Facebook Login Error] $e');
      state = state.copyWith(isLoading: false, error: '페이스북 로그인 중 오류 발생: $e');
    }
  }

  /// [로그인] - 내부 로직 (LoginStrategy를 받아 실제 서버 통신)
  Future<void> login(LoginStrategy strategy) async {
    try {
      final response = await strategy.execute(_dio);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final dataMap = apiResponse.data!;
        final accessToken = dataMap['token'] as String?;
        final memberData = dataMap['member'] as Map<String, dynamic>?;

        if (accessToken == null || memberData == null) {
          throw Exception('로그인 응답 형식이 올바르지 않습니다.');
        }

        await _storage.write(key: _accessTokenKey, value: accessToken);
        final authData = Auth.fromJson(memberData);

        state = state.copyWith(auth: authData, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "로그인에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// [로그아웃]
  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AuthState();
  }

  /// [자동 로그인]
  Future<void> _tryAutoLogin() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final memberId = _getMemberIdFromToken(accessToken);
      final response = await _dio.get('/member/$memberId');
      final apiResponse = ApiResponse<Auth>.fromJson(
        response.data,
        (json) => Auth.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        state = state.copyWith(auth: apiResponse.data, isLoading: false);
      } else {
        await logout();
      }
    } catch (e) {
      await logout();
    }
  }

  /// [아이디 찾기]
  Future<String> findId(String email) async {
    try {
      final response =
          await _dio.post('/member/find-id', data: {'email': email});
      final apiResponse = ApiResponse<String>.fromJson(
        response.data,
        (json) => json as String,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "아이디 찾기에 실패했습니다.";
      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// JWT 토큰에서 memberId를 추출하는 헬퍼 메소드
  int _getMemberIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw const FormatException('Invalid token');
      final payload = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      return payload['memberId'] as int;
    } catch (e) {
      throw const FormatException('Invalid memberId in token');
    }
  }

  /// ======== TokenInterceptor에서 호출하는 내부 관리용 메소드들 =========

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> storeNewTokens(String accessToken, String? refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<void> handleSessionInvalidation(String errorMessage) async {
    await logout();
    state = state.copyWith(error: errorMessage);
  }
}

// =======================================================================
// 3. 창고 (Provider)
// =======================================================================

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// =======================================================================
// 4. 사이드 이펙트 (Side-effects) / 계산된 상태 (Computed State)
// =======================================================================

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).auth != null;
});
