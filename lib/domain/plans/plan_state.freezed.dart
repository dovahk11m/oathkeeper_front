// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlanState {
  List<Plan> get plans => throw _privateConstructorUsedError;
  Plan? get selectedPlan => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanStateCopyWith<PlanState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanStateCopyWith<$Res> {
  factory $PlanStateCopyWith(PlanState value, $Res Function(PlanState) then) =
      _$PlanStateCopyWithImpl<$Res, PlanState>;
  @useResult
  $Res call(
      {List<Plan> plans, Plan? selectedPlan, bool isLoading, String? error});

  $PlanCopyWith<$Res>? get selectedPlan;
}

/// @nodoc
class _$PlanStateCopyWithImpl<$Res, $Val extends PlanState>
    implements $PlanStateCopyWith<$Res> {
  _$PlanStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plans = null,
    Object? selectedPlan = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      plans: null == plans
          ? _value.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<Plan>,
      selectedPlan: freezed == selectedPlan
          ? _value.selectedPlan
          : selectedPlan // ignore: cast_nullable_to_non_nullable
              as Plan?,
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

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlanCopyWith<$Res>? get selectedPlan {
    if (_value.selectedPlan == null) {
      return null;
    }

    return $PlanCopyWith<$Res>(_value.selectedPlan!, (value) {
      return _then(_value.copyWith(selectedPlan: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlanStateImplCopyWith<$Res>
    implements $PlanStateCopyWith<$Res> {
  factory _$$PlanStateImplCopyWith(
          _$PlanStateImpl value, $Res Function(_$PlanStateImpl) then) =
      __$$PlanStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Plan> plans, Plan? selectedPlan, bool isLoading, String? error});

  @override
  $PlanCopyWith<$Res>? get selectedPlan;
}

/// @nodoc
class __$$PlanStateImplCopyWithImpl<$Res>
    extends _$PlanStateCopyWithImpl<$Res, _$PlanStateImpl>
    implements _$$PlanStateImplCopyWith<$Res> {
  __$$PlanStateImplCopyWithImpl(
      _$PlanStateImpl _value, $Res Function(_$PlanStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plans = null,
    Object? selectedPlan = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$PlanStateImpl(
      plans: null == plans
          ? _value._plans
          : plans // ignore: cast_nullable_to_non_nullable
              as List<Plan>,
      selectedPlan: freezed == selectedPlan
          ? _value.selectedPlan
          : selectedPlan // ignore: cast_nullable_to_non_nullable
              as Plan?,
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

class _$PlanStateImpl implements _PlanState {
  const _$PlanStateImpl(
      {final List<Plan> plans = const [],
      this.selectedPlan,
      this.isLoading = false,
      this.error})
      : _plans = plans;

  final List<Plan> _plans;
  @override
  @JsonKey()
  List<Plan> get plans {
    if (_plans is EqualUnmodifiableListView) return _plans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plans);
  }

  @override
  final Plan? selectedPlan;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'PlanState(plans: $plans, selectedPlan: $selectedPlan, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanStateImpl &&
            const DeepCollectionEquality().equals(other._plans, _plans) &&
            (identical(other.selectedPlan, selectedPlan) ||
                other.selectedPlan == selectedPlan) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_plans),
      selectedPlan,
      isLoading,
      error);

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanStateImplCopyWith<_$PlanStateImpl> get copyWith =>
      __$$PlanStateImplCopyWithImpl<_$PlanStateImpl>(this, _$identity);
}

abstract class _PlanState implements PlanState {
  const factory _PlanState(
      {final List<Plan> plans,
      final Plan? selectedPlan,
      final bool isLoading,
      final String? error}) = _$PlanStateImpl;

  @override
  List<Plan> get plans;
  @override
  Plan? get selectedPlan;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanStateImplCopyWith<_$PlanStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
