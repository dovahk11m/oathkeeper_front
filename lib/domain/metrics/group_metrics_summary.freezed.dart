// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_metrics_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupSummaryData _$GroupSummaryDataFromJson(Map<String, dynamic> json) {
  return _GroupSummaryData.fromJson(json);
}

/// @nodoc
mixin _$GroupSummaryData {
  @JsonKey(name: 'total_plans_analyzed')
  int? get totalPlansAnalyzed => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_records')
  int? get totalRecords => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_distance_km')
  double? get totalDistanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_distance_per_plan_km')
  double? get avgDistancePerPlanKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_late_minutes')
  int? get totalLateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_late_minutes_per_plan')
  double? get avgLateMinutesPerPlan => throw _privateConstructorUsedError;

  /// Serializes this GroupSummaryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupSummaryDataCopyWith<GroupSummaryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupSummaryDataCopyWith<$Res> {
  factory $GroupSummaryDataCopyWith(
          GroupSummaryData value, $Res Function(GroupSummaryData) then) =
      _$GroupSummaryDataCopyWithImpl<$Res, GroupSummaryData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_plans_analyzed') int? totalPlansAnalyzed,
      @JsonKey(name: 'total_records') int? totalRecords,
      @JsonKey(name: 'total_distance_km') double? totalDistanceKm,
      @JsonKey(name: 'avg_distance_per_plan_km') double? avgDistancePerPlanKm,
      @JsonKey(name: 'total_late_minutes') int? totalLateMinutes,
      @JsonKey(name: 'avg_late_minutes_per_plan')
      double? avgLateMinutesPerPlan});
}

