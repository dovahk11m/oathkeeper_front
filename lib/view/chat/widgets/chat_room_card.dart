import 'package:flutter/material.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/groups/group_summary.dart';
import 'package:oath_client/view/chat/chat_room_screen.dart';
import 'package:oath_client/view/groups/widgets/invite_member_dialog.dart';
import 'package:oath_client/widgets/common/profile_avatar.dart';

/// 채팅방 카드 (카카오톡 스타일)
class ChatRoomCard extends StatelessWidget {
  final GroupSummary group;

  const ChatRoomCard({
    super.key,
    required this.group,
  });

  String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inDays == 0) {
        final hour = dateTime.hour;
        final minute = dateTime.minute.toString().padLeft(2, '0');
        final period = hour < 12 ? '오전' : '오후';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$period $displayHour:$minute';
      } else if (diff.inDays == 1) {
        return '어제';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}일 전';
      } else {
        return '${dateTime.month}월 ${dateTime.day}일';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = group.unreadCount > 0;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(group: group),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => InviteMemberDialog(
            groupId: group.groupId,
            groupName: group.groupName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spacing16,
          vertical: AppDesign.spacing12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppDesign.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // 프로필 아바타
            ProfileAvatar(
              name: group.groupName,
              size: AppDesign.profileLarge,
              showBadge: hasUnread,
              badgeCount: group.unreadCount,
              showRing: hasUnread,
            ),
            const SizedBox(width: AppDesign.spacing12),
            // 그룹 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          group.groupName,
                          style: TextStyle(
                            fontSize: AppDesign.fontSizeSubtitle,
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: AppDesign.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDesign.spacing4),
                  Text(
                    group.lastMessage ?? '메시지가 없습니다',
                    style: TextStyle(
                      fontSize: AppDesign.fontSizeBody,
                      color: hasUnread ? AppDesign.textSecondary : AppDesign.textTertiary,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDesign.spacing8),
            // 시간
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (group.lastMessageSentAt != null)
                  Text(
                    _formatTime(group.lastMessageSentAt!),
                    style: TextStyle(
                      fontSize: AppDesign.fontSizeCaption,
                      color: hasUnread ? AppDesign.textSecondary : AppDesign.textTertiary,
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

