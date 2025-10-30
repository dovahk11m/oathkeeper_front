// lib/domain/metrics/repository/metrics_repository.dart
import 'package:dio/dio.dart';
import '../models/text_options.dart';

class MetricsRepository {
  final Dio _dio;
  MetricsRepository(this._dio);

  Future<String> fetchRulesText(int planId) async {
    final resp = await _dio.get('/report/$planId/text'); // GET → rules
    return (resp.data['text'] as String?) ?? '';
  }

  Future<String> fetchText(int planId, TextOptions opts) async {
    final resp = await _dio.post('/report/$planId/text', data: opts.toJson());
    return (resp.data['text'] as String?) ?? '';
  }
}
