import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_check_dto.freezed.dart';
part 'password_check_dto.g.dart';

/// 비밀번호 확인 시 서버로 보내는 데이터 DTO
@freezed
class PasswordCheckDto with _$PasswordCheckDto {
  const factory PasswordCheckDto({
    required String password,
  }) = _PasswordCheckDto;

  factory PasswordCheckDto.fromJson(Map<String, dynamic> json) =>
      _$PasswordCheckDtoFromJson(json);
}
