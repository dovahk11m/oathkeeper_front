import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/view/groups/widgets/invite_member_dialog.dart';

class CreateGroupDialog extends ConsumerStatefulWidget {
  const CreateGroupDialog({super.key});

  @override
  ConsumerState<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends ConsumerState<CreateGroupDialog> {
  final _groupNameController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupStateProvider);

    return AlertDialog(
      title: const Text('새 그룹 생성'),
      content: TextField(
        controller: _groupNameController,
        autofocus: true,
        decoration: const InputDecoration(hintText: '그룹 이름을 입력하세요'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        if (groupState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
                width: 24, height: 24, child: CircularProgressIndicator()),
          )
        else
          FilledButton(
            onPressed: () async {
              final groupName = _groupNameController.text.trim();
              if (groupName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('그룹 이름을 입력하세요')),
                );
                return;
              }

              print('[CreateGroup] 그룹 생성 시도: $groupName');
              final groupId = await ref.read(groupStateProvider.notifier).createGroup(groupName);

              if (groupId != null && context.mounted) {
                // 그룹 생성 성공 - 다이얼로그 닫고 바로 멤버 초대 화면으로 이동
                print('[CreateGroup] 그룹 생성 성공 (ID: $groupId)');
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  builder: (context) => InviteMemberDialog(
                    groupId: groupId,
                    groupName: groupName,
                  ),
                );
              } else if (context.mounted) {
                // 에러 발생 시 메시지 표시
                final error = ref.read(groupStateProvider).error;
                print('[CreateGroup] 그룹 생성 실패: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error ?? '그룹 생성에 실패했습니다')),
                );
              }
            },
            child: const Text('생성'),
          ),
      ],
    );
  }
}
