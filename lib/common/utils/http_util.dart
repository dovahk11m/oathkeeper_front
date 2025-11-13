import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/token_interceptor.dart';

const String mypc = "http://10.0.2.2:8080/api";
const String choong = "http://192.168.0.187:8080/api";
const String server = "https://your.production.server/api";

// 사용할 서버 선택 ---
const String _baseUrl = mypc;

// 이미지 서버
const String imageBaseUrl = "http://10.0.2.2:8080";

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
