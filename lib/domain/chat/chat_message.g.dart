// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: (json['id'] as num).toInt(),
      chatRoomId: (json['chatRoomId'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      senderNickname: json['senderNickname'] as String,
      senderProfileImageUrl: json['senderProfileImageUrl'] as String?,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatRoomId': instance.chatRoomId,
      'senderId': instance.senderId,
      'senderNickname': instance.senderNickname,
      'senderProfileImageUrl': instance.senderProfileImageUrl,
      'content': instance.content,
      'messageType': instance.messageType,
      'sentAt': instance.sentAt.toIso8601String(),
    };
