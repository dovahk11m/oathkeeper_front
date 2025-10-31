// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PasswordState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isPasswordChecked => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get verifiedPassword => throw _privateConstructorUsedError;

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordStateCopyWith<PasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordStateCopyWith<$Res> {
  factory $PasswordStateCopyWith(
          PasswordState value, $Res Function(PasswordState) then) =
      _$PasswordStateCopyWithImpl<$Res, PasswordState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isPasswordChecked,
      bool isSuccess,
      String? errorMessage,
      String? verifiedPassword});
}

/// @nodoc
class _$PasswordStateCopyWithImpl<$Res, $Val extends PasswordState>
    implements $PasswordStateCopyWith<$Res> {
  _$PasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isPasswordChecked = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? verifiedPassword = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPasswordChecked: null == isPasswordChecked
          ? _value.isPasswordChecked
          : isPasswordChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedPassword: freezed == verifiedPassword
          ? _value.verifiedPassword
          : verifiedPassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordStateImplCopyWith<$Res>
    implements $PasswordStateCopyWith<$Res> {
  factory _$$PasswordStateImplCopyWith(
          _$PasswordStateImpl value, $Res Function(_$PasswordStateImpl) then) =
      __$$PasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isPasswordChecked,
      bool isSuccess,
      String? errorMessage,
      String? verifiedPassword});
}

/// @nodoc
class __$$PasswordStateImplCopyWithImpl<$Res>
    extends _$PasswordStateCopyWithImpl<$Res, _$PasswordStateImpl>
    implements _$$PasswordStateImplCopyWith<$Res> {
  __$$PasswordStateImplCopyWithImpl(
      _$PasswordStateImpl _value, $Res Function(_$PasswordStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isPasswordChecked = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? verifiedPassword = freezed,
  }) {
    return _then(_$PasswordStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPasswordChecked: null == isPasswordChecked
          ? _value.isPasswordChecked
          : isPasswordChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedPassword: freezed == verifiedPassword
          ? _value.verifiedPassword
          : verifiedPassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PasswordStateImpl implements _PasswordState {
  const _$PasswordStateImpl(
      {this.isLoading = false,
      this.isPasswordChecked = false,
      this.isSuccess = false,
      this.errorMessage,
      this.verifiedPassword});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isPasswordChecked;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  final String? errorMessage;
  @override
  final String? verifiedPassword;

  @override
  String toString() {
    return 'PasswordState(isLoading: $isLoading, isPasswordChecked: $isPasswordChecked, isSuccess: $isSuccess, errorMessage: $errorMessage, verifiedPassword: $verifiedPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isPasswordChecked, isPasswordChecked) ||
                other.isPasswordChecked == isPasswordChecked) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.verifiedPassword, verifiedPassword) ||
                other.verifiedPassword == verifiedPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isPasswordChecked,
      isSuccess, errorMessage, verifiedPassword);

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordStateImplCopyWith<_$PasswordStateImpl> get copyWith =>
      __$$PasswordStateImplCopyWithImpl<_$PasswordStateImpl>(this, _$identity);
}

abstract class _PasswordState implements PasswordState {
  const factory _PasswordState(
      {final bool isLoading,
      final bool isPasswordChecked,
      final bool isSuccess,
      final String? errorMessage,
      final String? verifiedPassword}) = _$PasswordStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isPasswordChecked;
  @override
  bool get isSuccess;
  @override
  String? get errorMessage;
  @override
  String? get verifiedPassword;

  /// Create a copy of PasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordStateImplCopyWith<_$PasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
