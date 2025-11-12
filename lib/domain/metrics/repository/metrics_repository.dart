// lib/domain/metrics/repository/metrics_repository.dart
import 'package:dio/dio.dart';
import '../models/text_options.dart';

class MetricsRepository {
  final Dio _dio;
  MetricsRepository(this._dio);

  Future<String> fetchRulesText(int planId) async {
    final resp = await _dio.get('/report/$planId/text'); // GET → rules
    return _extractText(resp.data);
  }

  Future<String> fetchText(int planId, TextOptions opts) async {
    final resp = await _dio.post('/report/$planId/text', data: opts.toJson());
    return _extractText(resp.data);
  }

  String _extractText(dynamic body) {
    // 1) 서버가 문자열 그대로 줄 때
    if (body is String) return body.trim();

    // 2) { success:..., data: "..." }
    if (body is Map && body['data'] is String) {
      return (body['data'] as String).trim();
    }

    // 3) { text: "..." } (이전/다른 엔드포인트 호환)
    if (body is Map && body['text'] is String) {
      return (body['text'] as String).trim();
    }

    // 4) { success:..., data: { text: "..." } } 같은 변형도 방어
    if (body is Map && body['data'] is Map && (body['data'] as Map)['text'] is String) {
      return ((body['data'] as Map)['text'] as String).trim();
    }

    return '';
  }
}
