import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/http_util.dart';

import 'signup.dart';
import 'signup_state.dart';

// =======================================================================
// 1. 창고 관리자 (Notifier)
// =======================================================================

class SignupNotifier extends Notifier<SignupState> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  SignupState build() {
    return const SignupState();
  }

  /// [회원가입]
  Future<void> signup(Signup signupInfo) async {
    state = state.copyWith(
        isLoading: true, isSuccess: false, error: null, message: null);

    try {
      final response = await _dio.post(
        '/member/create',
        data: signupInfo.toJson(),
      );
      // API 명세에 따라 data가 int 타입일 것이라고 명시합니다.
      final apiResponse =
          ApiResponse<int>.fromJson(response.data, (json) => json as int);

      if (apiResponse.success) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: apiResponse.message,
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
    state = const SignupState();
  }
}

// =======================================================================
// 2. 창고 (Provider)
// =======================================================================

final signupProvider =
    NotifierProvider<SignupNotifier, SignupState>(SignupNotifier.new);
