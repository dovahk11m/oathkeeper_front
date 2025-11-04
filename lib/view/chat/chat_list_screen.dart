import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/websocket_service.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/view/chat/widgets/chat_room_card.dart';
import 'package:oath_client/view/groups/widgets/create_group_dialog.dart';
import 'package:oath_client/widgets/common_widgets.dart';
import 'package:oath_client/widgets/custom_search_bar.dart' as custom;

/// 채팅방 목록 화면
class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> with WidgetsBindingObserver {
  bool _notificationSubscribed = false;

  @override
  void initState() {
    super.initState();
    print('[ChatList] 화면 초기화');
    WidgetsBinding.instance.addObserver(this);

    // 개인 알림 구독
    Future.microtask(() => _subscribeToNotifications());
  }

  Future<void> _subscribeToNotifications() async {
    if (_notificationSubscribed) return;

    try {
      await ref.read(websocketServiceProvider).subscribeToPersonalNotifications((data) {
        try {
          final rawMessage = data['raw'] as String;
          print('[ChatList] 알림 수신: $rawMessage');
          final notification = jsonDecode(rawMessage);

          // 그룹 초대 알림이면 목록 갱신
          if (notification['type'] == 'GROUP_INVITE') {
            print('[ChatList] 그룹 초대 알림 - 목록 갱신');
            ref.invalidate(groupsProvider);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${notification['message'] ?? '새 채팅방에 초대되었습니다'}')),
              );
            }
          }
        } catch (e) {
          print('[ChatList] 알림 파싱 실패: $e');
        }
      });
      _notificationSubscribed = true;
    } catch (e) {
      print('[ChatList] 알림 구독 실패: $e');
    }
  }

  @override
  void dispose() {
    print('[ChatList] 화면 종료');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('[ChatList] 앱 상태 변경: $state');
    // 앱이 포그라운드로 돌아올 때 채팅방 목록 갱신
    if (state == AppLifecycleState.resumed) {
      print('[ChatList] 포그라운드 복귀 - 목록 갱신');
      ref.invalidate(groupsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              loading: () {
                print('[ChatList] 로딩 중');
                return const LoadingWidget();
              },
              error: (err, stack) {
                print('[ChatList] 에러: $err');
                return CustomErrorWidget(
                  message: '채팅방을 불러오는데 실패했습니다\n$err',
                  onRetry: () {
                    print('[ChatList] 재시도');
                    ref.invalidate(groupsProvider);
                  },
                );
              },
              data: (groups) {
                print('[ChatList] 데이터 로드: ${groups.length}개');
                if (groups.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      print('[ChatList] 새로고침');
                      ref.invalidate(groupsProvider);
                      await ref.read(groupsProvider.future);
                    },
                    child: ListView(
                      children: const [
                        SizedBox(
                          height: 300,
                          child: EmptyWidget(
                            message: '채팅방이 없습니다\n새 그룹을 만들어보세요!',
                            icon: Icons.chat_bubble_outline,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    print('[ChatList] 새로고침');
                    ref.invalidate(groupsProvider);
                    await ref.read(groupsProvider.future);
                  },
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return ChatRoomCard(group: groups[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
