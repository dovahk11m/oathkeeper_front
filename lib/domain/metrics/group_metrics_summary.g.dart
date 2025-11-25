// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_metrics_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupSummaryDataImpl _$$GroupSummaryDataImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupSummaryDataImpl(
      totalPlansAnalyzed: (json['total_plans_analyzed'] as num?)?.toInt(),
      totalRecords: (json['total_records'] as num?)?.toInt(),
      totalDistanceKm: (json['total_distance_km'] as num?)?.toDouble(),
      avgDistancePerPlanKm:
          (json['avg_distance_per_plan_km'] as num?)?.toDouble(),
      totalLateMinutes: (json['total_late_minutes'] as num?)?.toInt(),
      avgLateMinutesPerPlan:
          (json['avg_late_minutes_per_plan'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$GroupSummaryDataImplToJson(
        _$GroupSummaryDataImpl instance) =>
    <String, dynamic>{
      'total_plans_analyzed': instance.totalPlansAnalyzed,
      'total_records': instance.totalRecords,
      'total_distance_km': instance.totalDistanceKm,
      'avg_distance_per_plan_km': instance.avgDistancePerPlanKm,
      'total_late_minutes': instance.totalLateMinutes,
      'avg_late_minutes_per_plan': instance.avgLateMinutesPerPlan,
    };

_$GroupMetricsSummaryImpl _$$GroupMetricsSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupMetricsSummaryImpl(
      groupSummary: json['group_summary'] == null
          ? null
          : GroupSummaryData.fromJson(
              json['group_summary'] as Map<String, dynamic>),
      textSummary: json['text_summary'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$GroupMetricsSummaryImplToJson(
        _$GroupMetricsSummaryImpl instance) =>
    <String, dynamic>{
      'group_summary': instance.groupSummary,
      'text_summary': instance.textSummary,
      'message': instance.message,
    };
