// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  int get id => throw _privateConstructorUsedError;
  int get planId => throw _privateConstructorUsedError;
  String get planTitle => throw _privateConstructorUsedError;
  String? get placeName => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<Reply> get replies => throw _privateConstructorUsedError;
  int get replyCount => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call(
      {int id,
      int planId,
      String planTitle,
      String? placeName,
      double? latitude,
      double? longitude,
      int authorId,
      String authorName,
      String title,
      String content,
      DateTime createdAt,
      DateTime? updatedAt,
      List<Reply> replies,
      int replyCount});
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? planTitle = null,
    Object? placeName = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? authorId = null,
    Object? authorName = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? replies = null,
    Object? replyCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as int,
      planTitle: null == planTitle
          ? _value.planTitle
          : planTitle // ignore: cast_nullable_to_non_nullable
              as String,
      placeName: freezed == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Reply>,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
          _$ReviewImpl value, $Res Function(_$ReviewImpl) then) =
      __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int planId,
      String planTitle,
      String? placeName,
      double? latitude,
      double? longitude,
      int authorId,
      String authorName,
      String title,
      String content,
      DateTime createdAt,
      DateTime? updatedAt,
      List<Reply> replies,
      int replyCount});
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
      _$ReviewImpl _value, $Res Function(_$ReviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? planTitle = null,
    Object? placeName = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? authorId = null,
    Object? authorName = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? replies = null,
    Object? replyCount = null,
  }) {
    return _then(_$ReviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as int,
      planTitle: null == planTitle
          ? _value.planTitle
          : planTitle // ignore: cast_nullable_to_non_nullable
              as String,
      placeName: freezed == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Reply>,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl(
      {required this.id,
      required this.planId,
      required this.planTitle,
      this.placeName,
      this.latitude,
      this.longitude,
      required this.authorId,
      required this.authorName,
      required this.title,
      required this.content,
      required this.createdAt,
      this.updatedAt,
      final List<Reply> replies = const [],
      this.replyCount = 0})
      : _replies = replies;

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final int id;
  @override
  final int planId;
  @override
  final String planTitle;
  @override
  final String? placeName;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final int authorId;
  @override
  final String authorName;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<Reply> _replies;
  @override
  @JsonKey()
  List<Reply> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  @JsonKey()
  final int replyCount;

  @override
  String toString() {
    return 'Review(id: $id, planId: $planId, planTitle: $planTitle, placeName: $placeName, latitude: $latitude, longitude: $longitude, authorId: $authorId, authorName: $authorName, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, replies: $replies, replyCount: $replyCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.planTitle, planTitle) ||
                other.planTitle == planTitle) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      planId,
      planTitle,
      placeName,
      latitude,
      longitude,
      authorId,
      authorName,
      title,
      content,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_replies),
      replyCount);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(
      this,
    );
  }
}

abstract class _Review implements Review {
  const factory _Review(
      {required final int id,
      required final int planId,
      required final String planTitle,
      final String? placeName,
      final double? latitude,
      final double? longitude,
      required final int authorId,
      required final String authorName,
      required final String title,
      required final String content,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final List<Reply> replies,
      final int replyCount}) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  int get id;
  @override
  int get planId;
  @override
  String get planTitle;
  @override
  String? get placeName;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  int get authorId;
  @override
  String get authorName;
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<Reply> get replies;
  @override
  int get replyCount;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return _Reply.fromJson(json);
}

