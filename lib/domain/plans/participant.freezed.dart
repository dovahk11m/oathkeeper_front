// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return _Participant.fromJson(json);
}

/// @nodoc
mixin _$Participant {
  int get id => throw _privateConstructorUsedError;
  int get memberId => throw _privateConstructorUsedError;
  String get memberNickname => throw _privateConstructorUsedError;
  String? get memberProfileImageUrl => throw _privateConstructorUsedError;
  String get participantStatus =>
      throw _privateConstructorUsedError; // PENDING, ACCEPTED, REJECTED
  String? get transportMethod =>
      throw _privateConstructorUsedError; // WALK, TRANSIT, DRIVE
  int? get expectedTravelTimeMinutes => throw _privateConstructorUsedError;
  DateTime? get expectedDepartureTime => throw _privateConstructorUsedError;
  DateTime? get actualDepartureTime => throw _privateConstructorUsedError;
  DateTime? get actualArrivalTime => throw _privateConstructorUsedError;
  String? get arrivalStatus =>
      throw _privateConstructorUsedError; // ON_TIME, LATE, ABSENT
  int? get timeBurdenMinutes => throw _privateConstructorUsedError;

  /// Serializes this Participant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantCopyWith<Participant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantCopyWith<$Res> {
  factory $ParticipantCopyWith(
          Participant value, $Res Function(Participant) then) =
      _$ParticipantCopyWithImpl<$Res, Participant>;
  @useResult
  $Res call(
      {int id,
      int memberId,
      String memberNickname,
      String? memberProfileImageUrl,
      String participantStatus,
      String? transportMethod,
      int? expectedTravelTimeMinutes,
      DateTime? expectedDepartureTime,
      DateTime? actualDepartureTime,
      DateTime? actualArrivalTime,
      String? arrivalStatus,
      int? timeBurdenMinutes});
}

/// @nodoc
class _$ParticipantCopyWithImpl<$Res, $Val extends Participant>
    implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberNickname = null,
    Object? memberProfileImageUrl = freezed,
    Object? participantStatus = null,
    Object? transportMethod = freezed,
    Object? expectedTravelTimeMinutes = freezed,
    Object? expectedDepartureTime = freezed,
    Object? actualDepartureTime = freezed,
    Object? actualArrivalTime = freezed,
    Object? arrivalStatus = freezed,
    Object? timeBurdenMinutes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      memberNickname: null == memberNickname
          ? _value.memberNickname
          : memberNickname // ignore: cast_nullable_to_non_nullable
              as String,
      memberProfileImageUrl: freezed == memberProfileImageUrl
          ? _value.memberProfileImageUrl
          : memberProfileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      participantStatus: null == participantStatus
          ? _value.participantStatus
          : participantStatus // ignore: cast_nullable_to_non_nullable
              as String,
      transportMethod: freezed == transportMethod
          ? _value.transportMethod
          : transportMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedTravelTimeMinutes: freezed == expectedTravelTimeMinutes
          ? _value.expectedTravelTimeMinutes
          : expectedTravelTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      expectedDepartureTime: freezed == expectedDepartureTime
          ? _value.expectedDepartureTime
          : expectedDepartureTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDepartureTime: freezed == actualDepartureTime
          ? _value.actualDepartureTime
          : actualDepartureTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualArrivalTime: freezed == actualArrivalTime
          ? _value.actualArrivalTime
          : actualArrivalTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalStatus: freezed == arrivalStatus
          ? _value.arrivalStatus
          : arrivalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      timeBurdenMinutes: freezed == timeBurdenMinutes
          ? _value.timeBurdenMinutes
          : timeBurdenMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipantImplCopyWith<$Res>
    implements $ParticipantCopyWith<$Res> {
  factory _$$ParticipantImplCopyWith(
          _$ParticipantImpl value, $Res Function(_$ParticipantImpl) then) =
      __$$ParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int memberId,
      String memberNickname,
      String? memberProfileImageUrl,
      String participantStatus,
      String? transportMethod,
      int? expectedTravelTimeMinutes,
      DateTime? expectedDepartureTime,
      DateTime? actualDepartureTime,
      DateTime? actualArrivalTime,
      String? arrivalStatus,
      int? timeBurdenMinutes});
}

