import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/utils/http_util.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/domain/members/password/password_check_dto.dart';
import 'package:oath_client/domain/members/password/password_state.dart';
import 'package:oath_client/domain/members/password/password_update_dto.dart';

// =======================================================================
// 1. 창고 관리자 (Notifier)
// =======================================================================

class PasswordNotifier extends Notifier<PasswordState> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  PasswordState build() {
    return const PasswordState();
  }

  /// 상태를 초기화하는 메소드
  void resetState() {
    state = const PasswordState();
  }

  /// [비밀번호 확인]
  Future<void> checkPassword(PasswordCheckDto dto) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(errorMessage: '로그인 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _dio.post(
        '/member/$memberId/check-password',
        data: dto.toJson(),
      );
      final apiResponse = ApiResponse.fromJson(response.data, null);

      if (apiResponse.success) {
        state = state.copyWith(
          isLoading: false,
          isPasswordChecked: true,
          verifiedPassword: dto.password,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isPasswordChecked: false,
          errorMessage: apiResponse.message,
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? "비밀번호 확인 중 오류가 발생했습니다.";
      state = state.copyWith(
        isLoading: false,
        isPasswordChecked: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPasswordChecked: false,
        errorMessage: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  /// [비밀번호 변경]
  Future<void> updatePassword(String newPassword) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(errorMessage: '로그인 정보가 없습니다.');
      return;
    }

    if (!state.isPasswordChecked || state.verifiedPassword == null) {
      state = state.copyWith(errorMessage: '비밀번호 확인이 필요합니다.');
      return;
    }

    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    final dto = PasswordUpdateDto(
      currentPassword: state.verifiedPassword!,
      newPassword: newPassword,
    );

    try {
      final response = await _dio.patch(
        '/member/$memberId/password',
        data: dto.toJson(),
      );
      final apiResponse = ApiResponse.fromJson(response.data, null);

      if (apiResponse.success) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? "비밀번호 변경 중 오류가 발생했습니다.";
      state = state.copyWith(
          isLoading: false, isSuccess: false, errorMessage: errorMessage);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: '알 수 없는 오류로 비밀번호 변경에 실패했습니다.');
    }
  }
}

// =======================================================================
// 2. 창고 (Provider)
// =======================================================================

final passwordProvider = NotifierProvider<PasswordNotifier, PasswordState>(
  PasswordNotifier.new,
);
