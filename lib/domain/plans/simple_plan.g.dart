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
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$SimplePlanImplToJson(_$SimplePlanImpl instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'title': instance.title,
      'planDatetime': instance.planDatetime,
      'status': instance.status,
    };

_$PlanListResponseImpl _$$PlanListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PlanListResponseImpl(
      items: (json['content'] as List<dynamic>)
          .map((e) => SimplePlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['page'] as num).toInt(),
      totalPages: (json['totalPage'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      isLast: json['last'] as bool,
    );

Map<String, dynamic> _$$PlanListResponseImplToJson(
        _$PlanListResponseImpl instance) =>
    <String, dynamic>{
      'content': instance.items,
      'page': instance.currentPage,
      'totalPage': instance.totalPages,
      'totalElements': instance.totalElements,
      'last': instance.isLast,
    };
