import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_update_dto.freezed.dart';
part 'profile_update_dto.g.dart';

/// 회원 정보 수정 시 서버로 보내는 데이터 DTO
@freezed
class ProfileUpdateDto with _$ProfileUpdateDto {
  const factory ProfileUpdateDto({
    required String username,
    String? profileImageUrl,
    String? defaultAddress,
  }) = _ProfileUpdateDto;

  factory ProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateDtoFromJson(json);
}
