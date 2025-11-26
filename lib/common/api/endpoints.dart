import 'package:flutter_dotenv/flutter_dotenv.dart';

const String _fallbackApi = 'http://localhost:8080';
const String _fallbackAi = 'http://192.168.0.3:8001';

String get _baseApi =>
    dotenv.env['API_BASE_URL']?.replaceAll('/api', '') ?? _fallbackApi;
String get _baseAi =>
    dotenv.env['AI_BASE_URL']?.replaceAll('/metrics', '') ?? _fallbackAi;

class Endpoints {
  // Spring
  static String rollupPlan(int planId) =>
      '${_baseApi}/api/plans/$planId/metrics/rollup';
  static String pushPlan(int planId) =>
      '${_baseApi}/api/plans/$planId/metrics/push';
  static String listPlanMetrics(int planId) =>
      '${_baseApi}/api/plans/$planId/metrics';

  // FastAPI
  static String report(int planId) => '${_baseAi}/metrics/report/$planId';
  static String reportText(int planId) =>
      '${_baseAi}/metrics/report/$planId/text';
}
