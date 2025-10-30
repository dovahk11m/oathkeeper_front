import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

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
    required String sentAt, // ISO8601 문자열
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

