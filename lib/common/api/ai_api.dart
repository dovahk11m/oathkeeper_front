// lib/common/api/ai_api.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _aiBaseUrl = "http://10.0.2.2:8001/metrics";

// lib/common/api/ai_api.dart
final aiDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8001/metrics",
      connectTimeout: const Duration(seconds: 5),   // 연결은 짧게
      receiveTimeout: const Duration(seconds: 90),  // 응답 대기는 넉넉히
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
});
