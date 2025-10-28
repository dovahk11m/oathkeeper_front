// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupMemberImpl _$$GroupMemberImplFromJson(Map<String, dynamic> json) =>
    _$GroupMemberImpl(
      memberId: (json['memberId'] as num).toInt(),
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$$GroupMemberImplToJson(_$GroupMemberImpl instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'username': instance.username,
      'profileImageUrl': instance.profileImageUrl,
    };
