import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/auth/auth_provider.dart';
import 'package:oath_client/domain/chat/chat_message.dart';
import 'package:oath_client/domain/chat/chat_provider.dart';
import 'package:oath_client/domain/groups/group_summary.dart';

/// 채팅방 화면
class ChatRoomScreen extends ConsumerStatefulWidget {
  final GroupSummary group;

  const ChatRoomScreen({
    super.key,
    required this.group,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 채팅방 입장 시 WebSocket 연결 및 메시지 로드
    Future.microtask(() {
      ref.read(chatProvider(widget.group.groupId).notifier).initialize();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    // WebSocket으로 메시지 전송
    ref.read(chatProvider(widget.group.groupId).notifier).sendMessage(text);

    // 스크롤을 맨 아래로
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.group.groupId));
    final currentUserId = ref.watch(authProvider).auth?.id;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.groupName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '채팅방',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // TODO: 채팅방 설정 메뉴
            },
          ),
        ],
      ),
      body: chatState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatState.error != null
              ? Center(child: Text('에러: ${chatState.error}'))
              : Column(
                  children: [
                    // 메시지 목록
                    Expanded(
                      child: chatState.messages.isEmpty
                          ? const Center(child: Text('메시지가 없습니다'))
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemCount: chatState.messages.length,
                              itemBuilder: (context, index) {
                                final message = chatState.messages[index];
                                final isMe = message.senderId == currentUserId;
                                return _buildMessageBubble(message, isMe);
                              },
                            ),
                    ),
                    // 메시지 입력창
                    _buildMessageInput(),
                  ],
                ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 60 : 16,
        right: isMe ? 16 : 60,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe) ...[
                Text(
                  _formatTime(message.sentAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              if (!isMe) ...[
                const SizedBox(width: 4),
                Text(
                  _formatTime(message.sentAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.grey[600],
              onPressed: () {
                // TODO: 파일 첨부 등
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.blue,
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String sentAt) {
    try {
      final dateTime = DateTime.parse(sentAt);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? '오전' : '오후';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$period $displayHour:$minute';
    } catch (e) {
      return sentAt;
    }
  }
}


