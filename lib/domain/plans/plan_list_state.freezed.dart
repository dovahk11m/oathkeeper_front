// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlanListState {
  List<SimplePlan> get plans => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of PlanListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanListStateCopyWith<PlanListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanListStateCopyWith<$Res> {
  factory $PlanListStateCopyWith(
          PlanListState value, $Res Function(PlanListState) then) =
      _$PlanListStateCopyWithImpl<$Res, PlanListState>;
  @useResult
  $Res call({List<SimplePlan> plans, bool isLoading, String? error});
}

/// @nodoc
class _$PlanListStateCopyWithImpl<$Res, $Val extends PlanListState>
    implements $PlanListStateCopyWith<$Res> {
  _$PlanListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plans = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      plans: null == plans
          ? _value.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<SimplePlan>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanListStateImplCopyWith<$Res>
    implements $PlanListStateCopyWith<$Res> {
  factory _$$PlanListStateImplCopyWith(
          _$PlanListStateImpl value, $Res Function(_$PlanListStateImpl) then) =
      __$$PlanListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SimplePlan> plans, bool isLoading, String? error});
}

/// @nodoc
class __$$PlanListStateImplCopyWithImpl<$Res>
    extends _$PlanListStateCopyWithImpl<$Res, _$PlanListStateImpl>
    implements _$$PlanListStateImplCopyWith<$Res> {
  __$$PlanListStateImplCopyWithImpl(
      _$PlanListStateImpl _value, $Res Function(_$PlanListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plans = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$PlanListStateImpl(
      plans: null == plans
          ? _value._plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<SimplePlan>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PlanListStateImpl implements _PlanListState {
  const _$PlanListStateImpl(
      {final List<SimplePlan> plans = const [],
      this.isLoading = false,
      this.error})
      : _plans = plans;

  final List<SimplePlan> _plans;
  @override
  @JsonKey()
  List<SimplePlan> get plans {
    if (_plans is EqualUnmodifiableListView) return _plans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plans);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'PlanListState(plans: $plans, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanListStateImpl &&
            const DeepCollectionEquality().equals(other._plans, _plans) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_plans), isLoading, error);

  /// Create a copy of PlanListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanListStateImplCopyWith<_$PlanListStateImpl> get copyWith =>
      __$$PlanListStateImplCopyWithImpl<_$PlanListStateImpl>(this, _$identity);
}

abstract class _PlanListState implements PlanListState {
  const factory _PlanListState(
      {final List<SimplePlan> plans,
      final bool isLoading,
      final String? error}) = _$PlanListStateImpl;

  @override
  List<SimplePlan> get plans;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of PlanListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanListStateImplCopyWith<_$PlanListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
