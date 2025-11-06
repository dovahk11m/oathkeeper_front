import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/token_interceptor.dart';

/// --dart-define 로 환경별 분기 (에뮬: 10.0.2.2)
const String _baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'http://10.0.2.2:8080/api',
);

/// Dio 인스턴스를 제공
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
