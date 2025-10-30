// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PasswordUpdateDtoImpl _$$PasswordUpdateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordUpdateDtoImpl(
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$PasswordUpdateDtoImplToJson(
        _$PasswordUpdateDtoImpl instance) =>
    <String, dynamic>{
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
    };
