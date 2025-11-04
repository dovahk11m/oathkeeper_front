import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oath_client/common/http_util.dart';
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

  static const _accessTokenKey = 'ACCESS_TOKEN';

  @override
  AuthState build() {
    _tryAutoLogin();
    return const AuthState();
  }

  /// 비즈니스 로직 =====================================================

  /// [로그인]
  /// LoginStrategy를 인자로 받아 해당 전략에 맞는 로그인을 수행합니다.
  Future<void> login(LoginStrategy strategy) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await strategy.execute(_dio);

      final accessToken = response.data['token'] as String?;
      final memberData = response.data['member'] as Map<String, dynamic>?;

      if (accessToken == null || memberData == null) {
        throw Exception('로그인 응답 형식이 올바르지 않습니다.');
      }

      await _storage.write(key: _accessTokenKey, value: accessToken);
      final authData = Auth.fromJson(memberData);

      state = state.copyWith(auth: authData, isLoading: false);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "로그인에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
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
      final authData =
          Auth.fromJson(response.data['data'] as Map<String, dynamic>);

      state = state.copyWith(auth: authData, isLoading: false);
    } catch (e) {
      await logout();
    }
  }

  /// [아이디 찾기]
  Future<String> findId(String email) async {
    try {
      final response = await _dio.post(
        '/member/find-id',
        data: {'email': email},
      );
      final username = response.data?['data'] as String?;
      if (username != null) {
        return username;
      } else {
        throw Exception('아이디를 찾을 수 없습니다.');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "아이디 찾기에 실패했습니다.";
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('알 수 없는 오류로 아이디 찾기에 실패했습니다.');
    }
  }

  /// [비밀번호 찾기 (임시 비밀번호 발급)]
  Future<void> findPassword(String username, String email) async {
    try {
      await _dio.post(
        '/member/find-password',
        data: {'username': username, 'email': email},
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "비밀번호 찾기에 실패했습니다.";
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('알 수 없는 오류로 비밀번호 찾기에 실패했습니다.');
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
