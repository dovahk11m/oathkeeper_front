// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupImpl _$$SignupImplFromJson(Map<String, dynamic> json) => _$SignupImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      agreedTermIds: (json['agreedTermIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$SignupImplToJson(_$SignupImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'agreedTermIds': instance.agreedTermIds,
    };
