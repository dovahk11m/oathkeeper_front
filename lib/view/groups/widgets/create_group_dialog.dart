import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + 타이틀
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDesign.spacing12),
                  decoration: BoxDecoration(
                    color: AppDesign.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.group_add_rounded,
                    color: AppDesign.primaryColor,
                    size: AppDesign.iconLarge,
                  ),
                ),
                const SizedBox(width: AppDesign.spacing16),
                const Expanded(
                  child: Text(
                    '새 채팅방',
                    style: TextStyle(
                      fontSize: AppDesign.fontSizeHeading,
                      fontWeight: FontWeight.w700,
                      color: AppDesign.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spacing24),
            // 입력 필드
            TextField(
              controller: _groupNameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: '채팅방 이름',
                hintText: '채팅방 이름을 입력하세요',
                hintStyle: const TextStyle(color: AppDesign.textTertiary),
                filled: true,
                fillColor: AppDesign.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                  borderSide: BorderSide(color: AppDesign.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                  borderSide: const BorderSide(color: AppDesign.primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacing16,
                  vertical: AppDesign.spacing16,
                ),
              ),
            ),
            const SizedBox(height: AppDesign.spacing24),
            // 버튼들
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppDesign.spacing12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: AppDesign.spacing12),
                Expanded(
                  child: groupState.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : ElevatedButton(
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
                              final error = ref.read(groupStateProvider).error;
                              print('[CreateGroup] 그룹 생성 실패: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error ?? '그룹 생성에 실패했습니다')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppDesign.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: AppDesign.spacing12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                            ),
                          ),
                          child: const Text('생성'),
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
