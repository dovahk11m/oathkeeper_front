// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileUpdateDtoImpl _$$ProfileUpdateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileUpdateDtoImpl(
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      defaultAddress: json['defaultAddress'] as String?,
    );

Map<String, dynamic> _$$ProfileUpdateDtoImplToJson(
        _$ProfileUpdateDtoImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'profileImageUrl': instance.profileImageUrl,
      'defaultAddress': instance.defaultAddress,
    };
