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

GroupMetricsSummary _$GroupMetricsSummaryFromJson(Map<String, dynamic> json) {
  return _GroupMetricsSummary.fromJson(json);
}

/// @nodoc
mixin _$GroupMetricsSummary {
  int get groupId => throw _privateConstructorUsedError;
  String? get summary =>
      throw _privateConstructorUsedError; // AI 요약 텍스트 (COMPLETED 시에만 존재)
  String get status =>
      throw _privateConstructorUsedError; // PENDING, COMPLETED, FAILED
  String get lastUpdatedAt => throw _privateConstructorUsedError; // ISO 8601 형식
  String? get reason => throw _privateConstructorUsedError;

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
      {int groupId,
      String? summary,
      String status,
      String lastUpdatedAt,
      String? reason});
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
    Object? groupId = null,
    Object? summary = freezed,
    Object? status = null,
    Object? lastUpdatedAt = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
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
      {int groupId,
      String? summary,
      String status,
      String lastUpdatedAt,
      String? reason});
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
    Object? groupId = null,
    Object? summary = freezed,
    Object? status = null,
    Object? lastUpdatedAt = null,
    Object? reason = freezed,
  }) {
    return _then(_$GroupMetricsSummaryImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMetricsSummaryImpl implements _GroupMetricsSummary {
  const _$GroupMetricsSummaryImpl(
      {required this.groupId,
      this.summary,
      required this.status,
      required this.lastUpdatedAt,
      this.reason});

  factory _$GroupMetricsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMetricsSummaryImplFromJson(json);

  @override
  final int groupId;
  @override
  final String? summary;
// AI 요약 텍스트 (COMPLETED 시에만 존재)
  @override
  final String status;
// PENDING, COMPLETED, FAILED
  @override
  final String lastUpdatedAt;
// ISO 8601 형식
  @override
  final String? reason;

  @override
  String toString() {
    return 'GroupMetricsSummary(groupId: $groupId, summary: $summary, status: $status, lastUpdatedAt: $lastUpdatedAt, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMetricsSummaryImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastUpdatedAt, lastUpdatedAt) ||
                other.lastUpdatedAt == lastUpdatedAt) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, groupId, summary, status, lastUpdatedAt, reason);

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
      {required final int groupId,
      final String? summary,
      required final String status,
      required final String lastUpdatedAt,
      final String? reason}) = _$GroupMetricsSummaryImpl;

  factory _GroupMetricsSummary.fromJson(Map<String, dynamic> json) =
      _$GroupMetricsSummaryImpl.fromJson;

  @override
  int get groupId;
  @override
  String? get summary; // AI 요약 텍스트 (COMPLETED 시에만 존재)
  @override
  String get status; // PENDING, COMPLETED, FAILED
  @override
  String get lastUpdatedAt; // ISO 8601 형식
  @override
  String? get reason;

  /// Create a copy of GroupMetricsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMetricsSummaryImplCopyWith<_$GroupMetricsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
