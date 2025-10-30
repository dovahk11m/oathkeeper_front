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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kAppGradientStart, kAppGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('내 그룹',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
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
          color: Colors.white, // 인디케이터 색상
          backgroundColor: kAppGradientEnd, // 인디케이터 배경색
          onRefresh: () async => ref.invalidate(groupsProvider),
          child: groupsAsyncValue.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white)),
            error: (err, stack) => Center(
              child: Text('에러: ${err.toString()}',
                  style: const TextStyle(color: Colors.white70)),
            ),
            data: (groups) {
              return groups.isEmpty
                  ? const Center(
                      child: Text('속한 그룹이 없습니다.\n새 그룹을 만들어보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, height: 1.5)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
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
