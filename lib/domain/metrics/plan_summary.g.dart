// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanSummaryDataImpl _$$PlanSummaryDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PlanSummaryDataImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      summary: json['summary'] as String,
    );

Map<String, dynamic> _$$PlanSummaryDataImplToJson(
        _$PlanSummaryDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
    };

_$PlanSummaryResponseImpl _$$PlanSummaryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PlanSummaryResponseImpl(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : PlanSummaryData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$PlanSummaryResponseImplToJson(
        _$PlanSummaryResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };
