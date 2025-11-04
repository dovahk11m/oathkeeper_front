// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      messageId: (json['messageId'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      senderName: json['senderName'] as String,
      senderProfileImageUrl: json['senderProfileImageUrl'] as String?,
      content: json['content'] as String,
      planId: (json['planId'] as num?)?.toInt(),
      sentAt: json['sentAt'] as String,
      messageType:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']) ??
              MessageType.text,
      imageUrl: json['imageUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderProfileImageUrl': instance.senderProfileImageUrl,
      'content': instance.content,
      'planId': instance.planId,
      'sentAt': instance.sentAt,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'imageUrl': instance.imageUrl,
      'isRead': instance.isRead,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'TEXT',
  MessageType.image: 'IMAGE',
  MessageType.system: 'SYSTEM',
};