/// @nodoc
mixin _$Reply {
  int get id => throw _privateConstructorUsedError;
  int? get reviewId => throw _privateConstructorUsedError;
  int get authorId => throw _privateConstructorUsedError;
  String? get authorName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Reply to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReplyCopyWith<Reply> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyCopyWith<$Res> {
  factory $ReplyCopyWith(Reply value, $Res Function(Reply) then) =
      _$ReplyCopyWithImpl<$Res, Reply>;
  @useResult
  $Res call(
      {int id,
      int? reviewId,
      int authorId,
      String? authorName,
      String content,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ReplyCopyWithImpl<$Res, $Val extends Reply>
    implements $ReplyCopyWith<$Res> {
  _$ReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewId = freezed,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reviewId: freezed == reviewId
          ? _value.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as int?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReplyImplCopyWith<$Res> implements $ReplyCopyWith<$Res> {
  factory _$$ReplyImplCopyWith(
          _$ReplyImpl value, $Res Function(_$ReplyImpl) then) =
      __$$ReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int? reviewId,
      int authorId,
      String? authorName,
      String content,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ReplyImplCopyWithImpl<$Res>
    extends _$ReplyCopyWithImpl<$Res, _$ReplyImpl>
    implements _$$ReplyImplCopyWith<$Res> {
  __$$ReplyImplCopyWithImpl(
      _$ReplyImpl _value, $Res Function(_$ReplyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewId = freezed,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ReplyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reviewId: freezed == reviewId
          ? _value.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as int?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReplyImpl implements _Reply {
  const _$ReplyImpl(
      {required this.id,
      this.reviewId,
      required this.authorId,
      this.authorName,
      required this.content,
      required this.createdAt,
      required this.updatedAt});

  factory _$ReplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplyImplFromJson(json);

  @override
  final int id;
  @override
  final int? reviewId;
  @override
  final int authorId;
  @override
  final String? authorName;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Reply(id: $id, reviewId: $reviewId, authorId: $authorId, authorName: $authorName, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, reviewId, authorId,
      authorName, content, createdAt, updatedAt);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      __$$ReplyImplCopyWithImpl<_$ReplyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReplyImplToJson(
      this,
    );
  }
}

abstract class _Reply implements Reply {
  const factory _Reply(
      {required final int id,
      final int? reviewId,
      required final int authorId,
      final String? authorName,
      required final String content,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ReplyImpl;

  factory _Reply.fromJson(Map<String, dynamic> json) = _$ReplyImpl.fromJson;

  @override
  int get id;
  @override
  int? get reviewId;
  @override
  int get authorId;
  @override
  String? get authorName;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateReviewRequest _$CreateReviewRequestFromJson(Map<String, dynamic> json) {
  return _CreateReviewRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReviewRequest {
  int get planId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this CreateReviewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReviewRequestCopyWith<CreateReviewRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReviewRequestCopyWith<$Res> {
  factory $CreateReviewRequestCopyWith(
          CreateReviewRequest value, $Res Function(CreateReviewRequest) then) =
      _$CreateReviewRequestCopyWithImpl<$Res, CreateReviewRequest>;
  @useResult
  $Res call({int planId, String title, String content});
}

/// @nodoc
class _$CreateReviewRequestCopyWithImpl<$Res, $Val extends CreateReviewRequest>
    implements $CreateReviewRequestCopyWith<$Res> {
  _$CreateReviewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? title = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReviewRequestImplCopyWith<$Res>
    implements $CreateReviewRequestCopyWith<$Res> {
  factory _$$CreateReviewRequestImplCopyWith(_$CreateReviewRequestImpl value,
          $Res Function(_$CreateReviewRequestImpl) then) =
      __$$CreateReviewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int planId, String title, String content});
}

/// @nodoc
class __$$CreateReviewRequestImplCopyWithImpl<$Res>
    extends _$CreateReviewRequestCopyWithImpl<$Res, _$CreateReviewRequestImpl>
    implements _$$CreateReviewRequestImplCopyWith<$Res> {
  __$$CreateReviewRequestImplCopyWithImpl(_$CreateReviewRequestImpl _value,
      $Res Function(_$CreateReviewRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? title = null,
    Object? content = null,
  }) {
    return _then(_$CreateReviewRequestImpl(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReviewRequestImpl implements _CreateReviewRequest {
  const _$CreateReviewRequestImpl(
      {required this.planId, required this.title, required this.content});

  factory _$CreateReviewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReviewRequestImplFromJson(json);

  @override
  final int planId;
  @override
  final String title;
  @override
  final String content;

  @override
  String toString() {
    return 'CreateReviewRequest(planId: $planId, title: $title, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReviewRequestImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, planId, title, content);

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReviewRequestImplCopyWith<_$CreateReviewRequestImpl> get copyWith =>
      __$$CreateReviewRequestImplCopyWithImpl<_$CreateReviewRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReviewRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateReviewRequest implements CreateReviewRequest {
  const factory _CreateReviewRequest(
      {required final int planId,
      required final String title,
      required final String content}) = _$CreateReviewRequestImpl;

  factory _CreateReviewRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReviewRequestImpl.fromJson;

  @override
  int get planId;
  @override
  String get title;
  @override
  String get content;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReviewRequestImplCopyWith<_$CreateReviewRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateReplyRequest _$CreateReplyRequestFromJson(Map<String, dynamic> json) {
  return _CreateReplyRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReplyRequest {
  String get content => throw _privateConstructorUsedError;

  /// Serializes this CreateReplyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReplyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReplyRequestCopyWith<CreateReplyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReplyRequestCopyWith<$Res> {
  factory $CreateReplyRequestCopyWith(
          CreateReplyRequest value, $Res Function(CreateReplyRequest) then) =
      _$CreateReplyRequestCopyWithImpl<$Res, CreateReplyRequest>;
  @useResult
  $Res call({String content});
}

/// @nodoc
class _$CreateReplyRequestCopyWithImpl<$Res, $Val extends CreateReplyRequest>
    implements $CreateReplyRequestCopyWith<$Res> {
  _$CreateReplyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReplyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReplyRequestImplCopyWith<$Res>
    implements $CreateReplyRequestCopyWith<$Res> {
  factory _$$CreateReplyRequestImplCopyWith(_$CreateReplyRequestImpl value,
          $Res Function(_$CreateReplyRequestImpl) then) =
      __$$CreateReplyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content});
}

/// @nodoc
class __$$CreateReplyRequestImplCopyWithImpl<$Res>
    extends _$CreateReplyRequestCopyWithImpl<$Res, _$CreateReplyRequestImpl>
    implements _$$CreateReplyRequestImplCopyWith<$Res> {
  __$$CreateReplyRequestImplCopyWithImpl(_$CreateReplyRequestImpl _value,
      $Res Function(_$CreateReplyRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReplyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
  }) {
    return _then(_$CreateReplyRequestImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReplyRequestImpl implements _CreateReplyRequest {
  const _$CreateReplyRequestImpl({required this.content});

  factory _$CreateReplyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReplyRequestImplFromJson(json);

  @override
  final String content;

  @override
  String toString() {
    return 'CreateReplyRequest(content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReplyRequestImpl &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content);

  /// Create a copy of CreateReplyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReplyRequestImplCopyWith<_$CreateReplyRequestImpl> get copyWith =>
      __$$CreateReplyRequestImplCopyWithImpl<_$CreateReplyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReplyRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateReplyRequest implements CreateReplyRequest {
  const factory _CreateReplyRequest({required final String content}) =
      _$CreateReplyRequestImpl;

  factory _CreateReplyRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReplyRequestImpl.fromJson;

  @override
  String get content;

  /// Create a copy of CreateReplyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReplyRequestImplCopyWith<_$CreateReplyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
