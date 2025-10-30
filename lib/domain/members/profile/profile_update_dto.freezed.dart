// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileUpdateDto _$ProfileUpdateDtoFromJson(Map<String, dynamic> json) {
  return _ProfileUpdateDto.fromJson(json);
}

/// @nodoc
mixin _$ProfileUpdateDto {
  String get username => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get defaultAddress => throw _privateConstructorUsedError;

  /// Serializes this ProfileUpdateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileUpdateDtoCopyWith<ProfileUpdateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUpdateDtoCopyWith<$Res> {
  factory $ProfileUpdateDtoCopyWith(
          ProfileUpdateDto value, $Res Function(ProfileUpdateDto) then) =
      _$ProfileUpdateDtoCopyWithImpl<$Res, ProfileUpdateDto>;
  @useResult
  $Res call({String username, String? profileImageUrl, String? defaultAddress});
}

/// @nodoc
class _$ProfileUpdateDtoCopyWithImpl<$Res, $Val extends ProfileUpdateDto>
    implements $ProfileUpdateDtoCopyWith<$Res> {
  _$ProfileUpdateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? profileImageUrl = freezed,
    Object? defaultAddress = freezed,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultAddress: freezed == defaultAddress
          ? _value.defaultAddress
          : defaultAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileUpdateDtoImplCopyWith<$Res>
    implements $ProfileUpdateDtoCopyWith<$Res> {
  factory _$$ProfileUpdateDtoImplCopyWith(_$ProfileUpdateDtoImpl value,
          $Res Function(_$ProfileUpdateDtoImpl) then) =
      __$$ProfileUpdateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String? profileImageUrl, String? defaultAddress});
}

/// @nodoc
class __$$ProfileUpdateDtoImplCopyWithImpl<$Res>
    extends _$ProfileUpdateDtoCopyWithImpl<$Res, _$ProfileUpdateDtoImpl>
    implements _$$ProfileUpdateDtoImplCopyWith<$Res> {
  __$$ProfileUpdateDtoImplCopyWithImpl(_$ProfileUpdateDtoImpl _value,
      $Res Function(_$ProfileUpdateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? profileImageUrl = freezed,
    Object? defaultAddress = freezed,
  }) {
    return _then(_$ProfileUpdateDtoImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultAddress: freezed == defaultAddress
          ? _value.defaultAddress
          : defaultAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileUpdateDtoImpl implements _ProfileUpdateDto {
  const _$ProfileUpdateDtoImpl(
      {required this.username, this.profileImageUrl, this.defaultAddress});

  factory _$ProfileUpdateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileUpdateDtoImplFromJson(json);

  @override
  final String username;
  @override
  final String? profileImageUrl;
  @override
  final String? defaultAddress;

  @override
  String toString() {
    return 'ProfileUpdateDto(username: $username, profileImageUrl: $profileImageUrl, defaultAddress: $defaultAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileUpdateDtoImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.defaultAddress, defaultAddress) ||
                other.defaultAddress == defaultAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, username, profileImageUrl, defaultAddress);

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileUpdateDtoImplCopyWith<_$ProfileUpdateDtoImpl> get copyWith =>
      __$$ProfileUpdateDtoImplCopyWithImpl<_$ProfileUpdateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileUpdateDtoImplToJson(
      this,
    );
  }
}

abstract class _ProfileUpdateDto implements ProfileUpdateDto {
  const factory _ProfileUpdateDto(
      {required final String username,
      final String? profileImageUrl,
      final String? defaultAddress}) = _$ProfileUpdateDtoImpl;

  factory _ProfileUpdateDto.fromJson(Map<String, dynamic> json) =
      _$ProfileUpdateDtoImpl.fromJson;

  @override
  String get username;
  @override
  String? get profileImageUrl;
  @override
  String? get defaultAddress;

  /// Create a copy of ProfileUpdateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileUpdateDtoImplCopyWith<_$ProfileUpdateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
