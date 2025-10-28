// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupSummaryImpl _$$GroupSummaryImplFromJson(Map<String, dynamic> json) =>
    _$GroupSummaryImpl(
      groupId: (json['groupId'] as num).toInt(),
      groupName: json['groupName'] as String,
      chatRoomId: (json['chatRoomId'] as num).toInt(),
      lastMessage: json['lastMessage'] as String?,
      lastMessageSentAt: json['lastMessageSentAt'] as String?,
      unreadCount: (json['unreadCount'] as num).toInt(),
    );

Map<String, dynamic> _$$GroupSummaryImplToJson(_$GroupSummaryImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'chatRoomId': instance.chatRoomId,
      'lastMessage': instance.lastMessage,
      'lastMessageSentAt': instance.lastMessageSentAt,
      'unreadCount': instance.unreadCount,
    };
