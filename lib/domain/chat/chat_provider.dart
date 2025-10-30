import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/chat/chat_repository.dart';
import 'package:oath_client/domain/chat/chat_state.dart';

/// 채팅방별 상태 관리
final chatProvider = NotifierProvider.family<ChatNotifier, ChatState, int>(
  () => ChatNotifier(),
);

class ChatNotifier extends FamilyNotifier<ChatState, int> {
  late final ChatRepository _repository;

  @override
  ChatState build(int chatRoomId) {
    _repository = ref.read(chatRepositoryProvider);
    loadMessages();
    return const ChatState();
  }

  /// 메시지 목록 로드
  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final messages = await _repository.getMessages(arg);
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 메시지 전송
  Future<void> sendMessage(String content) async {
    try {
      final newMessage = await _repository.sendMessage(
        chatRoomId: arg,
        content: content,
      );

      // 새 메시지를 목록에 추가
      state = state.copyWith(
        messages: [...state.messages, newMessage],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

