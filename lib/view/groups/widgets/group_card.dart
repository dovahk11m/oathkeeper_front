import 'package:flutter/material.dart';
import 'package:oath_client/view/groups/widgets/invite_member_dialog.dart';

import '../../../domain/groups/group_summary.dart';

class GroupCard extends StatelessWidget {
  final GroupSummary group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 그룹 이름 및 안 읽은 메시지 수
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group.groupName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    // 멤버 초대 버튼
                    IconButton(
                      icon: const Icon(Icons.person_add, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => InviteMemberDialog(
                            groupId: group.groupId,
                            groupName: group.groupName,
                          ),
                        );
                      },
                      tooltip: '멤버 초대',
                    ),
                    if (group.unreadCount > 0)
                      Badge(
                        label: Text(group.unreadCount.toString()),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 마지막 메시지
            Text(
              group.lastMessage ?? '아직 메시지가 없습니다.',
              style: TextStyle(
                color: group.lastMessage == null ? Colors.grey : Colors.black87,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // 마지막 메시지 시간
            if (group.lastMessageSentAt != null)
              Text(
                // TODO: 실제 앱에서는 시간 포맷팅 라이브러리(e.g., intl) 사용 권장
                group.lastMessageSentAt!
                    .split('T')[0], // 'YYYY-MM-DD' 형식으로 간단히 표시
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
