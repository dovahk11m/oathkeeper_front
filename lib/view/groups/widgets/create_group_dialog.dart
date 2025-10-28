import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/groups/group_provider.dart';

class CreateGroupDialog extends ConsumerWidget {
  const CreateGroupDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNameController = TextEditingController();
    final groupState = ref.watch(groupStateProvider);

    return AlertDialog(
      title: const Text('새 그룹 생성'),
      content: TextField(
        controller: groupNameController,
        autofocus: true,
        decoration: const InputDecoration(hintText: '그룹 이름을 입력하세요'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        // 그룹 생성 중일 때는 로딩 인디케이터를 보여줍니다.
        if (groupState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
                width: 24, height: 24, child: CircularProgressIndicator()),
          )
        else
          FilledButton(
            onPressed: () {
              final groupName = groupNameController.text;
              if (groupName.isNotEmpty) {
                // [수정] groupProvider -> groupStateProvider로 변경
                ref
                    .read(groupStateProvider.notifier)
                    .createGroup(groupName)
                    .then((_) {
                  // 그룹 생성이 성공적으로 완료되면 (에러가 없으면) 다이얼로그를 닫습니다.
                  if (ref.read(groupStateProvider).error == null) {
                    Navigator.of(context).pop();
                  }
                });
              }
            },
            child: const Text('생성'),
          ),
      ],
    );
  }
}
