import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/members/member.dart';

import 'password_update_dto.dart';

// =======================================================================
// 1. 창고 관리자 (Notifier)
// =======================================================================

class PasswordNotifier extends Notifier<void> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  void build() {}

  /// [비밀번호 변경]
  /// 성공 시 true, 실패 시 false를 반환하고 에러를 throw합니다.
  Future<bool> updatePassword(PasswordUpdateDto dto) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      throw Exception('로그인 정보가 없습니다.');
    }

    try {
      await _dio.patch(
        '/member/$memberId/password',
        data: dto.toJson(),
      );
      print("[PasswordNotifier] 비밀번호 변경 성공");
      return true;
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "비밀번호 변경에 실패했습니다.";
      print("[PasswordNotifier] 비밀번호 변경 실패: $errorMessage");
      throw Exception(errorMessage);
    } catch (e) {
      print("[PasswordNotifier] 비밀번호 변경 실패: ${e.toString()}");
      throw Exception('알 수 없는 오류로 비밀번호 변경에 실패했습니다.');
    }
  }
}

// =======================================================================
// 2. 창고 (Provider)
// =======================================================================

/// UI에서 비밀번호 변경 기능을 직접 호출할 때 사용하는 Provider
final passwordProvider = NotifierProvider<PasswordNotifier, void>(
  PasswordNotifier.new,
);
