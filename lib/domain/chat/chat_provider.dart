import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/websocket_service.dart';
import 'package:oath_client/domain/chat/chat_message.dart';
import 'package:oath_client/domain/chat/chat_repository.dart';
import 'package:oath_client/domain/chat/chat_state.dart';
import 'package:oath_client/domain/groups/group_provider.dart';

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
      print('[Chat] 그룹 $arg WebSocket 초기화');
      await _websocketService.subscribeToChatRoom(arg, (data) {
        try {
          final rawMessage = data['raw'] as String;
          print('[Chat] 그룹 $arg 메시지 파싱: $rawMessage');
          final messageJson = jsonDecode(rawMessage);
          final message = ChatMessage.fromJson(messageJson);

          print('[Chat] 메시지 파싱 성공: ${message.senderName}: ${message.content}');
          state = state.copyWith(
            messages: [...state.messages, message],
          );

          // 메시지 수신 시 채팅방 목록 갱신
          print('[Chat] 채팅방 목록 갱신 요청');
          ref.invalidate(groupsProvider);
        } catch (e) {
          print('[Chat] 메시지 파싱 실패: $e');
        }
      });
      print('[Chat] 그룹 $arg WebSocket 초기화 완료');
    } catch (e) {
      print('[Chat] WebSocket 초기화 실패: $e');
      state = state.copyWith(error: 'WebSocket 연결 실패');
    }
  }

  /// 이전 메시지 목록 로드 (REST API)
  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('[Chat] 그룹 $arg 메시지 로드');
      final messages = await _repository.getMessages(arg);
      print('[Chat] ${messages.length}개 메시지 로드됨');
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      print('[Chat] 메시지 로드 실패: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 메시지 전송 (WebSocket)
  void sendMessage(String content, {int? planId}) {
    try {
      print('[Chat] 그룹 $arg에 메시지 전송: $content');
      _websocketService.sendMessage(arg, content, planId: planId);
    } catch (e) {
      print('[Chat] 메시지 전송 실패: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}
