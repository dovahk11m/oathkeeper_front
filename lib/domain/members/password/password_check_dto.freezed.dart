// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_check_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PasswordCheckDto _$PasswordCheckDtoFromJson(Map<String, dynamic> json) {
  return _PasswordCheckDto.fromJson(json);
}

/// @nodoc
mixin _$PasswordCheckDto {
  String get password => throw _privateConstructorUsedError;

  /// Serializes this PasswordCheckDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordCheckDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordCheckDtoCopyWith<PasswordCheckDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordCheckDtoCopyWith<$Res> {
  factory $PasswordCheckDtoCopyWith(
          PasswordCheckDto value, $Res Function(PasswordCheckDto) then) =
      _$PasswordCheckDtoCopyWithImpl<$Res, PasswordCheckDto>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class _$PasswordCheckDtoCopyWithImpl<$Res, $Val extends PasswordCheckDto>
    implements $PasswordCheckDtoCopyWith<$Res> {
  _$PasswordCheckDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordCheckDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordCheckDtoImplCopyWith<$Res>
    implements $PasswordCheckDtoCopyWith<$Res> {
  factory _$$PasswordCheckDtoImplCopyWith(_$PasswordCheckDtoImpl value,
          $Res Function(_$PasswordCheckDtoImpl) then) =
      __$$PasswordCheckDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$PasswordCheckDtoImplCopyWithImpl<$Res>
    extends _$PasswordCheckDtoCopyWithImpl<$Res, _$PasswordCheckDtoImpl>
    implements _$$PasswordCheckDtoImplCopyWith<$Res> {
  __$$PasswordCheckDtoImplCopyWithImpl(_$PasswordCheckDtoImpl _value,
      $Res Function(_$PasswordCheckDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordCheckDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
  }) {
    return _then(_$PasswordCheckDtoImpl(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordCheckDtoImpl implements _PasswordCheckDto {
  const _$PasswordCheckDtoImpl({required this.password});

  factory _$PasswordCheckDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordCheckDtoImplFromJson(json);

  @override
  final String password;

  @override
  String toString() {
    return 'PasswordCheckDto(password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordCheckDtoImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, password);

  /// Create a copy of PasswordCheckDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordCheckDtoImplCopyWith<_$PasswordCheckDtoImpl> get copyWith =>
      __$$PasswordCheckDtoImplCopyWithImpl<_$PasswordCheckDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordCheckDtoImplToJson(
      this,
    );
  }
}

abstract class _PasswordCheckDto implements PasswordCheckDto {
  const factory _PasswordCheckDto({required final String password}) =
      _$PasswordCheckDtoImpl;

  factory _PasswordCheckDto.fromJson(Map<String, dynamic> json) =
      _$PasswordCheckDtoImpl.fromJson;

  @override
  String get password;

  /// Create a copy of PasswordCheckDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordCheckDtoImplCopyWith<_$PasswordCheckDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
