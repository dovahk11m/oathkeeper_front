import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_member.freezed.dart';
part 'group_member.g.dart';

/// 그룹 정보에 포함된 멤버의 미리보기 정보를 위한 DTO
@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required int memberId,
    required String username,
    String? profileImageUrl,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);
}
