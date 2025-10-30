import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
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

    await ref.read(groupStateProvider.notifier).addMembers(widget.groupId, _emails);

    final error = ref.read(groupStateProvider).error;
    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } else {
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

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('멤버 초대'),
          const SizedBox(height: 4),
          Text(
            widget.groupName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이메일 입력
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: '이메일 입력',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _addEmail(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addEmail,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 추가된 이메일 목록
            if (_emails.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '초대할 멤버 (${_emails.length}명)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _emails.length,
                  itemBuilder: (context, index) {
                    final email = _emails[index];
                    return Chip(
                      label: Text(email),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeEmail(email),
                    );
                  },
                ),
              ),
            ] else
              const Text(
                '초대할 멤버의 이메일을 입력하세요',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
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
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          )
        else
          FilledButton(
            onPressed: _inviteMembers,
            child: const Text('초대'),
          ),
      ],
    );
  }
}