/// @nodoc
class _$GroupSummaryDataCopyWithImpl<$Res, $Val extends GroupSummaryData>
    implements $GroupSummaryDataCopyWith<$Res> {
  _$GroupSummaryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlansAnalyzed = freezed,
    Object? totalRecords = freezed,
    Object? totalDistanceKm = freezed,
    Object? avgDistancePerPlanKm = freezed,
    Object? totalLateMinutes = freezed,
    Object? avgLateMinutesPerPlan = freezed,
  }) {
    return _then(_value.copyWith(
      totalPlansAnalyzed: freezed == totalPlansAnalyzed
          ? _value.totalPlansAnalyzed
          : totalPlansAnalyzed // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecords: freezed == totalRecords
          ? _value.totalRecords
          : totalRecords // ignore: cast_nullable_to_non_nullable
              as int?,
      totalDistanceKm: freezed == totalDistanceKm
          ? _value.totalDistanceKm
          : totalDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      avgDistancePerPlanKm: freezed == avgDistancePerPlanKm
          ? _value.avgDistancePerPlanKm
          : avgDistancePerPlanKm // ignore: cast_nullable_to_non_nullable
              as double?,
      totalLateMinutes: freezed == totalLateMinutes
          ? _value.totalLateMinutes
          : totalLateMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      avgLateMinutesPerPlan: freezed == avgLateMinutesPerPlan
          ? _value.avgLateMinutesPerPlan
          : avgLateMinutesPerPlan // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupSummaryDataImplCopyWith<$Res>
    implements $GroupSummaryDataCopyWith<$Res> {
  factory _$$GroupSummaryDataImplCopyWith(_$GroupSummaryDataImpl value,
          $Res Function(_$GroupSummaryDataImpl) then) =
      __$$GroupSummaryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_plans_analyzed') int? totalPlansAnalyzed,
      @JsonKey(name: 'total_records') int? totalRecords,
      @JsonKey(name: 'total_distance_km') double? totalDistanceKm,
      @JsonKey(name: 'avg_distance_per_plan_km') double? avgDistancePerPlanKm,
      @JsonKey(name: 'total_late_minutes') int? totalLateMinutes,
      @JsonKey(name: 'avg_late_minutes_per_plan')
      double? avgLateMinutesPerPlan});
}

/// @nodoc
class __$$GroupSummaryDataImplCopyWithImpl<$Res>
    extends _$GroupSummaryDataCopyWithImpl<$Res, _$GroupSummaryDataImpl>
    implements _$$GroupSummaryDataImplCopyWith<$Res> {
  __$$GroupSummaryDataImplCopyWithImpl(_$GroupSummaryDataImpl _value,
      $Res Function(_$GroupSummaryDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlansAnalyzed = freezed,
    Object? totalRecords = freezed,
    Object? totalDistanceKm = freezed,
    Object? avgDistancePerPlanKm = freezed,
    Object? totalLateMinutes = freezed,
    Object? avgLateMinutesPerPlan = freezed,
  }) {
    return _then(_$GroupSummaryDataImpl(
      totalPlansAnalyzed: freezed == totalPlansAnalyzed
          ? _value.totalPlansAnalyzed
          : totalPlansAnalyzed // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRecords: freezed == totalRecords
          ? _value.totalRecords
          : totalRecords // ignore: cast_nullable_to_non_nullable
              as int?,
      totalDistanceKm: freezed == totalDistanceKm
          ? _value.totalDistanceKm
          : totalDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      avgDistancePerPlanKm: freezed == avgDistancePerPlanKm
          ? _value.avgDistancePerPlanKm
          : avgDistancePerPlanKm // ignore: cast_nullable_to_non_nullable
              as double?,
      totalLateMinutes: freezed == totalLateMinutes
          ? _value.totalLateMinutes
          : totalLateMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      avgLateMinutesPerPlan: freezed == avgLateMinutesPerPlan
          ? _value.avgLateMinutesPerPlan
          : avgLateMinutesPerPlan // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupSummaryDataImpl implements _GroupSummaryData {
  const _$GroupSummaryDataImpl(
      {@JsonKey(name: 'total_plans_analyzed') this.totalPlansAnalyzed,
      @JsonKey(name: 'total_records') this.totalRecords,
      @JsonKey(name: 'total_distance_km') this.totalDistanceKm,
      @JsonKey(name: 'avg_distance_per_plan_km') this.avgDistancePerPlanKm,
      @JsonKey(name: 'total_late_minutes') this.totalLateMinutes,
      @JsonKey(name: 'avg_late_minutes_per_plan') this.avgLateMinutesPerPlan});

  factory _$GroupSummaryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupSummaryDataImplFromJson(json);

  @override
  @JsonKey(name: 'total_plans_analyzed')
  final int? totalPlansAnalyzed;
  @override
  @JsonKey(name: 'total_records')
  final int? totalRecords;
  @override
  @JsonKey(name: 'total_distance_km')
  final double? totalDistanceKm;
  @override
  @JsonKey(name: 'avg_distance_per_plan_km')
  final double? avgDistancePerPlanKm;
  @override
  @JsonKey(name: 'total_late_minutes')
  final int? totalLateMinutes;
  @override
  @JsonKey(name: 'avg_late_minutes_per_plan')
  final double? avgLateMinutesPerPlan;

  @override
  String toString() {
    return 'GroupSummaryData(totalPlansAnalyzed: $totalPlansAnalyzed, totalRecords: $totalRecords, totalDistanceKm: $totalDistanceKm, avgDistancePerPlanKm: $avgDistancePerPlanKm, totalLateMinutes: $totalLateMinutes, avgLateMinutesPerPlan: $avgLateMinutesPerPlan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupSummaryDataImpl &&
            (identical(other.totalPlansAnalyzed, totalPlansAnalyzed) ||
                other.totalPlansAnalyzed == totalPlansAnalyzed) &&
            (identical(other.totalRecords, totalRecords) ||
                other.totalRecords == totalRecords) &&
            (identical(other.totalDistanceKm, totalDistanceKm) ||
                other.totalDistanceKm == totalDistanceKm) &&
            (identical(other.avgDistancePerPlanKm, avgDistancePerPlanKm) ||
                other.avgDistancePerPlanKm == avgDistancePerPlanKm) &&
            (identical(other.totalLateMinutes, totalLateMinutes) ||
                other.totalLateMinutes == totalLateMinutes) &&
            (identical(other.avgLateMinutesPerPlan, avgLateMinutesPerPlan) ||
                other.avgLateMinutesPerPlan == avgLateMinutesPerPlan));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalPlansAnalyzed,
      totalRecords,
      totalDistanceKm,
      avgDistancePerPlanKm,
      totalLateMinutes,
      avgLateMinutesPerPlan);

  /// Create a copy of GroupSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupSummaryDataImplCopyWith<_$GroupSummaryDataImpl> get copyWith =>
      __$$GroupSummaryDataImplCopyWithImpl<_$GroupSummaryDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupSummaryDataImplToJson(
      this,
    );
  }
}

abstract class _GroupSummaryData implements GroupSummaryData {
  const factory _GroupSummaryData(
      {@JsonKey(name: 'total_plans_analyzed') final int? totalPlansAnalyzed,
      @JsonKey(name: 'total_records') final int? totalRecords,
      @JsonKey(name: 'total_distance_km') final double? totalDistanceKm,
      @JsonKey(name: 'avg_distance_per_plan_km')
      final double? avgDistancePerPlanKm,
      @JsonKey(name: 'total_late_minutes') final int? totalLateMinutes,
      @JsonKey(name: 'avg_late_minutes_per_plan')
      final double? avgLateMinutesPerPlan}) = _$GroupSummaryDataImpl;

  factory _GroupSummaryData.fromJson(Map<String, dynamic> json) =
      _$GroupSummaryDataImpl.fromJson;

  @override
  @JsonKey(name: 'total_plans_analyzed')
  int? get totalPlansAnalyzed;
  @override
  @JsonKey(name: 'total_records')
  int? get totalRecords;
  @override
  @JsonKey(name: 'total_distance_km')
  double? get totalDistanceKm;
  @override
  @JsonKey(name: 'avg_distance_per_plan_km')
  double? get avgDistancePerPlanKm;
  @override
  @JsonKey(name: 'total_late_minutes')
  int? get totalLateMinutes;
  @override
  @JsonKey(name: 'avg_late_minutes_per_plan')
  double? get avgLateMinutesPerPlan;

  /// Create a copy of GroupSummaryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupSummaryDataImplCopyWith<_$GroupSummaryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupMetricsSummary _$GroupMetricsSummaryFromJson(Map<String, dynamic> json) {
  return _GroupMetricsSummary.fromJson(json);
}

/// @nodoc
mixin _$GroupMetricsSummary {
  @JsonKey(name: 'group_id')
  int? get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'summary_status')
  String? get summaryStatus =>
      throw _privateConstructorUsedError; // PENDING, COMPLETED, FAILED
  @JsonKey(name: 'summary')
  String? get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'summary_last_updated_at')
  String? get summaryLastUpdatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_plans_completed')
  int? get totalPlansCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_summary')
  GroupSummaryData? get groupSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'text_summary')
  String? get textSummary => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this GroupMetricsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMetricsSummaryCopyWith<GroupMetricsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMetricsSummaryCopyWith<$Res> {
  factory $GroupMetricsSummaryCopyWith(
          GroupMetricsSummary value, $Res Function(GroupMetricsSummary) then) =
      _$GroupMetricsSummaryCopyWithImpl<$Res, GroupMetricsSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'group_id') int? groupId,
      @JsonKey(name: 'summary_status') String? summaryStatus,
      @JsonKey(name: 'summary') String? summary,
      @JsonKey(name: 'summary_last_updated_at') String? summaryLastUpdatedAt,
      @JsonKey(name: 'total_plans_completed') int? totalPlansCompleted,
      @JsonKey(name: 'group_summary') GroupSummaryData? groupSummary,
      @JsonKey(name: 'text_summary') String? textSummary,
      String? message});

  $GroupSummaryDataCopyWith<$Res>? get groupSummary;
}

