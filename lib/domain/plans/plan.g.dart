// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanImpl _$$PlanImplFromJson(Map<String, dynamic> json) => _$PlanImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      planDatetime: DateTime.parse(json['planDatetime'] as String),
      status: json['status'] as String,
      location: json['location'] as String?,
      placeLatitude: (json['placeLatitude'] as num?)?.toDouble(),
      placeLongitude: (json['placeLongitude'] as num?)?.toDouble(),
      lateFineAmount: (json['lateFineAmount'] as num?)?.toInt(),
      creatorMember:
          CreatorMember.fromJson(json['creatorMember'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$PlanImplToJson(_$PlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'planDatetime': instance.planDatetime.toIso8601String(),
      'status': instance.status,
      'location': instance.location,
      'placeLatitude': instance.placeLatitude,
      'placeLongitude': instance.placeLongitude,
      'lateFineAmount': instance.lateFineAmount,
      'creatorMember': instance.creatorMember,
      'participants': instance.participants,
      'tags': instance.tags,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_$CreatorMemberImpl _$$CreatorMemberImplFromJson(Map<String, dynamic> json) =>
    _$CreatorMemberImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$$CreatorMemberImplToJson(_$CreatorMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
    };
