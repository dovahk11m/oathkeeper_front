import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oath_client/common/http_util.dart';

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

  static const _accessTokenKey = 'ACCESS_TOKEN';
  // static const _refreshTokenKey = 'REFRESH_TOKEN'; // 새 명세에 없음

  @override
  AuthState build() {
    _tryAutoLogin();
    return const AuthState();
  }

  /// 비즈니스 로직 =====================================================

  /// [로그인 공통 로직] - 새로운 명세 기반의 1단계 흐름
  Future<void> _performLogin(Future<Response> Function() apiCall) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiCall();

      // 1. 응답에서 토큰과 사용자 정보(member)를 직접 추출
      final accessToken = response.data['token'] as String?;
      final memberData = response.data['member'] as Map<String, dynamic>?;

      if (accessToken == null || memberData == null) {
        throw Exception('로그인 응답 형식이 올바르지 않습니다.');
      }

      // 2. 토큰을 저장하고, 사용자 정보로 상태를 업데이트
      await _storage.write(key: _accessTokenKey, value: accessToken);
      final authData = Auth.fromJson(memberData);

      state = state.copyWith(auth: authData, isLoading: false);
      print("[AuthNotifier] 로그인 성공: ${authData.username}");
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "로그인에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// [일반 로그인]
  Future<void> login(String email, String password) =>
      _performLogin(() => _dio.post(
            '/member/login',
            data: {'email': email, 'password': password},
          ));

  /// [카카오 로그인]
  Future<void> kakaoLogin(String code) => _performLogin(
      () => _dio.post('/member/kakao/doLogin', data: {'code': code}));

  /// [페이스북 로그인]
  Future<void> facebookLogin(String code) => _performLogin(
      () => _dio.post('/member/facebook/doLogin', data: {'code': code}));

  /// [로그아웃]
  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AuthState();
    print("[AuthNotifier] 로그아웃 성공");
  }

  /// [자동 로그인]
  Future<void> _tryAutoLogin() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return;

    state = state.copyWith(isLoading: true);
    try {
      // 토큰이 유효한지 확인하기 위해, 토큰을 디코딩하여 내 정보를 다시 가져옵니다.
      final memberId = _getMemberIdFromToken(accessToken);
      final response = await _dio.get('/member/$memberId');

      // GET /member/{id} API는 Login API와 달리 CommonResponse로 감싸져 있지 않다고 가정,
      // 명세에 따라 사용자 객체를 바로 반환한다고 가정합니다.
      final authData = Auth.fromJson(response.data as Map<String, dynamic>);

      state = state.copyWith(auth: authData, isLoading: false);
      print("[AuthNotifier] 자동 로그인 성공: ${authData.username}");
    } catch (e) {
      await logout();
      print("[AuthNotifier] 자동 로그인 실패 (만료된 토큰), 로그아웃 처리합니다.");
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

  /// [토큰 재발급] - 새 명세에 해당 API가 없으므로 에러 발생시킴
  Future<Map<String, String>> refreshToken() async {
    // TODO: 서버에 Refresh Token 로직이 구현되면 이 부분을 수정해야 합니다.
    throw UnimplementedError("토큰 재발급 API가 현재 명세에 없습니다.");
  }

  /// storeNewTokens는 이제 Interceptor에서만 사용되므로, 단순화 또는 제거 고려 가능
  Future<void> storeNewTokens(String accessToken, String? refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    // RefreshToken 관련 로직은 새 명세에 따라 제거
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

final usernameProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).auth?.username;
});
