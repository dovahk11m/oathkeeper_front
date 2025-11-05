import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/groups/group_state.dart';

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
      throw Exception(apiResponse.message);
    }
  } on DioException catch (e) {
    final message = e.response?.data?['message'] ?? "그룹 목록을 불러오는 중 오류가 발생했습니다.";
    throw Exception(message);
  } catch (e) {
    throw Exception(e.toString());
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
        state = state.copyWith(isLoading: false, error: apiResponse.message);
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
        state = state.copyWith(isLoading: false, error: apiResponse.message);
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
  Future<List<Map<String, dynamic>>> getMembers(int groupId) async {
    try {
      final response = await _dio.get('/groups/$groupId/members');
      final apiResponse =
          ApiResponse<List<dynamic>>.fromJson(response.data, (json) {
        // 응답 데이터가 List일 수도 있고, 페이지네이션된 Map{'content': [...]} 일 수도 있음
        if (json is List) {
          return json;
        } else if (json is Map<String, dynamic> &&
            json.containsKey('content')) {
          return json['content'] as List;
        }
        throw const FormatException('Unexpected JSON format for members list.');
      });

      if (apiResponse.success && apiResponse.data != null) {
        return List<Map<String, dynamic>>.from(apiResponse.data!);
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "멤버 조회에 실패했습니다.";
      throw Exception(message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
