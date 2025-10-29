// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantImpl _$$ParticipantImplFromJson(Map<String, dynamic> json) =>
    _$ParticipantImpl(
      id: (json['id'] as num).toInt(),
      memberId: (json['memberId'] as num).toInt(),
      memberNickname: json['memberNickname'] as String,
      memberProfileImageUrl: json['memberProfileImageUrl'] as String?,
      participantStatus: json['participantStatus'] as String,
      transportMethod: json['transportMethod'] as String?,
      expectedTravelTimeMinutes:
          (json['expectedTravelTimeMinutes'] as num?)?.toInt(),
      expectedDepartureTime: json['expectedDepartureTime'] == null
          ? null
          : DateTime.parse(json['expectedDepartureTime'] as String),
      actualDepartureTime: json['actualDepartureTime'] == null
          ? null
          : DateTime.parse(json['actualDepartureTime'] as String),
      actualArrivalTime: json['actualArrivalTime'] == null
          ? null
          : DateTime.parse(json['actualArrivalTime'] as String),
      arrivalStatus: json['arrivalStatus'] as String?,
      timeBurdenMinutes: (json['timeBurdenMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ParticipantImplToJson(_$ParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'memberNickname': instance.memberNickname,
      'memberProfileImageUrl': instance.memberProfileImageUrl,
      'participantStatus': instance.participantStatus,
      'transportMethod': instance.transportMethod,
      'expectedTravelTimeMinutes': instance.expectedTravelTimeMinutes,
      'expectedDepartureTime':
          instance.expectedDepartureTime?.toIso8601String(),
      'actualDepartureTime': instance.actualDepartureTime?.toIso8601String(),
      'actualArrivalTime': instance.actualArrivalTime?.toIso8601String(),
      'arrivalStatus': instance.arrivalStatus,
      'timeBurdenMinutes': instance.timeBurdenMinutes,
    };
