import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/utils/http_util.dart';
import 'package:oath_client/domain/groups/group_state.dart';

import 'group_member.dart';
import 'group_summary.dart';

// =======================================================================
// 1. 데이터 조회 전용 Provider (FutureProvider)
// =======================================================================

/// 사용자가 속한 그룹 목록을 비동기적으로 조회하는 Provider.
final groupsProvider = FutureProvider<List<GroupSummary>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get('/groups');
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    if (apiResponse.success && apiResponse.data != null) {
      final contentList = apiResponse.data!['content'] as List;
      return contentList
          .map((item) => GroupSummary.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(apiResponse.message ?? '그룹 목록을 불러오는 중 오류가 발생했습니다.');
    }
  } on DioException catch (e) {
    final message = e.response?.data?['message'] ?? "그룹 목록을 불러오는 중 오류가 발생했습니다.";
    throw Exception(message);
  } catch (e) {
    throw Exception("알 수 없는 오류로 그룹 목록을 불러오지 못했습니다.");
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

  /// [그룹 생성]
  Future<int?> createGroup(String groupName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response =
          await _dio.post('/groups', data: {'groupName': groupName});
      final apiResponse =
          ApiResponse<int>.fromJson(response.data, (json) => json as int);

      if (apiResponse.success) {
        ref.invalidate(groupsProvider); // 그룹 목록 갱신
        state = state.copyWith(isLoading: false);
        return apiResponse.data;
      } else {
        state = state.copyWith(
            isLoading: false,
            error: apiResponse.message ?? '그룹 생성 중 오류가 발생했습니다.');
        return null;
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? "그룹 생성 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// [멤버 추가]
  Future<void> addMembers(int groupId, List<String> memberEmails) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post(
        '/groups/$groupId/members',
        data: {'memberEmails': memberEmails},
      );
      final apiResponse = ApiResponse.fromJson(response.data, null);

      if (apiResponse.success) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
            isLoading: false,
            error: apiResponse.message ?? '멤버 추가 중 오류가 발생했습니다.');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? "멤버 추가 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// [멤버 조회] - 그룹의 멤버 목록 조회
  Future<List<GroupMember>> getMembers(int groupId) async {
    try {
      // debugPrint('[Groups] 그룹 $groupId 멤버 조회 요청');
      final response = await _dio.get('/groups/$groupId/members');

      // debugPrint('[Groups] 멤버 조회 응답: ${response.data}');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data!;
        List<dynamic> contentList;

        if (data.containsKey('content')) {
          contentList = data['content'] as List;
        } else {
          contentList = [data];
        }

        // debugPrint('[Groups] content에서 멤버 ${contentList.length}명 조회 완료');

        return contentList.map((item) {
          return GroupMember.fromJson(item as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception(apiResponse.message ?? '멤버 조회 실패');
      }
    } on DioException catch (e) {
      // debugPrint('[Groups] DioException: ${e.message}');
      final message = e.response?.data?['message'] ?? "멤버 조회에 실패했습니다.";
      throw Exception(message);
    } catch (e, stackTrace) {
      // debugPrint('[Groups] 멤버 조회 실패: $e');
      // debugPrint('[Groups] StackTrace: $stackTrace');
      throw Exception(e.toString());
    }
  }
}
