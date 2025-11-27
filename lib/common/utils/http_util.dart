import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/token_interceptor.dart';

import 'platform_defaults.dart';

// 기본값: 로컬 개발 (필요 시 .env로 override)
// 안드로이드 에뮬레이터는 10.0.2.2, 나머지는 localhost 사용
String get _fallbackApi => PlatformDefaults.httpApi;
String get _fallbackImage => PlatformDefaults.httpImage;

String get _baseUrl => dotenv.env['API_BASE_URL'] ?? _fallbackApi;
String get imageBaseUrl => dotenv.env['IMAGE_BASE_URL'] ?? _fallbackImage;

/// Dio 서비스를 제공하는 Provider. (env 없으면 기본값 사용)
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
