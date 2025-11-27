// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum MessageType {
  @JsonValue('TEXT')
  text,
  @JsonValue('IMAGE')
  image,
  @JsonValue('SYSTEM')
  system,
}

enum MessageStatus {
  pending,
  sent,
  failed,
}

/// 채팅 메시지
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required int messageId,
    required int senderId,
    required String senderName,
    String? senderProfileImageUrl,
    required String content,
    int? planId,
    required String sentAt,
    @Default(MessageType.text) MessageType messageType,
    String? imageUrl,
    @Default(false) bool isRead,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(MessageStatus.sent)
    MessageStatus status,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
