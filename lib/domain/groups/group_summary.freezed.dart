// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupSummary _$GroupSummaryFromJson(Map<String, dynamic> json) {
  return _GroupSummary.fromJson(json);
}

/// @nodoc
mixin _$GroupSummary {
  int get groupId => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  int get chatRoomId => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  String? get lastMessageSentAt => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this GroupSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupSummaryCopyWith<GroupSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupSummaryCopyWith<$Res> {
  factory $GroupSummaryCopyWith(
          GroupSummary value, $Res Function(GroupSummary) then) =
      _$GroupSummaryCopyWithImpl<$Res, GroupSummary>;
  @useResult
  $Res call(
      {int groupId,
      String groupName,
      int chatRoomId,
      String? lastMessage,
      String? lastMessageSentAt,
      int unreadCount});
}

/// @nodoc
class _$GroupSummaryCopyWithImpl<$Res, $Val extends GroupSummary>
    implements $GroupSummaryCopyWith<$Res> {
  _$GroupSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? chatRoomId = null,
    Object? lastMessage = freezed,
    Object? lastMessageSentAt = freezed,
    Object? unreadCount = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      chatRoomId: null == chatRoomId
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSentAt: freezed == lastMessageSentAt
          ? _value.lastMessageSentAt
          : lastMessageSentAt // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupSummaryImplCopyWith<$Res>
    implements $GroupSummaryCopyWith<$Res> {
  factory _$$GroupSummaryImplCopyWith(
          _$GroupSummaryImpl value, $Res Function(_$GroupSummaryImpl) then) =
      __$$GroupSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int groupId,
      String groupName,
      int chatRoomId,
      String? lastMessage,
      String? lastMessageSentAt,
      int unreadCount});
}

/// @nodoc
class __$$GroupSummaryImplCopyWithImpl<$Res>
    extends _$GroupSummaryCopyWithImpl<$Res, _$GroupSummaryImpl>
    implements _$$GroupSummaryImplCopyWith<$Res> {
  __$$GroupSummaryImplCopyWithImpl(
      _$GroupSummaryImpl _value, $Res Function(_$GroupSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? chatRoomId = null,
    Object? lastMessage = freezed,
    Object? lastMessageSentAt = freezed,
    Object? unreadCount = null,
  }) {
    return _then(_$GroupSummaryImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      chatRoomId: null == chatRoomId
          ? _value.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSentAt: freezed == lastMessageSentAt
          ? _value.lastMessageSentAt
          : lastMessageSentAt // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupSummaryImpl implements _GroupSummary {
  const _$GroupSummaryImpl(
      {required this.groupId,
      required this.groupName,
      required this.chatRoomId,
      this.lastMessage,
      this.lastMessageSentAt,
      required this.unreadCount});

  factory _$GroupSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupSummaryImplFromJson(json);

  @override
  final int groupId;
  @override
  final String groupName;
  @override
  final int chatRoomId;
  @override
  final String? lastMessage;
  @override
  final String? lastMessageSentAt;
  @override
  final int unreadCount;

  @override
  String toString() {
    return 'GroupSummary(groupId: $groupId, groupName: $groupName, chatRoomId: $chatRoomId, lastMessage: $lastMessage, lastMessageSentAt: $lastMessageSentAt, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupSummaryImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageSentAt, lastMessageSentAt) ||
                other.lastMessageSentAt == lastMessageSentAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, groupName, chatRoomId,
      lastMessage, lastMessageSentAt, unreadCount);

  /// Create a copy of GroupSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupSummaryImplCopyWith<_$GroupSummaryImpl> get copyWith =>
      __$$GroupSummaryImplCopyWithImpl<_$GroupSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupSummaryImplToJson(
      this,
    );
  }
}

abstract class _GroupSummary implements GroupSummary {
  const factory _GroupSummary(
      {required final int groupId,
      required final String groupName,
      required final int chatRoomId,
      final String? lastMessage,
      final String? lastMessageSentAt,
      required final int unreadCount}) = _$GroupSummaryImpl;

  factory _GroupSummary.fromJson(Map<String, dynamic> json) =
      _$GroupSummaryImpl.fromJson;

  @override
  int get groupId;
  @override
  String get groupName;
  @override
  int get chatRoomId;
  @override
  String? get lastMessage;
  @override
  String? get lastMessageSentAt;
  @override
  int get unreadCount;

  /// Create a copy of GroupSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupSummaryImplCopyWith<_$GroupSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
