// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'term_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TermState {
  List<Term> get terms => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of TermState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TermStateCopyWith<TermState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermStateCopyWith<$Res> {
  factory $TermStateCopyWith(TermState value, $Res Function(TermState) then) =
      _$TermStateCopyWithImpl<$Res, TermState>;
  @useResult
  $Res call({List<Term> terms, bool isLoading, String? error});
}

/// @nodoc
class _$TermStateCopyWithImpl<$Res, $Val extends TermState>
    implements $TermStateCopyWith<$Res> {
  _$TermStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TermState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terms = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      terms: null == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as List<Term>,
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
abstract class _$$TermStateImplCopyWith<$Res>
    implements $TermStateCopyWith<$Res> {
  factory _$$TermStateImplCopyWith(
          _$TermStateImpl value, $Res Function(_$TermStateImpl) then) =
      __$$TermStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Term> terms, bool isLoading, String? error});
}

/// @nodoc
class __$$TermStateImplCopyWithImpl<$Res>
    extends _$TermStateCopyWithImpl<$Res, _$TermStateImpl>
    implements _$$TermStateImplCopyWith<$Res> {
  __$$TermStateImplCopyWithImpl(
      _$TermStateImpl _value, $Res Function(_$TermStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TermState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terms = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$TermStateImpl(
      terms: null == terms
          ? _value._terms
          : terms // ignore: cast_nullable_to_non_nullable
              as List<Term>,
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

class _$TermStateImpl implements _TermState {
  const _$TermStateImpl(
      {final List<Term> terms = const [], this.isLoading = false, this.error})
      : _terms = terms;

  final List<Term> _terms;
  @override
  @JsonKey()
  List<Term> get terms {
    if (_terms is EqualUnmodifiableListView) return _terms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_terms);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'TermState(terms: $terms, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermStateImpl &&
            const DeepCollectionEquality().equals(other._terms, _terms) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_terms), isLoading, error);

  /// Create a copy of TermState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TermStateImplCopyWith<_$TermStateImpl> get copyWith =>
      __$$TermStateImplCopyWithImpl<_$TermStateImpl>(this, _$identity);
}

abstract class _TermState implements TermState {
  const factory _TermState(
      {final List<Term> terms,
      final bool isLoading,
      final String? error}) = _$TermStateImpl;

  @override
  List<Term> get terms;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of TermState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TermStateImplCopyWith<_$TermStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
