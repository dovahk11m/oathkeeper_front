import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// [비밀번호 찾기(재설정)]
  Future<void> findPassword(FindPasswordRequest request) async {
    state = const FindPasswordState(isLoading: true);

    try {
      final response =
          await _dio.post('/member/find-password', data: request.toJson());

      if (response.statusCode == 200 && response.data['success']) {
        state = state.copyWith(
          isLoading: false,
          successMessage: response.data['message'],
        );
      } else {
        final errorMessage =
            response.data['error']?['message'] ?? '비밀번호 재설정 요청에 실패했습니다.';
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
