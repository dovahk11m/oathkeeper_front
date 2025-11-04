import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
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
    return const PasswordState(); // Initial state
  }

  // 상태를 초기화하는 메소드
  void resetState() {
    state = const PasswordState();
  }

  /// [비밀번호 확인]
  /// 성공 시 isPasswordChecked=true 및 verifiedPassword를 상태에 저장합니다.
  Future<void> checkPassword(PasswordCheckDto dto) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(errorMessage: '로그인 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _dio.post(
        '/member/$memberId/check-password',
        data: dto.toJson(),
      );
      // 성공 시, 확인된 비밀번호를 상태에 저장
      state = state.copyWith(
        isLoading: false,
        isPasswordChecked: true,
        verifiedPassword: dto.password,
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "비밀번호가 일치하지 않습니다.";
      state = state.copyWith(
          isLoading: false,
          isPasswordChecked: false,
          errorMessage: errorMessage);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          isPasswordChecked: false,
          errorMessage: '알 수 없는 오류가 발생했습니다.');
    }
  }

  /// [비밀번호 변경]
  /// 새로운 비밀번호만 인자로 받고, 상태에 저장된 현재 비밀번호를 사용합니다.
  Future<void> updatePassword(String newPassword) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(errorMessage: '로그인 정보가 없습니다.');
      return;
    }

    // 비밀번호 확인이 선행되었는지, 그리고 확인된 비밀번호가 있는지 체크
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
      await _dio.patch(
        '/member/$memberId/password',
        data: dto.toJson(),
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "비밀번호 변경에 실패했습니다.";
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

/// 비밀번호 관련 상태(확인, 변경) 및 비즈니스 로직을 관리하는 Provider.
/// UI에서는 이 Provider를 watch하여 상태 변화에 따라 화면을 갱신합니다.
final passwordProvider = NotifierProvider<PasswordNotifier, PasswordState>(
  PasswordNotifier.new,
);
