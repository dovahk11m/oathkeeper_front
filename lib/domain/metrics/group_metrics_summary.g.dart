// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_metrics_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupMetricsSummaryImpl _$$GroupMetricsSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupMetricsSummaryImpl(
      groupId: (json['groupId'] as num).toInt(),
      summary: json['summary'] as String?,
      status: json['status'] as String,
      lastUpdatedAt: json['lastUpdatedAt'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$GroupMetricsSummaryImplToJson(
        _$GroupMetricsSummaryImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'summary': instance.summary,
      'status': instance.status,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'reason': instance.reason,
    };
