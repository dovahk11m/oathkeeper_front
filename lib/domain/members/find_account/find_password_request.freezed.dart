// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'find_password_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FindPasswordRequest _$FindPasswordRequestFromJson(Map<String, dynamic> json) {
  return _FindPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$FindPasswordRequest {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this FindPasswordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FindPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FindPasswordRequestCopyWith<FindPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FindPasswordRequestCopyWith<$Res> {
  factory $FindPasswordRequestCopyWith(
          FindPasswordRequest value, $Res Function(FindPasswordRequest) then) =
      _$FindPasswordRequestCopyWithImpl<$Res, FindPasswordRequest>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$FindPasswordRequestCopyWithImpl<$Res, $Val extends FindPasswordRequest>
    implements $FindPasswordRequestCopyWith<$Res> {
  _$FindPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FindPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FindPasswordRequestImplCopyWith<$Res>
    implements $FindPasswordRequestCopyWith<$Res> {
  factory _$$FindPasswordRequestImplCopyWith(_$FindPasswordRequestImpl value,
          $Res Function(_$FindPasswordRequestImpl) then) =
      __$$FindPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$FindPasswordRequestImplCopyWithImpl<$Res>
    extends _$FindPasswordRequestCopyWithImpl<$Res, _$FindPasswordRequestImpl>
    implements _$$FindPasswordRequestImplCopyWith<$Res> {
  __$$FindPasswordRequestImplCopyWithImpl(_$FindPasswordRequestImpl _value,
      $Res Function(_$FindPasswordRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of FindPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$FindPasswordRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FindPasswordRequestImpl implements _FindPasswordRequest {
  const _$FindPasswordRequestImpl({required this.email});

  factory _$FindPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FindPasswordRequestImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'FindPasswordRequest(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FindPasswordRequestImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of FindPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FindPasswordRequestImplCopyWith<_$FindPasswordRequestImpl> get copyWith =>
      __$$FindPasswordRequestImplCopyWithImpl<_$FindPasswordRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FindPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _FindPasswordRequest implements FindPasswordRequest {
  const factory _FindPasswordRequest({required final String email}) =
      _$FindPasswordRequestImpl;

  factory _FindPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$FindPasswordRequestImpl.fromJson;

  @override
  String get email;

  /// Create a copy of FindPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FindPasswordRequestImplCopyWith<_$FindPasswordRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
