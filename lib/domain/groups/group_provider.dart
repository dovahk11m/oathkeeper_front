import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      throw Exception("그룹 목록 응답 형식이 올바르지 않습니다.");
    }

    final contentList = dataObject['content'] as List?;
    if (contentList == null) {
      throw Exception("그룹 목록 응답에 'content' 필드가 없습니다.");
    }

    return contentList
        .map((item) => GroupSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  } on DioException catch (e) {
    final errorMessage =
        e.response?.data?['error']?['message'] ?? "그룹 목록을 불러오는 중 오류가 발생했습니다.";
    throw Exception(errorMessage);
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

      if (response.statusCode == 201 && response.data['success']) {
        final groupId = response.data['data'] as int?;
        ref.invalidate(groupsProvider); // 그룹 목록 갱신
        state = state.copyWith(isLoading: false);
        return groupId;
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '그룹 생성에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
        return null;
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
      return null;
    }
  }

  /// [멤버 추가] - 이메일 리스트로 그룹에 멤버 추가
  Future<void> addMembers(int groupId, List<String> memberEmails) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.post(
        '/groups/$groupId/members',
        data: {'memberEmails': memberEmails},
      );

      if (response.statusCode == 200 && response.data['success']) {
        state = state.copyWith(isLoading: false);
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '멤버 추가에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
    }
  }

  /// [멤버 조회] - 그룹의 멤버 목록 조회
  Future<List<Map<String, dynamic>>> getMembers(int groupId) async {
    try {
      final response = await _dio.get('/groups/$groupId/members');

      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data['data'];
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('content')) {
          final content = data['content'] as List;
          return List<Map<String, dynamic>>.from(content);
        }
        return []; // data가 있지만 예상치 못한 형식일 경우
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '멤버 조회에 실패했습니다.';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버 오류로 멤버 조회에 실패했습니다.";
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("알 수 없는 오류로 멤버를 조회하지 못했습니다.");
    }
  }
}
