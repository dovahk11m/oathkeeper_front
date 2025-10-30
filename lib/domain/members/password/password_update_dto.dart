import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_update_dto.freezed.dart';
part 'password_update_dto.g.dart';

/// 비밀번호 변경 시 서버로 보내는 데이터 DTO
@freezed
class PasswordUpdateDto with _$PasswordUpdateDto {
  const factory PasswordUpdateDto({
    required String currentPassword,
    required String newPassword,
  }) = _PasswordUpdateDto;

  factory PasswordUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$PasswordUpdateDtoFromJson(json);
}
