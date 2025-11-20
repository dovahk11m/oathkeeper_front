// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return _Plan.fromJson(json);
}

/// @nodoc
mixin _$Plan {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get planDatetime => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // PLANNING, CONFIRMED, COMPLETED
  String? get location => throw _privateConstructorUsedError;
  double? get placeLatitude => throw _privateConstructorUsedError;
  double? get placeLongitude => throw _privateConstructorUsedError;
  int? get lateFineAmount => throw _privateConstructorUsedError;
  CreatorMember get creatorMember => throw _privateConstructorUsedError;
  List<Participant> get participants => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this Plan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanCopyWith<Plan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanCopyWith<$Res> {
  factory $PlanCopyWith(Plan value, $Res Function(Plan) then) =
      _$PlanCopyWithImpl<$Res, Plan>;
  @useResult
  $Res call(
      {int id,
      String title,
      DateTime planDatetime,
      String status,
      String? location,
      double? placeLatitude,
      double? placeLongitude,
      int? lateFineAmount,
      CreatorMember creatorMember,
      List<Participant> participants,
      List<String> tags,
      DateTime? completedAt});

  $CreatorMemberCopyWith<$Res> get creatorMember;
}

/// @nodoc
class _$PlanCopyWithImpl<$Res, $Val extends Plan>
    implements $PlanCopyWith<$Res> {
  _$PlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? planDatetime = null,
    Object? status = null,
    Object? location = freezed,
    Object? placeLatitude = freezed,
    Object? placeLongitude = freezed,
    Object? lateFineAmount = freezed,
    Object? creatorMember = null,
    Object? participants = null,
    Object? tags = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      planDatetime: null == planDatetime
          ? _value.planDatetime
          : planDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      placeLatitude: freezed == placeLatitude
          ? _value.placeLatitude
          : placeLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      placeLongitude: freezed == placeLongitude
          ? _value.placeLongitude
          : placeLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lateFineAmount: freezed == lateFineAmount
          ? _value.lateFineAmount
          : lateFineAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      creatorMember: null == creatorMember
          ? _value.creatorMember
          : creatorMember // ignore: cast_nullable_to_non_nullable
              as CreatorMember,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<Participant>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatorMemberCopyWith<$Res> get creatorMember {
    return $CreatorMemberCopyWith<$Res>(_value.creatorMember, (value) {
      return _then(_value.copyWith(creatorMember: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlanImplCopyWith<$Res> implements $PlanCopyWith<$Res> {
  factory _$$PlanImplCopyWith(
          _$PlanImpl value, $Res Function(_$PlanImpl) then) =
      __$$PlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      DateTime planDatetime,
      String status,
      String? location,
      double? placeLatitude,
      double? placeLongitude,
      int? lateFineAmount,
      CreatorMember creatorMember,
      List<Participant> participants,
      List<String> tags,
      DateTime? completedAt});

  @override
  $CreatorMemberCopyWith<$Res> get creatorMember;
}

/// @nodoc
class __$$PlanImplCopyWithImpl<$Res>
    extends _$PlanCopyWithImpl<$Res, _$PlanImpl>
    implements _$$PlanImplCopyWith<$Res> {
  __$$PlanImplCopyWithImpl(_$PlanImpl _value, $Res Function(_$PlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? planDatetime = null,
    Object? status = null,
    Object? location = freezed,
    Object? placeLatitude = freezed,
    Object? placeLongitude = freezed,
    Object? lateFineAmount = freezed,
    Object? creatorMember = null,
    Object? participants = null,
    Object? tags = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$PlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      planDatetime: null == planDatetime
          ? _value.planDatetime
          : planDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      placeLatitude: freezed == placeLatitude
          ? _value.placeLatitude
          : placeLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      placeLongitude: freezed == placeLongitude
          ? _value.placeLongitude
          : placeLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lateFineAmount: freezed == lateFineAmount
          ? _value.lateFineAmount
          : lateFineAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      creatorMember: null == creatorMember
          ? _value.creatorMember
          : creatorMember // ignore: cast_nullable_to_non_nullable
              as CreatorMember,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<Participant>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanImpl implements _Plan {
  const _$PlanImpl(
      {required this.id,
      required this.title,
      required this.planDatetime,
      required this.status,
      this.location,
      this.placeLatitude,
      this.placeLongitude,
      this.lateFineAmount,
      required this.creatorMember,
      final List<Participant> participants = const [],
      final List<String> tags = const [],
      this.completedAt})
      : _participants = participants,
        _tags = tags;

  factory _$PlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final DateTime planDatetime;
  @override
  final String status;
// PLANNING, CONFIRMED, COMPLETED
  @override
  final String? location;
  @override
  final double? placeLatitude;
  @override
  final double? placeLongitude;
  @override
  final int? lateFineAmount;
  @override
  final CreatorMember creatorMember;
  final List<Participant> _participants;
  @override
  @JsonKey()
  List<Participant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'Plan(id: $id, title: $title, planDatetime: $planDatetime, status: $status, location: $location, placeLatitude: $placeLatitude, placeLongitude: $placeLongitude, lateFineAmount: $lateFineAmount, creatorMember: $creatorMember, participants: $participants, tags: $tags, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.planDatetime, planDatetime) ||
                other.planDatetime == planDatetime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.placeLatitude, placeLatitude) ||
                other.placeLatitude == placeLatitude) &&
            (identical(other.placeLongitude, placeLongitude) ||
                other.placeLongitude == placeLongitude) &&
            (identical(other.lateFineAmount, lateFineAmount) ||
                other.lateFineAmount == lateFineAmount) &&
            (identical(other.creatorMember, creatorMember) ||
                other.creatorMember == creatorMember) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      planDatetime,
      status,
      location,
      placeLatitude,
      placeLongitude,
      lateFineAmount,
      creatorMember,
      const DeepCollectionEquality().hash(_participants),
      const DeepCollectionEquality().hash(_tags),
      completedAt);

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      __$$PlanImplCopyWithImpl<_$PlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanImplToJson(
      this,
    );
  }
}

abstract class _Plan implements Plan {
  const factory _Plan(
      {required final int id,
      required final String title,
      required final DateTime planDatetime,
      required final String status,
      final String? location,
      final double? placeLatitude,
      final double? placeLongitude,
      final int? lateFineAmount,
      required final CreatorMember creatorMember,
      final List<Participant> participants,
      final List<String> tags,
      final DateTime? completedAt}) = _$PlanImpl;

  factory _Plan.fromJson(Map<String, dynamic> json) = _$PlanImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  DateTime get planDatetime;
  @override
  String get status; // PLANNING, CONFIRMED, COMPLETED
  @override
  String? get location;
  @override
  double? get placeLatitude;
  @override
  double? get placeLongitude;
  @override
  int? get lateFineAmount;
  @override
  CreatorMember get creatorMember;
  @override
  List<Participant> get participants;
  @override
  List<String> get tags;
  @override
  DateTime? get completedAt;

  /// Create a copy of Plan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanImplCopyWith<_$PlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatorMember _$CreatorMemberFromJson(Map<String, dynamic> json) {
  return _CreatorMember.fromJson(json);
}

/// @nodoc
mixin _$CreatorMember {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Serializes this CreatorMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatorMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatorMemberCopyWith<CreatorMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatorMemberCopyWith<$Res> {
  factory $CreatorMemberCopyWith(
          CreatorMember value, $Res Function(CreatorMember) then) =
      _$CreatorMemberCopyWithImpl<$Res, CreatorMember>;
  @useResult
  $Res call({int id, String email, String nickname, String? profileImageUrl});
}

/// @nodoc
class _$CreatorMemberCopyWithImpl<$Res, $Val extends CreatorMember>
    implements $CreatorMemberCopyWith<$Res> {
  _$CreatorMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatorMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatorMemberImplCopyWith<$Res>
    implements $CreatorMemberCopyWith<$Res> {
  factory _$$CreatorMemberImplCopyWith(
          _$CreatorMemberImpl value, $Res Function(_$CreatorMemberImpl) then) =
      __$$CreatorMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String email, String nickname, String? profileImageUrl});
}

/// @nodoc
class __$$CreatorMemberImplCopyWithImpl<$Res>
    extends _$CreatorMemberCopyWithImpl<$Res, _$CreatorMemberImpl>
    implements _$$CreatorMemberImplCopyWith<$Res> {
  __$$CreatorMemberImplCopyWithImpl(
      _$CreatorMemberImpl _value, $Res Function(_$CreatorMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatorMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_$CreatorMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatorMemberImpl implements _CreatorMember {
  const _$CreatorMemberImpl(
      {required this.id,
      required this.email,
      required this.nickname,
      this.profileImageUrl});

  factory _$CreatorMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatorMemberImplFromJson(json);

  @override
  final int id;
  @override
  final String email;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;

  @override
  String toString() {
    return 'CreatorMember(id: $id, email: $email, nickname: $nickname, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatorMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, email, nickname, profileImageUrl);

  /// Create a copy of CreatorMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatorMemberImplCopyWith<_$CreatorMemberImpl> get copyWith =>
      __$$CreatorMemberImplCopyWithImpl<_$CreatorMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatorMemberImplToJson(
      this,
    );
  }
}

abstract class _CreatorMember implements CreatorMember {
  const factory _CreatorMember(
      {required final int id,
      required final String email,
      required final String nickname,
      final String? profileImageUrl}) = _$CreatorMemberImpl;

  factory _CreatorMember.fromJson(Map<String, dynamic> json) =
      _$CreatorMemberImpl.fromJson;

  @override
  int get id;
  @override
  String get email;
  @override
  String get nickname;
  @override
  String? get profileImageUrl;

  /// Create a copy of CreatorMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatorMemberImplCopyWith<_$CreatorMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
