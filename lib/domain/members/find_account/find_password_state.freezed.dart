// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'find_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FindPasswordState {
  /// 로딩 상태
  bool get isLoading => throw _privateConstructorUsedError;

  /// 성공 시 표시될 메시지
  String? get successMessage => throw _privateConstructorUsedError;

  /// 에러 발생 시 표시될 메시지
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FindPasswordStateCopyWith<FindPasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FindPasswordStateCopyWith<$Res> {
  factory $FindPasswordStateCopyWith(
          FindPasswordState value, $Res Function(FindPasswordState) then) =
      _$FindPasswordStateCopyWithImpl<$Res, FindPasswordState>;
  @useResult
  $Res call({bool isLoading, String? successMessage, String? error});
}

/// @nodoc
class _$FindPasswordStateCopyWithImpl<$Res, $Val extends FindPasswordState>
    implements $FindPasswordStateCopyWith<$Res> {
  _$FindPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? successMessage = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FindPasswordStateImplCopyWith<$Res>
    implements $FindPasswordStateCopyWith<$Res> {
  factory _$$FindPasswordStateImplCopyWith(_$FindPasswordStateImpl value,
          $Res Function(_$FindPasswordStateImpl) then) =
      __$$FindPasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? successMessage, String? error});
}

/// @nodoc
class __$$FindPasswordStateImplCopyWithImpl<$Res>
    extends _$FindPasswordStateCopyWithImpl<$Res, _$FindPasswordStateImpl>
    implements _$$FindPasswordStateImplCopyWith<$Res> {
  __$$FindPasswordStateImplCopyWithImpl(_$FindPasswordStateImpl _value,
      $Res Function(_$FindPasswordStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? successMessage = freezed,
    Object? error = freezed,
  }) {
    return _then(_$FindPasswordStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FindPasswordStateImpl implements _FindPasswordState {
  const _$FindPasswordStateImpl(
      {this.isLoading = false, this.successMessage, this.error});

  /// 로딩 상태
  @override
  @JsonKey()
  final bool isLoading;

  /// 성공 시 표시될 메시지
  @override
  final String? successMessage;

  /// 에러 발생 시 표시될 메시지
  @override
  final String? error;

  @override
  String toString() {
    return 'FindPasswordState(isLoading: $isLoading, successMessage: $successMessage, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FindPasswordStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, successMessage, error);

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FindPasswordStateImplCopyWith<_$FindPasswordStateImpl> get copyWith =>
      __$$FindPasswordStateImplCopyWithImpl<_$FindPasswordStateImpl>(
          this, _$identity);
}

abstract class _FindPasswordState implements FindPasswordState {
  const factory _FindPasswordState(
      {final bool isLoading,
      final String? successMessage,
      final String? error}) = _$FindPasswordStateImpl;

  /// 로딩 상태
  @override
  bool get isLoading;

  /// 성공 시 표시될 메시지
  @override
  String? get successMessage;

  /// 에러 발생 시 표시될 메시지
  @override
  String? get error;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FindPasswordStateImplCopyWith<_$FindPasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
