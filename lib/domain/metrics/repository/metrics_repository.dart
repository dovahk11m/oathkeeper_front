import 'package:dio/dio.dart';
import '../models/text_options.dart';

class MetricsRepository {
  final Dio ai; // FastAPI용 Dio

  MetricsRepository(this.ai);

  /// 요약 JSON 생성/저장 (GET /metrics/report/{planId})
  Future<Map<String, dynamic>> buildSummary(int planId) async {
    final res = await ai.get('/report/$planId');
    return Map<String, dynamic>.from(res.data);
  }

  /// 텍스트 리포트 (POST /metrics/report/{planId}/text)
  Future<String> fetchText(int planId, TextOptions options) async {
    final res = await ai.post('/report/$planId/text', data: options.toJson());
    return (res.data is Map && res.data['text'] is String)
        ? res.data['text'] as String
        : res.data.toString();
  }

  /// 규칙 기반 텍스트 (GET /metrics/report/{planId}/text)
  Future<String> fetchRulesText(int planId) async {
    final res = await ai.get('/report/$planId/text');
    return (res.data is Map && res.data['text'] is String)
        ? res.data['text'] as String
        : res.data.toString();
  }
}
