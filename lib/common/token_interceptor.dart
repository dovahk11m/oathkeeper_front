import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth/auth_provider.dart';
import 'http_util.dart';

/// TokenInterceptor를 제공하는 Provider
final tokenInterceptorProvider = Provider<TokenInterceptor>((ref) {
  return TokenInterceptor(ref);
});

class TokenInterceptor extends QueuedInterceptorsWrapper {
  final Ref _ref;

  TokenInterceptor(this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _ref.read(authProvider.notifier).getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401 에러(토큰 만료)이고, 토큰 재발급 요청 자체가 실패한 게 아닐 때
    final isTokenRefreshRequest = err.requestOptions.path.endsWith('/refresh');
    if (err.response?.statusCode == 401 && !isTokenRefreshRequest) {
      // 수정: .notifier를 추가하여 AuthNotifier의 인스턴스에 접근합니다.
      final authNotifier = _ref.read(authProvider.notifier);

      try {
        // 1. 토큰 재발급 시도
        final newTokens = await authNotifier.refreshToken();

        // 2. 새 토큰 저장
        await authNotifier.storeNewTokens(
            newTokens['accessToken']!, newTokens['refreshToken']!);
        print("[TokenInterceptor] 토큰 재발급 및 저장 성공");

        // 3. 실패했던 원래 요청에 새 토큰을 담아 재시도
        final newAccessToken = newTokens['accessToken'];
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // Dio 인스턴스를 다시 가져와서 요청 재시도
        final dio = _ref.read(dioProvider);
        final response = await dio.fetch(err.requestOptions);

        print("[TokenInterceptor] 원래 요청 재시도 성공");
        return handler.resolve(response); // 성공적으로 응답을 반환
      } catch (e) {
        // 4. 토큰 재발급 실패 시 (e.g., 리프레시 토큰 만료)
        print("[TokenInterceptor] 토큰 재발급 실패: $e. 세션을 무효화합니다.");

        final errorMessage = (e is DioException && e.response?.data != null)
            ? e.response!.data['message'] as String? ??
                "세션이 만료되었습니다. 다시 로그인해주세요."
            : "세션이 만료되었습니다. 다시 로그인해주세요.";

        // AuthNotifier를 통해 중앙에서 로그아웃 처리
        await authNotifier.handleSessionInvalidation(errorMessage);

        // 더 이상 진행하지 않고 에러를 반환
        return handler.reject(err);
      }
    }
    // 401 에러가 아니면 그대로 에러를 전달
    return super.onError(err, handler);
  }
}
