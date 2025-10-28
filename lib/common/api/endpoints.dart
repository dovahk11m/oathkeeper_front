//김성훈 추가 
class Endpoints {
  static const String baseApi   = 'http://localhost:8080';
  static const String baseAI    = 'http://localhost:8001';

  // Spring
  static String rollupPlan(int planId)      => '$baseApi/api/plans/$planId/metrics/rollup';
  static String pushPlan(int planId)        => '$baseApi/api/plans/$planId/metrics/push';
  static String listPlanMetrics(int planId) => '$baseApi/api/plans/$planId/metrics';

  // FastAPI
  static String report(int planId)          => '$baseAI/metrics/report/$planId';
  static String reportText(int planId)      => '$baseAI/metrics/report/$planId/text';
}
