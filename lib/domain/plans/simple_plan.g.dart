// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SimplePlanImpl _$$SimplePlanImplFromJson(Map<String, dynamic> json) =>
    _$SimplePlanImpl(
      planId: (json['planId'] as num).toInt(),
      title: json['title'] as String,
      planDatetime: json['planDatetime'] as String,
    );

Map<String, dynamic> _$$SimplePlanImplToJson(_$SimplePlanImpl instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'title': instance.title,
      'planDatetime': instance.planDatetime,
    };

_$PlanListResponseImpl _$$PlanListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PlanListResponseImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => SimplePlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      isFirst: json['isFirst'] as bool,
      isLast: json['isLast'] as bool,
    );

Map<String, dynamic> _$$PlanListResponseImplToJson(
        _$PlanListResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'isFirst': instance.isFirst,
      'isLast': instance.isLast,
    };
