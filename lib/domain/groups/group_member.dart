import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_member.freezed.dart';
part 'group_member.g.dart';

@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required int memberId,
    String? email,
    required String username,
    String? profileImageUrl,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);
}

