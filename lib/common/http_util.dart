import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/token_interceptor.dart';

/// TODO: 환경에 따라 URL을 분리하는 것이 좋습니다. (e.g., .env 파일 사용)
const String _baseUrl = "http://10.0.2.2:8080/api";

/// Dio 인스턴스를 제공하는 Provider.
/// 이 Provider를 통해 앱의 모든 곳에서 동일한 Dio 인스턴스를 사용합니다.
/// 인터셉터 설정과 같은 모든 Dio 관련 구성이 이 곳에서 중앙 관리됩니다.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  // TokenInterceptor를 주입받아 Dio에 추가합니다.
  // 이로써 모든 API 요청은 자동으로 토큰 관리 로직을 거치게 됩니다.
  dio.interceptors.add(
    ref.watch(tokenInterceptorProvider),
  );

  // 개발 중 API 요청/응답을 로깅하는 인터셉터 추가
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    logPrint: print,
  ));

  return dio;
});
