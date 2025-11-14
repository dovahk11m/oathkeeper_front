import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Android 에뮬레이터 -> 호스트 PC
const String _aiBaseUrl = "http://192.168.0.3:8001/metrics";

final aiDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _aiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 120), // LLM 응답 고려
      contentType: 'application/json; charset=utf-8',
    ),
  );
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
});
