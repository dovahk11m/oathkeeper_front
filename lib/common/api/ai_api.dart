import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Android 에뮬레이터에서 호스트 PC = 10.0.2.2
// FastAPI는 8001, prefix는 /metrics (app.main에서 include_router(prefix="/metrics"))
const String _aiBaseUrl = "http://10.0.2.2:8001/metrics";

final aiDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _aiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  // 필요하면 로깅
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
  return dio;
});
