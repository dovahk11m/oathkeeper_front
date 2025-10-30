import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oath_client/domain/chat/chat_message.dart';

part 'chat_state.freezed.dart';

/// 채팅 상태
@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isLoading,
    String? error,
  }) = _ChatState;
}

