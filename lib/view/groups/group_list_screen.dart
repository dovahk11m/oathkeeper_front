import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/view/groups/widgets/create_group_dialog.dart';
import 'package:oath_client/view/groups/widgets/group_card.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsyncValue = ref.watch(groupsProvider);

    return Container(
      // 1. 그라데이션 배경 적용
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kAppGradientStart, kAppGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // 2. Scaffold 배경을 투명하게
        appBar: AppBar(
          title: const Text('내 그룹'),
          backgroundColor: Colors.transparent, // 3. AppBar 배경도 투명하게
          foregroundColor: Colors.white, // 4. AppBar 아이콘 및 글자색을 흰색으로
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: '새 그룹 생성',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateGroupDialog(),
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => ref.invalidate(groupsProvider),
          child: groupsAsyncValue.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white)),
            error: (err, stack) => Center(
              // 5. 에러 메시지 색상 변경
              child: Text('에러: ${err.toString()}',
                  style: const TextStyle(color: Colors.white)),
            ),
            data: (groups) {
              return groups.isEmpty
                  ? const Center(
                      child: Text('속한 그룹이 없습니다. 새 그룹을 만들어보세요!',
                          style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return GroupCard(group: groups[index]);
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
