// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_metrics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GroupMetricsState {
// 로딩 상태
  bool get isLoading =>
      throw _privateConstructorUsedError; // 요약 상태 (PENDING, COMPLETED, FAILED)
  SummaryStatus get summaryStatus =>
      throw _privateConstructorUsedError; // 요약 데이터
  GroupMetricsSummary? get summary =>
      throw _privateConstructorUsedError; // 에러 메시지
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of GroupMetricsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMetricsStateCopyWith<GroupMetricsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMetricsStateCopyWith<$Res> {
  factory $GroupMetricsStateCopyWith(
          GroupMetricsState value, $Res Function(GroupMetricsState) then) =
      _$GroupMetricsStateCopyWithImpl<$Res, GroupMetricsState>;
  @useResult
  $Res call(
      {bool isLoading,
      SummaryStatus summaryStatus,
      GroupMetricsSummary? summary,
      String? error});

  $GroupMetricsSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class _$GroupMetricsStateCopyWithImpl<$Res, $Val extends GroupMetricsState>
    implements $GroupMetricsStateCopyWith<$Res> {
  _$GroupMetricsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMetricsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? summaryStatus = null,
    Object? summary = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      summaryStatus: null == summaryStatus
          ? _value.summaryStatus
          : summaryStatus // ignore: cast_nullable_to_non_nullable
              as SummaryStatus,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as GroupMetricsSummary?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of GroupMetricsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupMetricsSummaryCopyWith<$Res>? get summary {
    if (_value.summary == null) {
      return null;
    }

    return $GroupMetricsSummaryCopyWith<$Res>(_value.summary!, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupMetricsStateImplCopyWith<$Res>
    implements $GroupMetricsStateCopyWith<$Res> {
  factory _$$GroupMetricsStateImplCopyWith(_$GroupMetricsStateImpl value,
          $Res Function(_$GroupMetricsStateImpl) then) =
      __$$GroupMetricsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      SummaryStatus summaryStatus,
      GroupMetricsSummary? summary,
      String? error});

  @override
  $GroupMetricsSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class __$$GroupMetricsStateImplCopyWithImpl<$Res>
    extends _$GroupMetricsStateCopyWithImpl<$Res, _$GroupMetricsStateImpl>
    implements _$$GroupMetricsStateImplCopyWith<$Res> {
  __$$GroupMetricsStateImplCopyWithImpl(_$GroupMetricsStateImpl _value,
      $Res Function(_$GroupMetricsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupMetricsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? summaryStatus = null,
    Object? summary = freezed,
    Object? error = freezed,
  }) {
    return _then(_$GroupMetricsStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      summaryStatus: null == summaryStatus
          ? _value.summaryStatus
          : summaryStatus // ignore: cast_nullable_to_non_nullable
              as SummaryStatus,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as GroupMetricsSummary?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GroupMetricsStateImpl implements _GroupMetricsState {
  const _$GroupMetricsStateImpl(
      {this.isLoading = false,
      this.summaryStatus = SummaryStatus.idle,
      this.summary,
      this.error});

// 로딩 상태
  @override
  @JsonKey()
  final bool isLoading;
// 요약 상태 (PENDING, COMPLETED, FAILED)
  @override
  @JsonKey()
  final SummaryStatus summaryStatus;
// 요약 데이터
  @override
  final GroupMetricsSummary? summary;
// 에러 메시지
  @override
  final String? error;

  @override
  String toString() {
    return 'GroupMetricsState(isLoading: $isLoading, summaryStatus: $summaryStatus, summary: $summary, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMetricsStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.summaryStatus, summaryStatus) ||
                other.summaryStatus == summaryStatus) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, summaryStatus, summary, error);

  /// Create a copy of GroupMetricsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMetricsStateImplCopyWith<_$GroupMetricsStateImpl> get copyWith =>
      __$$GroupMetricsStateImplCopyWithImpl<_$GroupMetricsStateImpl>(
          this, _$identity);
}

abstract class _GroupMetricsState implements GroupMetricsState {
  const factory _GroupMetricsState(
      {final bool isLoading,
      final SummaryStatus summaryStatus,
      final GroupMetricsSummary? summary,
      final String? error}) = _$GroupMetricsStateImpl;

// 로딩 상태
  @override
  bool get isLoading; // 요약 상태 (PENDING, COMPLETED, FAILED)
  @override
  SummaryStatus get summaryStatus; // 요약 데이터
  @override
  GroupMetricsSummary? get summary; // 에러 메시지
  @override
  String? get error;

  /// Create a copy of GroupMetricsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMetricsStateImplCopyWith<_$GroupMetricsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