/// @nodoc
class _$GroupMetricsSummaryCopyWithImpl<$Res, $Val extends GroupMetricsSummary>
    implements $GroupMetricsSummaryCopyWith<$Res> {
  _$GroupMetricsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = freezed,
    Object? summaryStatus = freezed,
    Object? summary = freezed,
    Object? summaryLastUpdatedAt = freezed,
    Object? totalPlansCompleted = freezed,
    Object? groupSummary = freezed,
    Object? textSummary = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int?,
      summaryStatus: freezed == summaryStatus
          ? _value.summaryStatus
          : summaryStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryLastUpdatedAt: freezed == summaryLastUpdatedAt
          ? _value.summaryLastUpdatedAt
          : summaryLastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPlansCompleted: freezed == totalPlansCompleted
          ? _value.totalPlansCompleted
          : totalPlansCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      groupSummary: freezed == groupSummary
          ? _value.groupSummary
          : groupSummary // ignore: cast_nullable_to_non_nullable
              as GroupSummaryData?,
      textSummary: freezed == textSummary
          ? _value.textSummary
          : textSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupSummaryDataCopyWith<$Res>? get groupSummary {
    if (_value.groupSummary == null) {
      return null;
    }

    return $GroupSummaryDataCopyWith<$Res>(_value.groupSummary!, (value) {
      return _then(_value.copyWith(groupSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupMetricsSummaryImplCopyWith<$Res>
    implements $GroupMetricsSummaryCopyWith<$Res> {
  factory _$$GroupMetricsSummaryImplCopyWith(_$GroupMetricsSummaryImpl value,
          $Res Function(_$GroupMetricsSummaryImpl) then) =
      __$$GroupMetricsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'group_id') int? groupId,
      @JsonKey(name: 'summary_status') String? summaryStatus,
      @JsonKey(name: 'summary') String? summary,
      @JsonKey(name: 'summary_last_updated_at') String? summaryLastUpdatedAt,
      @JsonKey(name: 'total_plans_completed') int? totalPlansCompleted,
      @JsonKey(name: 'group_summary') GroupSummaryData? groupSummary,
      @JsonKey(name: 'text_summary') String? textSummary,
      String? message});

  @override
  $GroupSummaryDataCopyWith<$Res>? get groupSummary;
}

/// @nodoc
class __$$GroupMetricsSummaryImplCopyWithImpl<$Res>
    extends _$GroupMetricsSummaryCopyWithImpl<$Res, _$GroupMetricsSummaryImpl>
    implements _$$GroupMetricsSummaryImplCopyWith<$Res> {
  __$$GroupMetricsSummaryImplCopyWithImpl(_$GroupMetricsSummaryImpl _value,
      $Res Function(_$GroupMetricsSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = freezed,
    Object? summaryStatus = freezed,
    Object? summary = freezed,
    Object? summaryLastUpdatedAt = freezed,
    Object? totalPlansCompleted = freezed,
    Object? groupSummary = freezed,
    Object? textSummary = freezed,
    Object? message = freezed,
  }) {
    return _then(_$GroupMetricsSummaryImpl(
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int?,
      summaryStatus: freezed == summaryStatus
          ? _value.summaryStatus
          : summaryStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryLastUpdatedAt: freezed == summaryLastUpdatedAt
          ? _value.summaryLastUpdatedAt
          : summaryLastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPlansCompleted: freezed == totalPlansCompleted
          ? _value.totalPlansCompleted
          : totalPlansCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      groupSummary: freezed == groupSummary
          ? _value.groupSummary
          : groupSummary // ignore: cast_nullable_to_non_nullable
              as GroupSummaryData?,
      textSummary: freezed == textSummary
          ? _value.textSummary
          : textSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMetricsSummaryImpl implements _GroupMetricsSummary {
  const _$GroupMetricsSummaryImpl(
      {@JsonKey(name: 'group_id') this.groupId,
      @JsonKey(name: 'summary_status') this.summaryStatus,
      @JsonKey(name: 'summary') this.summary,
      @JsonKey(name: 'summary_last_updated_at') this.summaryLastUpdatedAt,
      @JsonKey(name: 'total_plans_completed') this.totalPlansCompleted,
      @JsonKey(name: 'group_summary') this.groupSummary,
      @JsonKey(name: 'text_summary') this.textSummary,
      this.message});

  factory _$GroupMetricsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMetricsSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'group_id')
  final int? groupId;
  @override
  @JsonKey(name: 'summary_status')
  final String? summaryStatus;
// PENDING, COMPLETED, FAILED
  @override
  @JsonKey(name: 'summary')
  final String? summary;
  @override
  @JsonKey(name: 'summary_last_updated_at')
  final String? summaryLastUpdatedAt;
  @override
  @JsonKey(name: 'total_plans_completed')
  final int? totalPlansCompleted;
  @override
  @JsonKey(name: 'group_summary')
  final GroupSummaryData? groupSummary;
  @override
  @JsonKey(name: 'text_summary')
  final String? textSummary;
  @override
  final String? message;

  @override
  String toString() {
    return 'GroupMetricsSummary(groupId: $groupId, summaryStatus: $summaryStatus, summary: $summary, summaryLastUpdatedAt: $summaryLastUpdatedAt, totalPlansCompleted: $totalPlansCompleted, groupSummary: $groupSummary, textSummary: $textSummary, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMetricsSummaryImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.summaryStatus, summaryStatus) ||
                other.summaryStatus == summaryStatus) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.summaryLastUpdatedAt, summaryLastUpdatedAt) ||
                other.summaryLastUpdatedAt == summaryLastUpdatedAt) &&
            (identical(other.totalPlansCompleted, totalPlansCompleted) ||
                other.totalPlansCompleted == totalPlansCompleted) &&
            (identical(other.groupSummary, groupSummary) ||
                other.groupSummary == groupSummary) &&
            (identical(other.textSummary, textSummary) ||
                other.textSummary == textSummary) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupId,
      summaryStatus,
      summary,
      summaryLastUpdatedAt,
      totalPlansCompleted,
      groupSummary,
      textSummary,
      message);

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMetricsSummaryImplCopyWith<_$GroupMetricsSummaryImpl> get copyWith =>
      __$$GroupMetricsSummaryImplCopyWithImpl<_$GroupMetricsSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMetricsSummaryImplToJson(
      this,
    );
  }
}

abstract class _GroupMetricsSummary implements GroupMetricsSummary {
  const factory _GroupMetricsSummary(
      {@JsonKey(name: 'group_id') final int? groupId,
      @JsonKey(name: 'summary_status') final String? summaryStatus,
      @JsonKey(name: 'summary') final String? summary,
      @JsonKey(name: 'summary_last_updated_at')
      final String? summaryLastUpdatedAt,
      @JsonKey(name: 'total_plans_completed') final int? totalPlansCompleted,
      @JsonKey(name: 'group_summary') final GroupSummaryData? groupSummary,
      @JsonKey(name: 'text_summary') final String? textSummary,
      final String? message}) = _$GroupMetricsSummaryImpl;

  factory _GroupMetricsSummary.fromJson(Map<String, dynamic> json) =
      _$GroupMetricsSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'group_id')
  int? get groupId;
  @override
  @JsonKey(name: 'summary_status')
  String? get summaryStatus; // PENDING, COMPLETED, FAILED
  @override
  @JsonKey(name: 'summary')
  String? get summary;
  @override
  @JsonKey(name: 'summary_last_updated_at')
  String? get summaryLastUpdatedAt;
  @override
  @JsonKey(name: 'total_plans_completed')
  int? get totalPlansCompleted;
  @override
  @JsonKey(name: 'group_summary')
  GroupSummaryData? get groupSummary;
  @override
  @JsonKey(name: 'text_summary')
  String? get textSummary;
  @override
  String? get message;

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMetricsSummaryImplCopyWith<_$GroupMetricsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
