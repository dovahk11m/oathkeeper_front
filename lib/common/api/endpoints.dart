import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/platform_defaults.dart';

String get _apiHost => dotenv.env['API_HOST'] ?? PlatformDefaults.httpImage;
String get _aiHost => dotenv.env['AI_HOST'] ?? PlatformDefaults.aiBase;

class Endpoints {
  // Spring Boot API
  static String rollupPlan(int planId) =>
      '$_apiHost/api/plans/$planId/metrics/rollup';
  static String pushPlan(int planId) =>
      '$_apiHost/api/plans/$planId/metrics/push';
  static String listPlanMetrics(int planId) =>
      '$_apiHost/api/plans/$planId/metrics';

  // FastAPI
  static String report(int planId) => '$_aiHost/metrics/report/$planId';
  static String reportText(int planId) =>
      '$_aiHost/metrics/report/$planId/text';
}
