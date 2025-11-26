// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metrics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MetricsState {
// 요약 로딩 상태
  bool get isSummaryLoading => throw _privateConstructorUsedError; // 요약 상태
  SummaryStatus get summaryStatus =>
      throw _privateConstructorUsedError; // 요약 데이터 (완료 시)
  String? get summaryText => throw _privateConstructorUsedError;
  int? get summaryPlanId => throw _privateConstructorUsedError;
  String? get summaryTitle => throw _privateConstructorUsedError; // 에러 메시지
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of MetricsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetricsStateCopyWith<MetricsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricsStateCopyWith<$Res> {
  factory $MetricsStateCopyWith(
          MetricsState value, $Res Function(MetricsState) then) =
      _$MetricsStateCopyWithImpl<$Res, MetricsState>;
  @useResult
  $Res call(
      {bool isSummaryLoading,
      SummaryStatus summaryStatus,
      String? summaryText,
      int? summaryPlanId,
      String? summaryTitle,
      String? error});
}

/// @nodoc
class _$MetricsStateCopyWithImpl<$Res, $Val extends MetricsState>
    implements $MetricsStateCopyWith<$Res> {
  _$MetricsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetricsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSummaryLoading = null,
    Object? summaryStatus = null,
    Object? summaryText = freezed,
    Object? summaryPlanId = freezed,
    Object? summaryTitle = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isSummaryLoading: null == isSummaryLoading
          ? _value.isSummaryLoading
          : isSummaryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      summaryStatus: null == summaryStatus
          ? _value.summaryStatus
          : summaryStatus // ignore: cast_nullable_to_non_nullable
              as SummaryStatus,
      summaryText: freezed == summaryText
          ? _value.summaryText
          : summaryText // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryPlanId: freezed == summaryPlanId
          ? _value.summaryPlanId
          : summaryPlanId // ignore: cast_nullable_to_non_nullable
              as int?,
      summaryTitle: freezed == summaryTitle
          ? _value.summaryTitle
          : summaryTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetricsStateImplCopyWith<$Res>
    implements $MetricsStateCopyWith<$Res> {
  factory _$$MetricsStateImplCopyWith(
          _$MetricsStateImpl value, $Res Function(_$MetricsStateImpl) then) =
      __$$MetricsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isSummaryLoading,
      SummaryStatus summaryStatus,
      String? summaryText,
      int? summaryPlanId,
      String? summaryTitle,
      String? error});
}

/// @nodoc
class __$$MetricsStateImplCopyWithImpl<$Res>
    extends _$MetricsStateCopyWithImpl<$Res, _$MetricsStateImpl>
    implements _$$MetricsStateImplCopyWith<$Res> {
  __$$MetricsStateImplCopyWithImpl(
      _$MetricsStateImpl _value, $Res Function(_$MetricsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetricsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSummaryLoading = null,
    Object? summaryStatus = null,
    Object? summaryText = freezed,
    Object? summaryPlanId = freezed,
    Object? summaryTitle = freezed,
    Object? error = freezed,
  }) {
    return _then(_$MetricsStateImpl(
      isSummaryLoading: null == isSummaryLoading
          ? _value.isSummaryLoading
          : isSummaryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      summaryStatus: null == summaryStatus
          ? _value.summaryStatus
          : summaryStatus // ignore: cast_nullable_to_non_nullable
              as SummaryStatus,
      summaryText: freezed == summaryText
          ? _value.summaryText
          : summaryText // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryPlanId: freezed == summaryPlanId
          ? _value.summaryPlanId
          : summaryPlanId // ignore: cast_nullable_to_non_nullable
              as int?,
      summaryTitle: freezed == summaryTitle
          ? _value.summaryTitle
          : summaryTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MetricsStateImpl implements _MetricsState {
  const _$MetricsStateImpl(
      {this.isSummaryLoading = false,
      this.summaryStatus = SummaryStatus.idle,
      this.summaryText,
      this.summaryPlanId,
      this.summaryTitle,
      this.error});

// 요약 로딩 상태
  @override
  @JsonKey()
  final bool isSummaryLoading;
// 요약 상태
  @override
  @JsonKey()
  final SummaryStatus summaryStatus;
// 요약 데이터 (완료 시)
  @override
  final String? summaryText;
  @override
  final int? summaryPlanId;
  @override
  final String? summaryTitle;
// 에러 메시지
  @override
  final String? error;

  @override
  String toString() {
    return 'MetricsState(isSummaryLoading: $isSummaryLoading, summaryStatus: $summaryStatus, summaryText: $summaryText, summaryPlanId: $summaryPlanId, summaryTitle: $summaryTitle, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricsStateImpl &&
            (identical(other.isSummaryLoading, isSummaryLoading) ||
                other.isSummaryLoading == isSummaryLoading) &&
            (identical(other.summaryStatus, summaryStatus) ||
                other.summaryStatus == summaryStatus) &&
            (identical(other.summaryText, summaryText) ||
                other.summaryText == summaryText) &&
            (identical(other.summaryPlanId, summaryPlanId) ||
                other.summaryPlanId == summaryPlanId) &&
            (identical(other.summaryTitle, summaryTitle) ||
                other.summaryTitle == summaryTitle) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSummaryLoading, summaryStatus,
      summaryText, summaryPlanId, summaryTitle, error);

  /// Create a copy of MetricsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricsStateImplCopyWith<_$MetricsStateImpl> get copyWith =>
      __$$MetricsStateImplCopyWithImpl<_$MetricsStateImpl>(this, _$identity);
}

abstract class _MetricsState implements MetricsState {
  const factory _MetricsState(
      {final bool isSummaryLoading,
      final SummaryStatus summaryStatus,
      final String? summaryText,
      final int? summaryPlanId,
      final String? summaryTitle,
      final String? error}) = _$MetricsStateImpl;

// 요약 로딩 상태
  @override
  bool get isSummaryLoading; // 요약 상태
  @override
  SummaryStatus get summaryStatus; // 요약 데이터 (완료 시)
  @override
  String? get summaryText;
  @override
  int? get summaryPlanId;
  @override
  String? get summaryTitle; // 에러 메시지
  @override
  String? get error;

  /// Create a copy of MetricsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetricsStateImplCopyWith<_$MetricsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
