// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommend_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendPlace _$RecommendPlaceFromJson(Map<String, dynamic> json) {
  return _RecommendPlace.fromJson(json);
}

/// @nodoc
mixin _$RecommendPlace {
  List<RecommendPlaceState> get centerAvgPlace =>
      throw _privateConstructorUsedError;
  List<RecommendPlaceState> get equalAvgPlace =>
      throw _privateConstructorUsedError;

  /// Serializes this RecommendPlace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendPlaceCopyWith<RecommendPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendPlaceCopyWith<$Res> {
  factory $RecommendPlaceCopyWith(
          RecommendPlace value, $Res Function(RecommendPlace) then) =
      _$RecommendPlaceCopyWithImpl<$Res, RecommendPlace>;
  @useResult
  $Res call(
      {List<RecommendPlaceState> centerAvgPlace,
      List<RecommendPlaceState> equalAvgPlace});
}

/// @nodoc
class _$RecommendPlaceCopyWithImpl<$Res, $Val extends RecommendPlace>
    implements $RecommendPlaceCopyWith<$Res> {
  _$RecommendPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? centerAvgPlace = null,
    Object? equalAvgPlace = null,
  }) {
    return _then(_value.copyWith(
      centerAvgPlace: null == centerAvgPlace
          ? _value.centerAvgPlace
          : centerAvgPlace // ignore: cast_nullable_to_non_nullable
              as List<RecommendPlaceState>,
      equalAvgPlace: null == equalAvgPlace
          ? _value.equalAvgPlace
          : equalAvgPlace // ignore: cast_nullable_to_non_nullable
              as List<RecommendPlaceState>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendPlaceImplCopyWith<$Res>
    implements $RecommendPlaceCopyWith<$Res> {
  factory _$$RecommendPlaceImplCopyWith(_$RecommendPlaceImpl value,
          $Res Function(_$RecommendPlaceImpl) then) =
      __$$RecommendPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RecommendPlaceState> centerAvgPlace,
      List<RecommendPlaceState> equalAvgPlace});
}

/// @nodoc
class __$$RecommendPlaceImplCopyWithImpl<$Res>
    extends _$RecommendPlaceCopyWithImpl<$Res, _$RecommendPlaceImpl>
    implements _$$RecommendPlaceImplCopyWith<$Res> {
  __$$RecommendPlaceImplCopyWithImpl(
      _$RecommendPlaceImpl _value, $Res Function(_$RecommendPlaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? centerAvgPlace = null,
    Object? equalAvgPlace = null,
  }) {
    return _then(_$RecommendPlaceImpl(
      centerAvgPlace: null == centerAvgPlace
          ? _value._centerAvgPlace
          : centerAvgPlace // ignore: cast_nullable_to_non_nullable
              as List<RecommendPlaceState>,
      equalAvgPlace: null == equalAvgPlace
          ? _value._equalAvgPlace
          : equalAvgPlace // ignore: cast_nullable_to_non_nullable
              as List<RecommendPlaceState>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendPlaceImpl implements _RecommendPlace {
  const _$RecommendPlaceImpl(
      {required final List<RecommendPlaceState> centerAvgPlace,
      required final List<RecommendPlaceState> equalAvgPlace})
      : _centerAvgPlace = centerAvgPlace,
        _equalAvgPlace = equalAvgPlace;

  factory _$RecommendPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendPlaceImplFromJson(json);

  final List<RecommendPlaceState> _centerAvgPlace;
  @override
  List<RecommendPlaceState> get centerAvgPlace {
    if (_centerAvgPlace is EqualUnmodifiableListView) return _centerAvgPlace;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_centerAvgPlace);
  }

  final List<RecommendPlaceState> _equalAvgPlace;
  @override
  List<RecommendPlaceState> get equalAvgPlace {
    if (_equalAvgPlace is EqualUnmodifiableListView) return _equalAvgPlace;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equalAvgPlace);
  }

  @override
  String toString() {
    return 'RecommendPlace(centerAvgPlace: $centerAvgPlace, equalAvgPlace: $equalAvgPlace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendPlaceImpl &&
            const DeepCollectionEquality()
                .equals(other._centerAvgPlace, _centerAvgPlace) &&
            const DeepCollectionEquality()
                .equals(other._equalAvgPlace, _equalAvgPlace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_centerAvgPlace),
      const DeepCollectionEquality().hash(_equalAvgPlace));

  /// Create a copy of RecommendPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendPlaceImplCopyWith<_$RecommendPlaceImpl> get copyWith =>
      __$$RecommendPlaceImplCopyWithImpl<_$RecommendPlaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendPlaceImplToJson(
      this,
    );
  }
}

abstract class _RecommendPlace implements RecommendPlace {
  const factory _RecommendPlace(
          {required final List<RecommendPlaceState> centerAvgPlace,
          required final List<RecommendPlaceState> equalAvgPlace}) =
      _$RecommendPlaceImpl;

  factory _RecommendPlace.fromJson(Map<String, dynamic> json) =
      _$RecommendPlaceImpl.fromJson;

  @override
  List<RecommendPlaceState> get centerAvgPlace;
  @override
  List<RecommendPlaceState> get equalAvgPlace;

  /// Create a copy of RecommendPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendPlaceImplCopyWith<_$RecommendPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendPlaceState _$RecommendPlaceStateFromJson(Map<String, dynamic> json) {
  return _RecommendPlaceState.fromJson(json);
}

/// @nodoc
mixin _$RecommendPlaceState {
  Participant get participant => throw _privateConstructorUsedError;
  Place get destination => throw _privateConstructorUsedError;
  int get distance => throw _privateConstructorUsedError;
  String get duration => throw _privateConstructorUsedError;

  /// Serializes this RecommendPlaceState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendPlaceStateCopyWith<RecommendPlaceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendPlaceStateCopyWith<$Res> {
  factory $RecommendPlaceStateCopyWith(
          RecommendPlaceState value, $Res Function(RecommendPlaceState) then) =
      _$RecommendPlaceStateCopyWithImpl<$Res, RecommendPlaceState>;
  @useResult
  $Res call(
      {Participant participant,
      Place destination,
      int distance,
      String duration});

  $ParticipantCopyWith<$Res> get participant;
  $PlaceCopyWith<$Res> get destination;
}

/// @nodoc
class _$RecommendPlaceStateCopyWithImpl<$Res, $Val extends RecommendPlaceState>
    implements $RecommendPlaceStateCopyWith<$Res> {
  _$RecommendPlaceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participant = null,
    Object? destination = null,
    Object? distance = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      participant: null == participant
          ? _value.participant
          : participant // ignore: cast_nullable_to_non_nullable
              as Participant,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Place,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipantCopyWith<$Res> get participant {
    return $ParticipantCopyWith<$Res>(_value.participant, (value) {
      return _then(_value.copyWith(participant: value) as $Val);
    });
  }

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlaceCopyWith<$Res> get destination {
    return $PlaceCopyWith<$Res>(_value.destination, (value) {
      return _then(_value.copyWith(destination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendPlaceStateImplCopyWith<$Res>
    implements $RecommendPlaceStateCopyWith<$Res> {
  factory _$$RecommendPlaceStateImplCopyWith(_$RecommendPlaceStateImpl value,
          $Res Function(_$RecommendPlaceStateImpl) then) =
      __$$RecommendPlaceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Participant participant,
      Place destination,
      int distance,
      String duration});

  @override
  $ParticipantCopyWith<$Res> get participant;
  @override
  $PlaceCopyWith<$Res> get destination;
}

/// @nodoc
class __$$RecommendPlaceStateImplCopyWithImpl<$Res>
    extends _$RecommendPlaceStateCopyWithImpl<$Res, _$RecommendPlaceStateImpl>
    implements _$$RecommendPlaceStateImplCopyWith<$Res> {
  __$$RecommendPlaceStateImplCopyWithImpl(_$RecommendPlaceStateImpl _value,
      $Res Function(_$RecommendPlaceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participant = null,
    Object? destination = null,
    Object? distance = null,
    Object? duration = null,
  }) {
    return _then(_$RecommendPlaceStateImpl(
      participant: null == participant
          ? _value.participant
          : participant // ignore: cast_nullable_to_non_nullable
              as Participant,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as Place,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendPlaceStateImpl implements _RecommendPlaceState {
  const _$RecommendPlaceStateImpl(
      {required this.participant,
      required this.destination,
      required this.distance,
      required this.duration});

  factory _$RecommendPlaceStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendPlaceStateImplFromJson(json);

  @override
  final Participant participant;
  @override
  final Place destination;
  @override
  final int distance;
  @override
  final String duration;

  @override
  String toString() {
    return 'RecommendPlaceState(participant: $participant, destination: $destination, distance: $distance, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendPlaceStateImpl &&
            (identical(other.participant, participant) ||
                other.participant == participant) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, participant, destination, distance, duration);

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendPlaceStateImplCopyWith<_$RecommendPlaceStateImpl> get copyWith =>
      __$$RecommendPlaceStateImplCopyWithImpl<_$RecommendPlaceStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendPlaceStateImplToJson(
      this,
    );
  }
}

abstract class _RecommendPlaceState implements RecommendPlaceState {
  const factory _RecommendPlaceState(
      {required final Participant participant,
      required final Place destination,
      required final int distance,
      required final String duration}) = _$RecommendPlaceStateImpl;

  factory _RecommendPlaceState.fromJson(Map<String, dynamic> json) =
      _$RecommendPlaceStateImpl.fromJson;

  @override
  Participant get participant;
  @override
  Place get destination;
  @override
  int get distance;
  @override
  String get duration;

  /// Create a copy of RecommendPlaceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendPlaceStateImplCopyWith<_$RecommendPlaceStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
