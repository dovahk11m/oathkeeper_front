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
    print('[Groups] 그룹 목록 요청');
    final response = await dio.get('/groups');
    print('[Groups] 응답: ${response.data}');

    final dataObject = response.data['data'] as Map<String, dynamic>?;
    if (dataObject == null) {
      throw Exception("응답에 'data' 필드가 없습니다.");
    }

    final contentList = dataObject['content'] as List?;
    if (contentList == null) {
      throw Exception("data 객체에 'content' 필드가 없습니다.");
    }

    final groups = contentList
        .map((item) => GroupSummary.fromJson(item as Map<String, dynamic>))
        .toList();

    print('[Groups] 총 ${groups.length}개 그룹 로드됨');
    for (var group in groups) {
      print('[Groups]   - ${group.groupName} (ID: ${group.groupId})');
    }

    return groups;
  } catch (e) {
    print('[Groups] 에러: $e');
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

  /// [그룹 생성]
  Future<int?> createGroup(String groupName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('[Groups] 그룹 생성 요청: $groupName');
      final response =
          await _dio.post('/groups', data: {'groupName': groupName});

      print('[Groups] 그룹 생성 응답: ${response.data}');
      final isSuccess = response.data['success'] as bool?;

      if (isSuccess == true) {
        final groupId = response.data['data'] as int?;
        print('[Groups] 그룹 생성 성공 (ID: $groupId)');
        ref.invalidate(groupsProvider);
        state = state.copyWith(isLoading: false);
        return groupId;
      } else {
        throw Exception(response.data['message'] ?? '그룹 생성에 실패했습니다.');
      }
    } on DioException catch (e) {
      print('[Groups] 그룹 생성 실패 (DioException): ${e.response?.data}');
      state = state.copyWith(
          isLoading: false,
          error: e.response?.data?['message'] ?? "그룹 생성에 실패했습니다.");
      return null;
    } catch (e) {
      print('[Groups] 그룹 생성 실패: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// [멤버 추가] - 이메일 리스트로 그룹에 멤버 추가
  Future<void> addMembers(int groupId, List<String> memberEmails) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('[Groups] 그룹 $groupId 멤버 추가 요청: $memberEmails');
      final response = await _dio.post(
        '/groups/$groupId/members',
        data: {'memberEmails': memberEmails},
      );

      print('[Groups] 멤버 추가 응답: ${response.data}');
      final isSuccess = response.data['success'] as bool?;
      if (isSuccess == true) {
        print('[Groups] 멤버 추가 성공');
        state = state.copyWith(isLoading: false);
      } else {
        throw Exception(response.data['message'] ?? '멤버 추가에 실패했습니다.');
      }
    } on DioException catch (e) {
      print('[Groups] 멤버 추가 실패 (DioException): ${e.response?.data}');
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data?['message'] ?? "멤버 추가에 실패했습니다.",
      );
    } catch (e) {
      print('[Groups] 멤버 추가 실패: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// [멤버 조회] - 그룹의 멤버 목록 조회
  Future<List<Map<String, dynamic>>> getMembers(int groupId) async {
    try {
      print('[Groups] 그룹 $groupId 멤버 조회 요청');
      final response = await _dio.get('/groups/$groupId/members');
      print('[Groups] 멤버 조회 전체 응답: ${response.data}');
      print('[Groups] 응답 타입: ${response.data.runtimeType}');

      if (response.data == null) {
        print('[Groups] 응답이 null');
        return [];
      }

      // success 체크
      final isSuccess = response.data['success'] as bool?;
      print('[Groups] success: $isSuccess');

      if (isSuccess != true) {
        final message = response.data['message'] ?? '멤버 조회 실패';
        print('[Groups] 실패 응답: $message');
        throw Exception(message);
      }

      final data = response.data['data'];
      print('[Groups] data 필드: $data');
      print('[Groups] data 타입: ${data.runtimeType}');

      if (data is List) {
        print('[Groups] 멤버 ${data.length}명 조회 완료');
        for (var i = 0; i < data.length; i++) {
          print('[Groups] 멤버 $i: ${data[i]}');
        }
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map && data.containsKey('content')) {
        // 페이징 응답 구조일 경우
        final content = data['content'] as List?;
        if (content != null) {
          print('[Groups] content에서 멤버 ${content.length}명 조회 완료');
          return List<Map<String, dynamic>>.from(content);
        }
      }

      print('[Groups] 멤버 데이터 없음');
      return [];
    } on DioException catch (e) {
      print('[Groups] 멤버 조회 실패 (DioException)');
      print('[Groups] 상태 코드: ${e.response?.statusCode}');
      print('[Groups] 응답 데이터: ${e.response?.data}');
      throw Exception(e.response?.data?['message'] ?? "멤버 조회에 실패했습니다.");
    } catch (e) {
      print('[Groups] 멤버 조회 실패: $e');
      throw Exception(e.toString());
    }
  }
}
