import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 기본값: 로컬 에뮬레이터 → PC 로컬 AI 서버(192.168.0.3)
const String _fallbackAiBase = "http://192.168.0.3:8001/metrics";

String get _aiBaseUrl => dotenv.env['AI_BASE_URL'] ?? _fallbackAiBase;

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
