import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/view/chat/widgets/chat_room_card.dart';

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
              '모여라',
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
                // TODO: 그룹 생성 다이얼로그
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 검색바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: '대화방 검색',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          // 채팅방 목록
          Expanded(
            child: groupsAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('에러: $err')),
              data: (groups) {
                if (groups.isEmpty) {
                  return const Center(child: Text('채팅방이 없습니다'));
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

