import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/members/find_account/find_password_request.dart';
import 'package:oath_client/domain/members/find_account/find_password_state.dart';

// =======================================================================
// 1. 창고 관리자 (Notifier)
// =======================================================================

class FindPasswordNotifier extends Notifier<FindPasswordState> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  FindPasswordState build() {
    return const FindPasswordState();
  }

  /// [비밀번호 찾기(임시 비밀번호 발급)]
  Future<void> findPassword(FindPasswordRequest request) async {
    state = const FindPasswordState(isLoading: true);

    try {
      final response =
          await _dio.post('/member/find-password', data: request.toJson());
      // API 명세에 따라 data가 null일 것이므로, 타입을 명시하지 않습니다.
      final apiResponse = ApiResponse.fromJson(response.data, null);

      if (apiResponse.success) {
        state = state.copyWith(
          isLoading: false,
          successMessage: apiResponse.message, // 성공 메시지 사용
        );
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 상태를 초기화하는 메소드
  void resetState() {
    state = const FindPasswordState();
  }
}

// =======================================================================
// 2. 창고 (Provider)
// =======================================================================

final findPasswordProvider =
    NotifierProvider<FindPasswordNotifier, FindPasswordState>(
        FindPasswordNotifier.new);
