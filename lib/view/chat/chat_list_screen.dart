import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/view/chat/widgets/chat_room_card.dart';
import 'package:oath_client/view/groups/widgets/create_group_dialog.dart';
import 'package:oath_client/view/widgets/common_widgets.dart';
import 'package:oath_client/view/widgets/custom_search_bar.dart' as custom;

/// 채팅방 목록 화면
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsyncValue = ref.watch(groupsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Oath Keeper',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateGroupDialog(),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 검색바
          const custom.SearchBar(hintText: '대화방 검색'),
          // 채팅방 목록
          Expanded(
            child: groupsAsyncValue.when(
              loading: () => const LoadingWidget(),
              error: (err, stack) => CustomErrorWidget(
                message: '채팅방을 불러오는데 실패했습니다\n$err',
                onRetry: () => ref.invalidate(groupsProvider),
              ),
              data: (groups) {
                if (groups.isEmpty) {
                  return const EmptyWidget(
                    message: '채팅방이 없습니다\n새 그룹을 만들어보세요!',
                    icon: Icons.chat_bubble_outline,
                  );
                }
                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return ChatRoomCard(group: groups[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

