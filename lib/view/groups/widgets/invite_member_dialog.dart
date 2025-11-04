import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/groups/group_provider.dart';

/// 그룹 멤버 초대 다이얼로그
class InviteMemberDialog extends ConsumerStatefulWidget {
  final int groupId;
  final String groupName;

  const InviteMemberDialog({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  ConsumerState<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<InviteMemberDialog> {
  final TextEditingController _emailController = TextEditingController();
  final List<String> _emails = [];
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _addEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    // 간단한 이메일 형식 검증
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 이메일 형식이 아닙니다')),
      );
      return;
    }

    if (_emails.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 추가된 이메일입니다')),
      );
      return;
    }

    print('[InviteMember] 이메일 추가: $email');
    setState(() {
      _emails.add(email);
      _emailController.clear();
    });
  }

  void _removeEmail(String email) {
    setState(() {
      _emails.remove(email);
    });
  }

  Future<void> _inviteMembers() async {
    if (_emails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('초대할 멤버를 추가해주세요')),
      );
      return;
    }

    print('[InviteMember] 멤버 초대 시작: 그룹 ${widget.groupId}');
    await ref.read(groupStateProvider.notifier).addMembers(widget.groupId, _emails);

    final error = ref.read(groupStateProvider).error;
    if (error != null) {
      print('[InviteMember] 멤버 초대 실패: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } else {
      print('[InviteMember] 멤버 초대 성공');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('멤버 초대 완료')),
        );
        Navigator.of(context).pop();
      }
    }
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
                    Icons.person_add_rounded,
                    color: AppDesign.primaryColor,
                    size: AppDesign.iconLarge,
                  ),
                ),
                const SizedBox(width: AppDesign.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '멤버 초대',
                        style: TextStyle(
                          fontSize: AppDesign.fontSizeTitle,
                          fontWeight: FontWeight.w700,
                          color: AppDesign.textPrimary,
                        ),
                      ),
                      Text(
                        widget.groupName,
                        style: const TextStyle(
                          fontSize: AppDesign.fontSizeCaption,
                          color: AppDesign.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spacing24),
            // 이메일 입력
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      labelText: '이메일',
                      hintText: 'example@email.com',
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
                        vertical: AppDesign.spacing12,
                      ),
                    ),
                    onSubmitted: (_) => _addEmail(),
                  ),
                ),
                const SizedBox(width: AppDesign.spacing8),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppDesign.primaryColor,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: _addEmail,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spacing20),
            // 추가된 이메일 목록
            if (_emails.isNotEmpty) ...[
              Text(
                '초대할 멤버 (${_emails.length}명)',
                style: const TextStyle(
                  fontSize: AppDesign.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: AppDesign.textPrimary,
                ),
              ),
              const SizedBox(height: AppDesign.spacing12),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: AppDesign.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                ),
                padding: const EdgeInsets.all(AppDesign.spacing8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _emails.length,
                  itemBuilder: (context, index) {
                    final email = _emails[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppDesign.spacing4),
                      child: Chip(
                        label: Text(email),
                        labelStyle: const TextStyle(
                          fontSize: AppDesign.fontSizeBody,
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeEmail(email),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDesign.radiusSmall),
                          side: BorderSide(color: AppDesign.dividerColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else
              Container(
                padding: const EdgeInsets.all(AppDesign.spacing16),
                decoration: BoxDecoration(
                  color: AppDesign.surfaceColor,
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: AppDesign.iconMedium,
                      color: AppDesign.textTertiary,
                    ),
                    const SizedBox(width: AppDesign.spacing8),
                    const Expanded(
                      child: Text(
                        '초대할 멤버의 이메일을 입력하세요',
                        style: TextStyle(
                          color: AppDesign.textSecondary,
                          fontSize: AppDesign.fontSizeBody,
                        ),
                      ),
                    ),
                  ],
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
                    child: const Text('나중에'),
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
                          onPressed: _inviteMembers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppDesign.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: AppDesign.spacing12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                            ),
                          ),
                          child: const Text('초대'),
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
