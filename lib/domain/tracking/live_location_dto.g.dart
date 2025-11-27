// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LiveLocationDtoImpl _$$LiveLocationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LiveLocationDtoImpl(
      memberId: (json['memberId'] as num).toInt(),
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      lastLiveTs: json['lastLiveTs'] as String,
    );

Map<String, dynamic> _$$LiveLocationDtoImplToJson(
        _$LiveLocationDtoImpl instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'username': instance.username,
      'profileImageUrl': instance.profileImageUrl,
      'lat': instance.lat,
      'lng': instance.lng,
      'lastLiveTs': instance.lastLiveTs,
    };
