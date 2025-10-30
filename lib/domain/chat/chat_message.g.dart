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
    };
