// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PasswordUpdateDto _$PasswordUpdateDtoFromJson(Map<String, dynamic> json) {
  return _PasswordUpdateDto.fromJson(json);
}

/// @nodoc
mixin _$PasswordUpdateDto {
  String get currentPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this PasswordUpdateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PasswordUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PasswordUpdateDtoCopyWith<PasswordUpdateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordUpdateDtoCopyWith<$Res> {
  factory $PasswordUpdateDtoCopyWith(
          PasswordUpdateDto value, $Res Function(PasswordUpdateDto) then) =
      _$PasswordUpdateDtoCopyWithImpl<$Res, PasswordUpdateDto>;
  @useResult
  $Res call({String currentPassword, String newPassword});
}

/// @nodoc
class _$PasswordUpdateDtoCopyWithImpl<$Res, $Val extends PasswordUpdateDto>
    implements $PasswordUpdateDtoCopyWith<$Res> {
  _$PasswordUpdateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PasswordUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      currentPassword: null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordUpdateDtoImplCopyWith<$Res>
    implements $PasswordUpdateDtoCopyWith<$Res> {
  factory _$$PasswordUpdateDtoImplCopyWith(_$PasswordUpdateDtoImpl value,
          $Res Function(_$PasswordUpdateDtoImpl) then) =
      __$$PasswordUpdateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentPassword, String newPassword});
}

/// @nodoc
class __$$PasswordUpdateDtoImplCopyWithImpl<$Res>
    extends _$PasswordUpdateDtoCopyWithImpl<$Res, _$PasswordUpdateDtoImpl>
    implements _$$PasswordUpdateDtoImplCopyWith<$Res> {
  __$$PasswordUpdateDtoImplCopyWithImpl(_$PasswordUpdateDtoImpl _value,
      $Res Function(_$PasswordUpdateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PasswordUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_$PasswordUpdateDtoImpl(
      currentPassword: null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PasswordUpdateDtoImpl implements _PasswordUpdateDto {
  const _$PasswordUpdateDtoImpl(
      {required this.currentPassword, required this.newPassword});

  factory _$PasswordUpdateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordUpdateDtoImplFromJson(json);

  @override
  final String currentPassword;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'PasswordUpdateDto(currentPassword: $currentPassword, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordUpdateDtoImpl &&
            (identical(other.currentPassword, currentPassword) ||
                other.currentPassword == currentPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPassword, newPassword);

  /// Create a copy of PasswordUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordUpdateDtoImplCopyWith<_$PasswordUpdateDtoImpl> get copyWith =>
      __$$PasswordUpdateDtoImplCopyWithImpl<_$PasswordUpdateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordUpdateDtoImplToJson(
      this,
    );
  }
}

abstract class _PasswordUpdateDto implements PasswordUpdateDto {
  const factory _PasswordUpdateDto(
      {required final String currentPassword,
      required final String newPassword}) = _$PasswordUpdateDtoImpl;

  factory _PasswordUpdateDto.fromJson(Map<String, dynamic> json) =
      _$PasswordUpdateDtoImpl.fromJson;

  @override
  String get currentPassword;
  @override
  String get newPassword;

  /// Create a copy of PasswordUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordUpdateDtoImplCopyWith<_$PasswordUpdateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
