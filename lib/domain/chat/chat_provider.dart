import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/websocket_service.dart';
import 'package:oath_client/domain/chat/chat_message.dart';
import 'package:oath_client/domain/chat/chat_repository.dart';
import 'package:oath_client/domain/chat/chat_state.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';

/// 채팅방별 상태 관리 (groupId 기반)
final chatProvider = NotifierProvider.family<ChatNotifier, ChatState, int>(
  () => ChatNotifier(),
);

class ChatNotifier extends FamilyNotifier<ChatState, int> {
  late final ChatRepository _repository;
  late final WebSocketService _websocketService;

  @override
  ChatState build(int groupId) {
    _repository = ref.read(chatRepositoryProvider);
    _websocketService = ref.read(websocketServiceProvider);

    return const ChatState();
  }

  /// 채팅방 초기화 (화면 진입 시 명시적으로 호출)
  Future<void> initialize() async {
    // WebSocket 연결 및 구독
    await _initializeWebSocket();

    // 이전 메시지 로드
    await loadMessages();

    // 읽음 처리
    await _repository.markAsRead(arg);

    // 채팅방 목록 갱신 (unreadCount 업데이트)
    ref.invalidate(groupsProvider);
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

          final currentUserId = ref.read(authProvider).auth?.id;

          // 내가 보낸 메시지인 경우: 이미 낙관적 업데이트로 추가했으므로 중복 방지
          if (message.senderId == currentUserId) {
            // 임시 메시지를 서버 메시지로 교체
            final updatedMessages = state.messages.map((msg) {
              // content와 senderId가 동일하고 상태가 pending/sent인 경우
              if (msg.senderId == currentUserId &&
                  msg.content == message.content &&
                  (msg.status == MessageStatus.pending || msg.status == MessageStatus.sent)) {
                return message.copyWith(status: MessageStatus.sent);
              }
              return msg;
            }).toList();

            // 중복 확인: 이미 같은 messageId가 있는지 체크
            final isDuplicate = updatedMessages.any((msg) => msg.messageId == message.messageId);

            state = state.copyWith(
              messages: isDuplicate ? updatedMessages : [...updatedMessages, message.copyWith(status: MessageStatus.sent)],
            );
          } else {
            // 상대방 메시지: 바로 추가
            state = state.copyWith(
              messages: [...state.messages, message],
            );
          }

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
    final currentUserId = ref.read(authProvider).auth?.id;
    final currentUserName = ref.read(authProvider).auth?.username;

    if (currentUserId == null || currentUserName == null) {
      state = state.copyWith(error: '로그인 정보를 찾을 수 없습니다');
      return;
    }

    // 낙관적 업데이트: 전송 중 메시지 즉시 표시
    final tempMessage = ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch,
      senderId: currentUserId,
      senderName: currentUserName,
      content: content,
      sentAt: DateTime.now().toIso8601String(),
      planId: planId,
      status: MessageStatus.pending,
    );

    state = state.copyWith(
      messages: [...state.messages, tempMessage],
    );

    try {
      print('[Chat] 그룹 $arg에 메시지 전송: $content');
      _websocketService.sendMessage(arg, content, planId: planId);

      // 전송 성공 상태로 업데이트
      final updatedMessages = state.messages.map((msg) {
        if (msg.messageId == tempMessage.messageId) {
          return msg.copyWith(status: MessageStatus.sent);
        }
        return msg;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      print('[Chat] 메시지 전송 실패: $e');

      // 전송 실패 상태로 업데이트
      final updatedMessages = state.messages.map((msg) {
        if (msg.messageId == tempMessage.messageId) {
          return msg.copyWith(status: MessageStatus.failed);
        }
        return msg;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        error: '메시지 전송 실패',
      );
    }
  }

  /// 메시지 재전송
  void retryMessage(ChatMessage failedMessage) {
    // 실패한 메시지 제거
    final updatedMessages = state.messages.where((msg) => msg.messageId != failedMessage.messageId).toList();
    state = state.copyWith(messages: updatedMessages);

    // 재전송
    sendMessage(failedMessage.content, planId: failedMessage.planId);
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}
