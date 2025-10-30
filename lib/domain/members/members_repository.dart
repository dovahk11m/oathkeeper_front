import 'package:dio/dio.dart';

/// 스프링(8080) 서버에서 약속 참여자 목록을 받아 id→이름 맵으로 변환
class MembersRepository {
  final Dio _dio;
  MembersRepository(this._dio);

  /// GET /api/plans/{planId}/participants
  /// 응답 예시: [{"id":7,"name":"테스터1"},{"id":8,"name":"테스터2"}...]
  Future<Map<int, String>> fetchNameMapByPlan(int planId) async {
    try {
      final res = await _dio.get('/plans/$planId/participants');
      final list = (res.data as List).cast<Map<String, dynamic>>();
      final map = <int, String>{};
      for (final p in list) {
        final id = (p['id'] as num).toInt();
        final name = (p['name'] ?? '회원#$id').toString();
        map[id] = name;
      }
      return map;
    } catch (e) {
      // 실패해도 요약은 동작해야 하니 비어있는 맵 반환
      return {};
    }
  }
}
