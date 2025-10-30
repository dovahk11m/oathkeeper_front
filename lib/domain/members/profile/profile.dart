import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// 회원 정보 조회 시 서버로부터 받아오는 프로필 정보 DTO
@freezed
class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String username,
    required String email,
    String? profileImageUrl,
    String? defaultAddress,
  }) = _Profile;

  /// JSON으로부터 Profile 객체를 생성하는 팩토리 생성자
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
