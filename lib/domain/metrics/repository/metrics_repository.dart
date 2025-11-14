import 'package:dio/dio.dart';
import 'package:oath_client/domain/metrics/models/metrics_summary.dart';
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
    if (body == null) return '';

    // 서버 응답이 {"success":true, "data":"요약 텍스트"} 형태일 때
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      final data = body['data'];
      if (data is String) {
        return data.trim();
      }
    }

    // 만약의 경우, 서버가 텍스트만 보낼 때
    if (body is String) return body.trim();

    // 그 외의 경우는 모두 파싱 실패로 간주
    return '';
  }
}
