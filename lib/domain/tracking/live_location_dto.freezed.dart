// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_location_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LiveLocationDto _$LiveLocationDtoFromJson(Map<String, dynamic> json) {
  return _LiveLocationDto.fromJson(json);
}

/// @nodoc
mixin _$LiveLocationDto {
  int get memberId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String get lastLiveTs => throw _privateConstructorUsedError;

  /// Serializes this LiveLocationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LiveLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LiveLocationDtoCopyWith<LiveLocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveLocationDtoCopyWith<$Res> {
  factory $LiveLocationDtoCopyWith(
          LiveLocationDto value, $Res Function(LiveLocationDto) then) =
      _$LiveLocationDtoCopyWithImpl<$Res, LiveLocationDto>;
  @useResult
  $Res call(
      {int memberId,
      String username,
      String? profileImageUrl,
      double lat,
      double lng,
      String lastLiveTs});
}

/// @nodoc
class _$LiveLocationDtoCopyWithImpl<$Res, $Val extends LiveLocationDto>
    implements $LiveLocationDtoCopyWith<$Res> {
  _$LiveLocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LiveLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? username = null,
    Object? profileImageUrl = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? lastLiveTs = null,
  }) {
    return _then(_value.copyWith(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      lastLiveTs: null == lastLiveTs
          ? _value.lastLiveTs
          : lastLiveTs // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiveLocationDtoImplCopyWith<$Res>
    implements $LiveLocationDtoCopyWith<$Res> {
  factory _$$LiveLocationDtoImplCopyWith(_$LiveLocationDtoImpl value,
          $Res Function(_$LiveLocationDtoImpl) then) =
      __$$LiveLocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int memberId,
      String username,
      String? profileImageUrl,
      double lat,
      double lng,
      String lastLiveTs});
}

/// @nodoc
class __$$LiveLocationDtoImplCopyWithImpl<$Res>
    extends _$LiveLocationDtoCopyWithImpl<$Res, _$LiveLocationDtoImpl>
    implements _$$LiveLocationDtoImplCopyWith<$Res> {
  __$$LiveLocationDtoImplCopyWithImpl(
      _$LiveLocationDtoImpl _value, $Res Function(_$LiveLocationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LiveLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? username = null,
    Object? profileImageUrl = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? lastLiveTs = null,
  }) {
    return _then(_$LiveLocationDtoImpl(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      lastLiveTs: null == lastLiveTs
          ? _value.lastLiveTs
          : lastLiveTs // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LiveLocationDtoImpl implements _LiveLocationDto {
  const _$LiveLocationDtoImpl(
      {required this.memberId,
      required this.username,
      this.profileImageUrl,
      required this.lat,
      required this.lng,
      required this.lastLiveTs});

  factory _$LiveLocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiveLocationDtoImplFromJson(json);

  @override
  final int memberId;
  @override
  final String username;
  @override
  final String? profileImageUrl;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String lastLiveTs;

  @override
  String toString() {
    return 'LiveLocationDto(memberId: $memberId, username: $username, profileImageUrl: $profileImageUrl, lat: $lat, lng: $lng, lastLiveTs: $lastLiveTs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveLocationDtoImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.lastLiveTs, lastLiveTs) ||
                other.lastLiveTs == lastLiveTs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, memberId, username, profileImageUrl, lat, lng, lastLiveTs);

  /// Create a copy of LiveLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveLocationDtoImplCopyWith<_$LiveLocationDtoImpl> get copyWith =>
      __$$LiveLocationDtoImplCopyWithImpl<_$LiveLocationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiveLocationDtoImplToJson(
      this,
    );
  }
}

abstract class _LiveLocationDto implements LiveLocationDto {
  const factory _LiveLocationDto(
      {required final int memberId,
      required final String username,
      final String? profileImageUrl,
      required final double lat,
      required final double lng,
      required final String lastLiveTs}) = _$LiveLocationDtoImpl;

  factory _LiveLocationDto.fromJson(Map<String, dynamic> json) =
      _$LiveLocationDtoImpl.fromJson;

  @override
  int get memberId;
  @override
  String get username;
  @override
  String? get profileImageUrl;
  @override
  double get lat;
  @override
  double get lng;
  @override
  String get lastLiveTs;

  /// Create a copy of LiveLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LiveLocationDtoImplCopyWith<_$LiveLocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
