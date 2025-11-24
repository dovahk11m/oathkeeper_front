import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils/http_util.dart';
import '../plans/simple_plan.dart';

/// 그룹 관련 API 호출을 담당하는 Repository
class GroupRepository {
  final Dio _dio;

  GroupRepository(this._dio);

  /// 그룹 내 완료된 약속 목록 조회
  Future<PlanListResponse> fetchCompletedPlans(
    int groupId, {
    int page = 0,
    int size = 20,
  }) async {
    final resp = await _dio.get(
      '/groups/$groupId/plans',
      queryParameters: {
        'status': 'COMPLETED',
        'page': page,
        'size': size,
        'sort': 'planDatetime,DESC',
      },
    );

    // CommonResponse 구조 파싱
    final data = resp.data['data'];
    return PlanListResponse.fromJson(data);
  }
}

/// GroupRepository Provider
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return GroupRepository(dio);
});
