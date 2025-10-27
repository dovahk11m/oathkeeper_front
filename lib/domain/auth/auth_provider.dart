import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/http_util.dart';

import 'auth.dart';
import 'auth_state.dart';

// =======================================================================
// 1. 의존성 주입을 위한 Provider
// =======================================================================

/// FlutterSecureStorage 인스턴스를 앱 전역에서 사용하기 위한 Provider
final secureStorageProvider = Provider((_) => const FlutterSecureStorage());

// dioProvider는 'common/http_util.dart' 파일에 이미 정의되어 있습니다.

// =======================================================================
// 2. 창고 관리자 (Notifier)
// =======================================================================

class AuthNotifier extends Notifier<AuthState> {
  // Notifier가 처음 생성될 때, 필요한 의존성들을 한번만 `read` 합니다.
  late final Dio _dio = ref.read(dioProvider);
  late final FlutterSecureStorage _storage = ref.read(secureStorageProvider);

  // Secure Storage에 토큰을 저장하기 위한 Key
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  @override
  AuthState build() {
    // Notifier가 처음 초기화될 때, 자동으로 로그인 시도
    _tryAutoLogin();
    // 초기 상태는 '로그아웃', '로딩 아님', '에러 없음'
    return const AuthState();
  }

  /// ===================== 비즈니스 로직 =====================

  /// [로그인]
  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 1. API 요청 (현재는 더미 데이터)
      // final response = await _dio.post('/auth/login', data: {'username': username, 'password': password});
      // final apiResponse = ApiResponse.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));
      // final authData = apiResponse.data!;
      // await storeNewTokens('REAL_ACCESS_TOKEN', 'REAL_REFRESH_TOKEN');

      // --- 더미 코드 시작 ---
      await Future.delayed(const Duration(seconds: 1)); // 통신 딜레이 흉내
      final authData = Auth.fromJson(const {
        "id": 1,
        "username": "tester",
        "email": "test@example.com",
        "role": "USER",
        "status": "ACTIVE",
        "is_premium": false
      });
      await storeNewTokens('DUMMY_ACCESS_TOKEN', 'DUMMY_REFRESH_TOKEN');
      // --- 더미 코드 종료 ---

      // 2. 상태 업데이트
      state = state.copyWith(auth: authData, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: "로그인에 실패했습니다. 아이디 또는 비밀번호를 확인해주세요.");
    }
  }

  /// [로그아웃]
  Future<void> logout() async {
    // 1. 저장된 모든 토큰 삭제
    await _storage.deleteAll();
    // 2. 상태를 초기값으로 리셋
    state = const AuthState();
  }

  /// [자동 로그인] 앱 시작 시 토큰 유무를 확인하여 로그인 상태를 복원합니다.
  Future<void> _tryAutoLogin() async {
    final accessToken = await getAccessToken();
    if (accessToken != null) {
      state = state.copyWith(isLoading: true);
      // 실제 앱에서는 이 토큰으로 사용자 정보를 서버에서 가져와 state에 저장해야 합니다.
      // 예: final user = await _getMe();
      // state = state.copyWith(auth: user, isLoading: false);

      // 지금은 토큰이 있다는 사실만으로 더미 유저 정보를 만들어 로그인 처리합니다.
      final dummyAuth = Auth.fromJson(const {
        "id": 1,
        "username": "tester",
        "email": "test@example.com",
        "role": "USER",
        "status": "ACTIVE"
      });
      state = state.copyWith(auth: dummyAuth, isLoading: false);
      print("[AuthNotifier] 자동 로그인 성공");
    } else {
      print("[AuthNotifier] 저장된 토큰이 없어 자동 로그인을 건너뜁니다.");
    }
  }

  /// ======== TokenInterceptor에서 호출하는 내부 관리용 메소드들 =========

  /// 저장된 Access Token을 가져옵니다.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Refresh Token으로 새로운 토큰들을 발급받습니다.
  Future<Map<String, String>> refreshToken() async {
    final currentRefreshToken = await _storage.read(key: _refreshTokenKey);

    // 실제 API 요청 예시
    // final response = await _dio.post('/auth/refresh', data: {'refreshToken': currentRefreshToken});
    // final newAccessToken = response.data['data']['accessToken'];
    // final newRefreshToken = response.data['data']['refreshToken'];

    // --- 더미 코드 시작 ---
    await Future.delayed(const Duration(milliseconds: 500));
    final newAccessToken =
        'NEW_DUMMY_ACCESS_TOKEN_${DateTime.now().millisecond}';
    final newRefreshToken = 'NEW_DUMMY_REFRESH_TOKEN';
    // --- 더미 코드 종료 ---

    return {'accessToken': newAccessToken, 'refreshToken': newRefreshToken};
  }

  /// 새로운 토큰들을 Secure Storage에 저장합니다.
  Future<void> storeNewTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// 세션 만료 시 호출되어 상태를 초기화합니다.
  Future<void> handleSessionInvalidation(String errorMessage) async {
    await logout(); // 로그아웃 처리
    state = state.copyWith(error: errorMessage); // 에러 메시지 표시
  }
}

// =======================================================================
// 3. 창고 (Provider) - Notifier 클래스 아래에 정의하여 컨벤션 일치
// =======================================================================

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// =======================================================================
// 4. 사이드 이펙트 (Side-effects) / 계산된 상태 (Computed State)
// =======================================================================

/// 현재 로그인 상태(true/false)만 간단히 제공하는 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  // authProvider의 상태(AuthState)를 감시(watch)하고,
  // auth 객체가 null이 아니면 true를 반환합니다.
  return ref.watch(authProvider).auth != null;
});

/// 현재 로그인된 사용자의 이름을 제공하는 Provider (예시)
final usernameProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).auth?.username;
});
