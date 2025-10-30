// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthImpl _$$AuthImplFromJson(Map<String, dynamic> json) => _$AuthImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      email: json['email'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      socialType: $enumDecodeNullable(_$SocialTypeEnumMap, json['socialType']),
      status: $enumDecode(_$StatusEnumMap, json['status']),
      isPremium: json['is_premium'] as bool? ?? false,
    );

Map<String, dynamic> _$$AuthImplToJson(_$AuthImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profileImageUrl': instance.profileImageUrl,
      'email': instance.email,
      'role': _$RoleEnumMap[instance.role]!,
      'socialType': _$SocialTypeEnumMap[instance.socialType],
      'status': _$StatusEnumMap[instance.status]!,
      'is_premium': instance.isPremium,
    };

const _$RoleEnumMap = {
  Role.USER: 'USER',
  Role.ADMIN: 'ADMIN',
};

const _$SocialTypeEnumMap = {
  SocialType.KAKAO: 'KAKAO',
  SocialType.NAVER: 'NAVER',
  SocialType.GOOGLE: 'GOOGLE',
  SocialType.EMAIL: 'EMAIL',
};

const _$StatusEnumMap = {
  Status.ACTIVE: 'ACTIVE',
  Status.DEACTIVATED: 'DEACTIVATED',
  Status.SUSPENDED: 'SUSPENDED',
};
