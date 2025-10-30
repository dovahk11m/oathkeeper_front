import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = state.copyWith(isLoading: true, isSuccess: false, error: null);

    try {
      final response = await _dio.post(
        '/member/create',
        data: signupInfo.toJson(),
      );

      // 성공 응답 (201 Created) 처리
      if (response.statusCode == 201) {
        print("[SignupNotifier] 회원가입 성공. Member ID: ${response.data}");
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        throw Exception('회원가입 응답 코드가 201이 아닙니다.');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "회원가입에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      print("[SignupNotifier] 회원가입 실패: $errorMessage");
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(isLoading: false, error: errorMessage);
      print("[SignupNotifier] 회원가입 실패: $errorMessage");
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
