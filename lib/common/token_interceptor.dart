import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';

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
    // 401 에러 (토큰 만료 등) 발생 시
    if (err.response?.statusCode == 401) {
      final requestPath = err.requestOptions.path;

      // 비밀번호 확인 실패로 인한 401은 로그아웃 처리에서 제외
      if (requestPath.contains('check-password')) {
        print("[TokenInterceptor] 비밀번호 확인 실패(401)는 로그아웃을 트리거하지 않습니다.");
        return handler.next(err);
      }

      final authNotifier = _ref.read(authProvider.notifier);

      // 현재 요청이 로그인 요청이었는지 확인 (로그인 실패로 인한 401은 무시)
      final isLoginRequest = requestPath.contains('/login');

      // 이미 로그아웃 상태가 아닌 경우에만 세션 무효화 처리
      if (!isLoginRequest && _ref.read(isLoggedInProvider)) {
        print("[TokenInterceptor] 401 에러 발생. 세션을 무효화하고 로그아웃합니다.");

        const errorMessage = "세션이 만료되었습니다. 다시 로그인해주세요.";
        await authNotifier.handleSessionInvalidation(errorMessage);
      }

      // 에러를 그대로 다음 핸들러로 전달
      return handler.next(err);
    }

    // 401 에러가 아니면 그대로 에러를 전달
    return super.onError(err, handler);
  }
}
