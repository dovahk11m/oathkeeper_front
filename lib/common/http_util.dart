import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/token_interceptor.dart';

/// TODO: 환경에 따라 URL을 분리하는 것이 좋습니다. (e.g., .env 파일 사용)
const String _baseUrl = "http://10.0.2.2:8080/api";

/// Dio 인스턴스를 제공하는 Provider.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  dio.interceptors.addAll([
    ref.watch(tokenInterceptorProvider),
    // ApiResponseInterceptor가 제거되었습니다.
    LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      logPrint: print,
    ),
  ]);

  return dio;
});
