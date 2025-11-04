import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oath_client/domain/chat/chat_message.dart';
import 'package:oath_client/domain/chat/chat_provider.dart';
import 'package:oath_client/domain/groups/group_member.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/domain/groups/group_summary.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/view/plans/widgets/create_plan_dialog.dart';

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
  final ImagePicker _imagePicker = ImagePicker();

  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatProvider(widget.group.groupId).notifier).initialize();
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100;
      if (_showScrollToBottom == isAtBottom) {
        setState(() {
          _showScrollToBottom = !isAtBottom;
        });
      }
    }
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
    ref.read(chatProvider(widget.group.groupId).notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event, color: Colors.blue),
              title: const Text('약속 만들기'),
              onTap: () {
                Navigator.pop(context);
                _showCreatePlan();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text('이미지 보내기'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSendImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlan() {
    showDialog(
      context: context,
      builder: (context) => CreatePlanDialog(groupId: widget.group.groupId),
    );
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // TODO: 이미지 업로드 API 구현 필요
        // 임시로 이미지 경로를 메시지로 전송
        ref
            .read(chatProvider(widget.group.groupId).notifier)
            .sendMessage('[이미지: ${image.name}]');
        _scrollToBottom();
      }
    } catch (e) {
      print('[ChatRoom] 이미지 선택 실패: $e');
    }
  }

  void _scrollToBottom() {
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

  void _showMemberProfile(
      int memberId, String username, String? profileImageUrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ProfileBottomSheet(
        memberId: memberId,
        username: username,
        profileImageUrl: profileImageUrl,
      ),
    );
  }

  void _showChatRoomSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ChatRoomSettingsSheet(
        groupId: widget.group.groupId,
        groupName: widget.group.groupName,
      ),
    );
  }

  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('복사'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('복사됨')),
                );
              },
            ),
          ],
        ),
      ),
    );
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
            onPressed: _showChatRoomSettings,
          ),
        ],
      ),
      body: chatState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatState.error != null
              ? Center(child: Text('에러: ${chatState.error}'))
              : Column(
                  children: [
                    Expanded(
                      child: chatState.messages.isEmpty
                          ? _buildEmptyState()
                          : Stack(
                              children: [
                                ListView.builder(
                                  controller: _scrollController,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  itemCount: chatState.messages.length,
                                  itemBuilder: (context, index) {
                                    final message = chatState.messages[index];
                                    final isMe =
                                        message.senderId == currentUserId;

                                    final showDateDivider = index == 0 ||
                                        !_isSameDay(
                                          chatState.messages[index - 1].sentAt,
                                          message.sentAt,
                                        );

                                    return Column(
                                      children: [
                                        if (showDateDivider)
                                          _buildDateDivider(message.sentAt),
                                        if (message.messageType ==
                                            MessageType.system)
                                          _buildSystemMessage(message)
                                        else
                                          _buildMessageBubble(message, isMe),
                                      ],
                                    );
                                  },
                                ),
                                if (_showScrollToBottom)
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: FloatingActionButton.small(
                                      onPressed: _scrollToBottom,
                                      backgroundColor: Colors.white,
                                      child: const Icon(Icons.arrow_downward,
                                          color: Colors.blue),
                                    ),
                                  ),
                              ],
                            ),
                    ),
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
            GestureDetector(
              onTap: () => _showMemberProfile(
                message.senderId,
                message.senderName,
                message.senderProfileImageUrl,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (message.status == MessageStatus.pending)
                      const Icon(Icons.access_time, size: 12, color: Colors.grey)
                    else if (message.status == MessageStatus.failed)
                      GestureDetector(
                        onTap: () => ref.read(chatProvider(widget.group.groupId).notifier).retryMessage(message),
                        child: const Icon(Icons.error, size: 12, color: Colors.red),
                      ),
                    Text(
                      _formatTime(message.sentAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: GestureDetector(
                  onLongPress: () => _showMessageOptions(message),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? (message.status == MessageStatus.failed
                              ? Colors.red.withValues(alpha: 0.3)
                              : Colors.blue)
                          : Colors.white,
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
              onPressed: _showAddOptions,
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

  Widget _buildDateDivider(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final messageDate = DateTime(date.year, date.month, date.day);

      String dateText;
      if (messageDate == today) {
        dateText = '오늘';
      } else if (messageDate == yesterday) {
        dateText = '어제';
      } else {
        dateText = '${date.year}년 ${date.month}월 ${date.day}일';
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                dateText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSystemMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            '첫 메시지를 보내보세요!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '대화를 시작해보세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(String date1Str, String date2Str) {
    try {
      final date1 = DateTime.parse(date1Str);
      final date2 = DateTime.parse(date2Str);
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    } catch (e) {
      return false;
    }
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

/// 프로필 바텀시트
class _ProfileBottomSheet extends StatelessWidget {
  final int memberId;
  final String username;
  final String? profileImageUrl;

  const _ProfileBottomSheet({
    required this.memberId,
    required this.username,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
            child: profileImageUrl == null
                ? Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '?',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: $memberId',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// 채팅방 설정 바텀시트
class _ChatRoomSettingsSheet extends ConsumerStatefulWidget {
  final int groupId;
  final String groupName;

  const _ChatRoomSettingsSheet({
    required this.groupId,
    required this.groupName,
  });

  @override
  ConsumerState<_ChatRoomSettingsSheet> createState() =>
      _ChatRoomSettingsSheetState();
}

class _ChatRoomSettingsSheetState
    extends ConsumerState<_ChatRoomSettingsSheet> {
  List<GroupMember> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final membersData = await ref
          .read(groupStateProvider.notifier)
          .getMembers(widget.groupId);
      setState(() {
        _members = membersData.map((m) => GroupMember.fromJson(m)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('[ChatRoomSettings] 멤버 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.groupName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        controller: scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              '멤버 (${_members.length})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ..._members.map((member) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: member.profileImageUrl !=
                                          null
                                      ? NetworkImage(member.profileImageUrl!)
                                      : null,
                                  child: member.profileImageUrl == null
                                      ? Text(member.username[0].toUpperCase())
                                      : null,
                                ),
                                title: Text(member.username),
                                subtitle: Text(member.email),
                              )),
                          const Divider(height: 32),
                          ListTile(
                            leading: const Icon(Icons.exit_to_app,
                                color: Colors.red),
                            title: const Text(
                              '채팅방 나가기',
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
