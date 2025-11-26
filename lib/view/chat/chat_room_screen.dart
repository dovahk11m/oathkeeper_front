import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/chat/chat_message.dart';
import 'package:oath_client/domain/chat/chat_provider.dart';
import 'package:oath_client/domain/groups/group_member.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/domain/groups/group_summary.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/widgets/common/chat_bubble.dart';
import 'package:oath_client/widgets/common/profile_avatar.dart';
import 'package:oath_client/view/metrics/metrics_summary_sheet.dart';
import 'package:oath_client/domain/plans/plan_repository.dart';

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

  Future<void> _openPlanSummary() async {
    final planRepo = ref.read(planRepositoryProvider);
    final planId =
        await planRepo.fetchActivePlanIdByGroup(widget.group.groupId);

    if (!mounted) return;

    // 유효한 플랜 없을 때 힌트도 한번 띄워주면 좋다
    if (planId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('진행 중인 약속이 없어요. 새 약속을 만들어 주세요.')),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.85,
        child: MetricsSummarySheet(
          groupId: widget.group.groupId,
          initialPlanId: planId,
          onTapCreatePlan: _showCreatePlan,
        ),
      ),
    );
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
            ListTile(
              leading: const Icon(Icons.analytics_outlined,
                  color: Colors.deepPurple),
              title: const Text('약속 요약 보기'),
              onTap: () {
                Navigator.pop(context);
                _openPlanSummary();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlan() {
    context.push('/plans/create');
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
      backgroundColor: AppDesign.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppDesign.backgroundColor,
        elevation: AppDesign.elevationSmall,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppDesign.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            ProfileAvatar(
              name: widget.group.groupName,
              size: AppDesign.profileMedium - 8,
            ),
            const SizedBox(width: AppDesign.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.groupName,
                    style: const TextStyle(
                      color: AppDesign.textPrimary,
                      fontSize: AppDesign.fontSizeSubtitle,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    '채팅방',
                    style: TextStyle(
                      color: AppDesign.textTertiary,
                      fontSize: AppDesign.fontSizeCaption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppDesign.textPrimary),
            iconSize: AppDesign.iconLarge,
            onPressed: _showChatRoomSettings,
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined,
                color: AppDesign.textPrimary),
            tooltip: '약속 요약',
            onPressed: _openPlanSummary,
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
    return Column(
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
              padding: const EdgeInsets.only(
                left: AppDesign.spacing16,
                bottom: AppDesign.spacing4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileAvatar(
                    name: message.senderName,
                    imageUrl: message.senderProfileImageUrl,
                    size: AppDesign.profileSmall,
                  ),
                  const SizedBox(width: AppDesign.spacing8),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: AppDesign.fontSizeCaption,
                      color: AppDesign.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ChatBubble(
          message: message,
          isMe: isMe,
          onLongPress: () => _showMessageOptions(message),
          onRetry: () => ref
              .read(chatProvider(widget.group.groupId).notifier)
              .retryMessage(message),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacing16,
        vertical: AppDesign.spacing12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDesign.shadowMedium,
        border: Border(
          top: BorderSide(
            color: AppDesign.dividerColor.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppDesign.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: AppDesign.iconMedium,
                color: AppDesign.primaryColor,
                onPressed: _showAddOptions,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(width: AppDesign.spacing8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppDesign.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
                  border: Border.all(
                    color: AppDesign.dividerColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: '메시지를 입력하세요',
                    hintStyle: TextStyle(
                      color: AppDesign.textTertiary,
                      fontSize: AppDesign.fontSizeBody,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDesign.spacing16,
                      vertical: AppDesign.spacing12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: AppDesign.fontSizeBody,
                  ),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: AppDesign.spacing8),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                color: AppDesign.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                iconSize: AppDesign.iconMedium,
                color: Colors.white,
                onPressed: _sendMessage,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
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
        padding: const EdgeInsets.symmetric(vertical: AppDesign.spacing20),
        child: Row(
          children: [
            Expanded(
              child: Divider(
                color: AppDesign.dividerColor.withValues(alpha: 0.5),
                thickness: 0.5,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDesign.spacing12),
              child: Text(
                dateText,
                style: const TextStyle(
                  fontSize: AppDesign.fontSizeCaption,
                  color: AppDesign.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppDesign.dividerColor.withValues(alpha: 0.5),
                thickness: 0.5,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSystemMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesign.spacing8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spacing12,
            vertical: AppDesign.spacing4,
          ),
          decoration: BoxDecoration(
            color: AppDesign.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              fontSize: AppDesign.fontSizeCaption,
              color: AppDesign.textSecondary,
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
            color: AppDesign.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppDesign.spacing16),
          const Text(
            '첫 메시지를 보내보세요!',
            style: TextStyle(
              fontSize: AppDesign.fontSizeSubtitle,
              color: AppDesign.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDesign.spacing8),
          const Text(
            '대화를 시작해보세요',
            style: TextStyle(
              fontSize: AppDesign.fontSizeBody,
              color: AppDesign.textTertiary,
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
      padding: const EdgeInsets.all(AppDesign.spacing24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppDesign.radiusXLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들바
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppDesign.spacing20),
            decoration: BoxDecoration(
              color: AppDesign.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 프로필 이미지
          ProfileAvatar(
            name: username,
            imageUrl: profileImageUrl,
            size: AppDesign.profileXLarge + 20,
          ),
          const SizedBox(height: AppDesign.spacing20),
          // 이름
          Text(
            username,
            style: const TextStyle(
              fontSize: AppDesign.fontSizeLarge,
              fontWeight: FontWeight.w700,
              color: AppDesign.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spacing8),
          // ID
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesign.spacing12,
              vertical: AppDesign.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppDesign.surfaceColor,
              borderRadius: BorderRadius.circular(AppDesign.radiusSmall),
            ),
            child: Text(
              'ID: $memberId',
              style: const TextStyle(
                fontSize: AppDesign.fontSizeCaption,
                color: AppDesign.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: AppDesign.spacing24),
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
    print('[ChatRoomSettings] 그룹 ${widget.groupId} 멤버 로드 시작');
    setState(() {
      _isLoading = true;
    });

    try {
      final members = await ref
          .read(groupStateProvider.notifier)
          .getMembers(widget.groupId);

      print('[ChatRoomSettings] 멤버 로드 완료: ${members.length}명');

      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('[ChatRoomSettings] 멤버 로드 실패: $e');
      print('[ChatRoomSettings] StackTrace: $stackTrace');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('멤버 목록을 불러올 수 없습니다: $e')),
        );
      }
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDesign.radiusXLarge)),
            boxShadow: AppDesign.shadowLarge,
          ),
          child: Column(
            children: [
              // 핸들바
              Container(
                margin: const EdgeInsets.only(top: AppDesign.spacing12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppDesign.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 헤더
              Container(
                padding: const EdgeInsets.all(AppDesign.spacing20),
                child: Row(
                  children: [
                    ProfileAvatar(
                      name: widget.groupName,
                      size: AppDesign.profileMedium,
                    ),
                    const SizedBox(width: AppDesign.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.groupName,
                            style: const TextStyle(
                              fontSize: AppDesign.fontSizeTitle,
                              fontWeight: FontWeight.w700,
                              color: AppDesign.textPrimary,
                            ),
                          ),
                          Text(
                            '${_members.length}명',
                            style: const TextStyle(
                              fontSize: AppDesign.fontSizeBody,
                              color: AppDesign.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppDesign.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppDesign.primaryColor,
                        ),
                      )
                    : _members.isEmpty
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(AppDesign.spacing32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: 80,
                                    color: AppDesign.textTertiary
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: AppDesign.spacing20),
                                  const Text(
                                    '멤버 정보를 불러올 수 없습니다',
                                    style: TextStyle(
                                      fontSize: AppDesign.fontSizeSubtitle,
                                      color: AppDesign.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppDesign.spacing12),
                                  TextButton.icon(
                                    onPressed: _loadMembers,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('다시 시도'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppDesign.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.only(
                                bottom: AppDesign.spacing20),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppDesign.spacing20,
                                  AppDesign.spacing16,
                                  AppDesign.spacing20,
                                  AppDesign.spacing8,
                                ),
                                child: Text(
                                  '참여 중인 멤버',
                                  style: TextStyle(
                                    fontSize: AppDesign.fontSizeBody,
                                    color: AppDesign.textTertiary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              ..._members.map((member) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: AppDesign.spacing12,
                                      vertical: AppDesign.spacing4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppDesign.radiusMedium),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: AppDesign.spacing12,
                                        vertical: AppDesign.spacing4,
                                      ),
                                      leading: ProfileAvatar(
                                        name: member.username,
                                        imageUrl: member.profileImageUrl,
                                        size: AppDesign.profileMedium,
                                      ),
                                      title: Text(
                                        member.username,
                                        style: const TextStyle(
                                          fontSize: AppDesign.fontSizeBody,
                                          fontWeight: FontWeight.w600,
                                          color: AppDesign.textPrimary,
                                        ),
                                      ),
                                      subtitle: member.email != null
                                          ? Text(
                                              member.email!,
                                              style: const TextStyle(
                                                fontSize:
                                                    AppDesign.fontSizeCaption,
                                                color: AppDesign.textTertiary,
                                              ),
                                            )
                                          : null,
                                    ),
                                  )),
                              const SizedBox(height: AppDesign.spacing16),
                              const Divider(height: 1),
                              const SizedBox(height: AppDesign.spacing8),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppDesign.spacing12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppDesign.radiusMedium),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppDesign.spacing12,
                                    vertical: AppDesign.spacing4,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(
                                        AppDesign.spacing8),
                                    decoration: BoxDecoration(
                                      color: AppDesign.errorColor
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.logout,
                                      color: AppDesign.errorColor,
                                      size: AppDesign.iconMedium,
                                    ),
                                  ),
                                  title: const Text(
                                    '채팅방 나가기',
                                    style: TextStyle(
                                      color: AppDesign.errorColor,
                                      fontSize: AppDesign.fontSizeBody,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
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
