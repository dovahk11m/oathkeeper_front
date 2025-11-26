import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/utils/http_util.dart';

import 'group_metrics_summary.dart';
import 'plan_summary.dart';

/// 메트릭 Repository
class MetricsRepository {
  final Dio _dio;

  MetricsRepository(this._dio);

  /// Spring API를 통한 AI 요약 조회 (폴링용)
  Future<PlanSummaryResponse> fetchPlanSummary(int planId) async {
    final resp = await _dio.get('/plans/$planId/summary');
    return PlanSummaryResponse.fromJson(resp.data);
  }

  /// 그룹 누적 통계 조회
  Future<GroupMetricsSummary> fetchGroupSummary(int groupId) async {
    final resp = await _dio.get('/groups/$groupId/metrics/summary');
    // CommonResponse 구조 파싱
    final data = resp.data['data'];
    return GroupMetricsSummary.fromJson(data);
  }
}

/// MetricsRepository Provider
final metricsRepositoryProvider = Provider<MetricsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MetricsRepository(dio);
});