/// @nodoc
class __$$ParticipantImplCopyWithImpl<$Res>
    extends _$ParticipantCopyWithImpl<$Res, _$ParticipantImpl>
    implements _$$ParticipantImplCopyWith<$Res> {
  __$$ParticipantImplCopyWithImpl(
      _$ParticipantImpl _value, $Res Function(_$ParticipantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberNickname = null,
    Object? memberProfileImageUrl = freezed,
    Object? participantStatus = null,
    Object? transportMethod = freezed,
    Object? expectedTravelTimeMinutes = freezed,
    Object? expectedDepartureTime = freezed,
    Object? actualDepartureTime = freezed,
    Object? actualArrivalTime = freezed,
    Object? arrivalStatus = freezed,
    Object? timeBurdenMinutes = freezed,
  }) {
    return _then(_$ParticipantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      memberNickname: null == memberNickname
          ? _value.memberNickname
          : memberNickname // ignore: cast_nullable_to_non_nullable
              as String,
      memberProfileImageUrl: freezed == memberProfileImageUrl
          ? _value.memberProfileImageUrl
          : memberProfileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      participantStatus: null == participantStatus
          ? _value.participantStatus
          : participantStatus // ignore: cast_nullable_to_non_nullable
              as String,
      transportMethod: freezed == transportMethod
          ? _value.transportMethod
          : transportMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedTravelTimeMinutes: freezed == expectedTravelTimeMinutes
          ? _value.expectedTravelTimeMinutes
          : expectedTravelTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      expectedDepartureTime: freezed == expectedDepartureTime
          ? _value.expectedDepartureTime
          : expectedDepartureTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualDepartureTime: freezed == actualDepartureTime
          ? _value.actualDepartureTime
          : actualDepartureTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualArrivalTime: freezed == actualArrivalTime
          ? _value.actualArrivalTime
          : actualArrivalTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalStatus: freezed == arrivalStatus
          ? _value.arrivalStatus
          : arrivalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      timeBurdenMinutes: freezed == timeBurdenMinutes
          ? _value.timeBurdenMinutes
          : timeBurdenMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantImpl implements _Participant {
  const _$ParticipantImpl(
      {required this.id,
      required this.memberId,
      required this.memberNickname,
      this.memberProfileImageUrl,
      required this.participantStatus,
      this.transportMethod,
      this.expectedTravelTimeMinutes,
      this.expectedDepartureTime,
      this.actualDepartureTime,
      this.actualArrivalTime,
      this.arrivalStatus,
      this.timeBurdenMinutes});

  factory _$ParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantImplFromJson(json);

  @override
  final int id;
  @override
  final int memberId;
  @override
  final String memberNickname;
  @override
  final String? memberProfileImageUrl;
  @override
  final String participantStatus;
// PENDING, ACCEPTED, REJECTED
  @override
  final String? transportMethod;
// WALK, TRANSIT, DRIVE
  @override
  final int? expectedTravelTimeMinutes;
  @override
  final DateTime? expectedDepartureTime;
  @override
  final DateTime? actualDepartureTime;
  @override
  final DateTime? actualArrivalTime;
  @override
  final String? arrivalStatus;
// ON_TIME, LATE, ABSENT
  @override
  final int? timeBurdenMinutes;

  @override
  String toString() {
    return 'Participant(id: $id, memberId: $memberId, memberNickname: $memberNickname, memberProfileImageUrl: $memberProfileImageUrl, participantStatus: $participantStatus, transportMethod: $transportMethod, expectedTravelTimeMinutes: $expectedTravelTimeMinutes, expectedDepartureTime: $expectedDepartureTime, actualDepartureTime: $actualDepartureTime, actualArrivalTime: $actualArrivalTime, arrivalStatus: $arrivalStatus, timeBurdenMinutes: $timeBurdenMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberNickname, memberNickname) ||
                other.memberNickname == memberNickname) &&
            (identical(other.memberProfileImageUrl, memberProfileImageUrl) ||
                other.memberProfileImageUrl == memberProfileImageUrl) &&
            (identical(other.participantStatus, participantStatus) ||
                other.participantStatus == participantStatus) &&
            (identical(other.transportMethod, transportMethod) ||
                other.transportMethod == transportMethod) &&
            (identical(other.expectedTravelTimeMinutes,
                    expectedTravelTimeMinutes) ||
                other.expectedTravelTimeMinutes == expectedTravelTimeMinutes) &&
            (identical(other.expectedDepartureTime, expectedDepartureTime) ||
                other.expectedDepartureTime == expectedDepartureTime) &&
            (identical(other.actualDepartureTime, actualDepartureTime) ||
                other.actualDepartureTime == actualDepartureTime) &&
            (identical(other.actualArrivalTime, actualArrivalTime) ||
                other.actualArrivalTime == actualArrivalTime) &&
            (identical(other.arrivalStatus, arrivalStatus) ||
                other.arrivalStatus == arrivalStatus) &&
            (identical(other.timeBurdenMinutes, timeBurdenMinutes) ||
                other.timeBurdenMinutes == timeBurdenMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      memberId,
      memberNickname,
      memberProfileImageUrl,
      participantStatus,
      transportMethod,
      expectedTravelTimeMinutes,
      expectedDepartureTime,
      actualDepartureTime,
      actualArrivalTime,
      arrivalStatus,
      timeBurdenMinutes);

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantImplCopyWith<_$ParticipantImpl> get copyWith =>
      __$$ParticipantImplCopyWithImpl<_$ParticipantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantImplToJson(
      this,
    );
  }
}

abstract class _Participant implements Participant {
  const factory _Participant(
      {required final int id,
      required final int memberId,
      required final String memberNickname,
      final String? memberProfileImageUrl,
      required final String participantStatus,
      final String? transportMethod,
      final int? expectedTravelTimeMinutes,
      final DateTime? expectedDepartureTime,
      final DateTime? actualDepartureTime,
      final DateTime? actualArrivalTime,
      final String? arrivalStatus,
      final int? timeBurdenMinutes}) = _$ParticipantImpl;

  factory _Participant.fromJson(Map<String, dynamic> json) =
      _$ParticipantImpl.fromJson;

  @override
  int get id;
  @override
  int get memberId;
  @override
  String get memberNickname;
  @override
  String? get memberProfileImageUrl;
  @override
  String get participantStatus; // PENDING, ACCEPTED, REJECTED
  @override
  String? get transportMethod; // WALK, TRANSIT, DRIVE
  @override
  int? get expectedTravelTimeMinutes;
  @override
  DateTime? get expectedDepartureTime;
  @override
  DateTime? get actualDepartureTime;
  @override
  DateTime? get actualArrivalTime;
  @override
  String? get arrivalStatus; // ON_TIME, LATE, ABSENT
  @override
  int? get timeBurdenMinutes;

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantImplCopyWith<_$ParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
