// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendPlaceImpl _$$RecommendPlaceImplFromJson(Map<String, dynamic> json) =>
    _$RecommendPlaceImpl(
      centerAvgPlace: (json['centerAvgPlace'] as List<dynamic>)
          .map((e) => RecommendPlaceState.fromJson(e as Map<String, dynamic>))
          .toList(),
      equalAvgPlace: (json['equalAvgPlace'] as List<dynamic>)
          .map((e) => RecommendPlaceState.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RecommendPlaceImplToJson(
        _$RecommendPlaceImpl instance) =>
    <String, dynamic>{
      'centerAvgPlace': instance.centerAvgPlace,
      'equalAvgPlace': instance.equalAvgPlace,
    };

_$RecommendPlaceStateImpl _$$RecommendPlaceStateImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendPlaceStateImpl(
      participant:
          Participant.fromJson(json['participant'] as Map<String, dynamic>),
      destination: Place.fromJson(json['destination'] as Map<String, dynamic>),
      distance: (json['distance'] as num).toInt(),
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$$RecommendPlaceStateImplToJson(
        _$RecommendPlaceStateImpl instance) =>
    <String, dynamic>{
      'participant': instance.participant,
      'destination': instance.destination,
      'distance': instance.distance,
      'duration': instance.duration,
    };
