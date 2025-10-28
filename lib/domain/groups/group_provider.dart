import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/groups/group_state.dart';

import 'group_summary.dart';

// =======================================================================
// 1. 데이터 조회 전용 Provider (FutureProvider)
// =======================================================================

final groupsProvider = FutureProvider<List<GroupSummary>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get('/groups');
    final dataObject = response.data['data'] as Map<String, dynamic>?;
    if (dataObject == null) {
      throw Exception("응답에 'data' 필드가 없습니다.");
    }

    final contentList = dataObject['content'] as List?;
    if (contentList == null) {
      throw Exception("data 객체에 'content' 필드가 없습니다.");
    }

    return contentList
        .map((item) => GroupSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    throw Exception("그룹 목록을 불러오는 데 실패했습니다: $e");
  }
});

// =======================================================================
// 2. 상태 변경을 위한 NotifierProvider (그룹 생성/수정/삭제 등)
// =======================================================================

final groupStateProvider =
    NotifierProvider<GroupNotifier, GroupState>(GroupNotifier.new);

class GroupNotifier extends Notifier<GroupState> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  GroupState build() {
    return const GroupState(); // 초기 상태만 반환
  }

  /// [그룹 생성] - [수정] 명세서에 맞게 응답 처리 로직 변경
  Future<void> createGroup(String groupName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response =
          await _dio.post('/groups', data: {'groupName': groupName});

      // 명세에 따라, data 필드는 int 타입의 ID 이므로 ApiResponse로 파싱하지 않고,
      // success 여부만 직접 확인합니다.
      final isSuccess = response.data['success'] as bool?;

      if (isSuccess == true) {
        // 그룹 생성에 성공하면, 전체 그룹 목록을 다시 불러오도록
        // groupsProvider를 무효화(invalidate)합니다.
        ref.invalidate(groupsProvider);
        state = state.copyWith(isLoading: false);
      } else {
        throw Exception(response.data['message'] ?? '그룹 생성에 실패했습니다.');
      }
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: e.response?.data?['message'] ?? "그룹 생성에 실패했습니다.");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
