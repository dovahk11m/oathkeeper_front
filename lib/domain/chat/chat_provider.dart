import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/websocket_service.dart';
import 'package:oath_client/domain/chat/chat_message.dart';
import 'package:oath_client/domain/chat/chat_repository.dart';
import 'package:oath_client/domain/chat/chat_state.dart';

/// 채팅방별 상태 관리 (groupId 기반)
final chatProvider = NotifierProvider.family<ChatNotifier, ChatState, int>(
  () => ChatNotifier(),
);

class ChatNotifier extends FamilyNotifier<ChatState, int> {
  late final ChatRepository _repository;
  late final WebSocketService _websocketService;
  bool _isWebSocketInitialized = false;

  @override
  ChatState build(int groupId) {
    _repository = ref.read(chatRepositoryProvider);
    _websocketService = ref.read(websocketServiceProvider);

    return const ChatState();
  }

  /// 채팅방 초기화 (화면 진입 시 명시적으로 호출)
  Future<void> initialize() async {
    if (_isWebSocketInitialized) return;

    // WebSocket 연결 및 구독
    await _initializeWebSocket();

    // 이전 메시지 로드
    await loadMessages();

    _isWebSocketInitialized = true;
  }

  /// WebSocket 초기화 및 구독
  Future<void> _initializeWebSocket() async {
    try {
      await _websocketService.subscribeToChatRoom(arg, (data) {
        try {
          final rawMessage = data['raw'] as String;
          final messageJson = jsonDecode(rawMessage);
          final message = ChatMessage.fromJson(messageJson);

          state = state.copyWith(
            messages: [...state.messages, message],
          );
        } catch (e) {
          print('[Chat] 메시지 파싱 실패: $e');
        }
      });
    } catch (e) {
      state = state.copyWith(error: 'WebSocket 연결 실패');
    }
  }

  /// 이전 메시지 목록 로드 (REST API)
  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final messages = await _repository.getMessages(arg);
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 메시지 전송 (WebSocket)
  void sendMessage(String content, {int? planId}) {
    try {
      _websocketService.sendMessage(arg, content, planId: planId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

