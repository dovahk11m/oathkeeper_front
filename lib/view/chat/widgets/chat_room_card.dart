import 'package:flutter/material.dart';
import 'package:oath_client/domain/groups/group_summary.dart';
import 'package:oath_client/view/chat/chat_room_screen.dart';

/// 채팅방 카드
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(group: group),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 그룹 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            // 그룹 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.lastMessage ?? '메시지가 없습니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 시간 + 배지
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (group.lastMessageSentAt != null)
                  Text(
                    _formatTime(group.lastMessageSentAt!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 4),
                // 읽지 않은 메시지 배지
                if (group.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${group.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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

