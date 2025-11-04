import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/plans/plan_repository.dart';

class InviteParticipantDialog extends ConsumerStatefulWidget {
  final int planId;
  final String planTitle;

  const InviteParticipantDialog({
    super.key,
    required this.planId,
    required this.planTitle,
  });

  @override
  ConsumerState<InviteParticipantDialog> createState() =>
      _InviteParticipantDialogState();
}

class _InviteParticipantDialogState
    extends ConsumerState<InviteParticipantDialog> {
  final TextEditingController _memberIdController = TextEditingController();
  final List<int> _memberIds = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _memberIdController.dispose();
    super.dispose();
  }

  void _addMemberId() {
    final memberIdText = _memberIdController.text.trim();
    if (memberIdText.isEmpty) return;

    final memberId = int.tryParse(memberIdText);
    if (memberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 멤버 ID를 입력하세요')),
      );
      return;
    }

    if (_memberIds.contains(memberId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 추가된 멤버입니다')),
      );
      return;
    }

    print('[InviteParticipant] 멤버 추가: $memberId');
    setState(() {
      _memberIds.add(memberId);
      _memberIdController.clear();
    });
  }

  void _removeMemberId(int memberId) {
    setState(() {
      _memberIds.remove(memberId);
    });
  }

  Future<void> _inviteParticipants() async {
    if (_memberIds.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print('[InviteParticipant] 참가자 초대 시작: 약속 ${widget.planId}');

    try {
      final repository = ref.read(planRepositoryProvider);
      await Future.wait(
        _memberIds.map((memberId) =>
            repository.addParticipant(planId: widget.planId, memberId: memberId)),
      );

      print('[InviteParticipant] 참가자 초대 성공');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('참가자 초대 완료')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('[InviteParticipant] 참가자 초대 실패: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('참가자 초대'),
          const SizedBox(height: 4),
          Text(
            widget.planTitle,
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _memberIdController,
                    decoration: const InputDecoration(
                      hintText: '멤버 ID 입력',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _addMemberId(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addMemberId,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_memberIds.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '초대할 참가자 (${_memberIds.length}명)',
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
                  itemCount: _memberIds.length,
                  itemBuilder: (context, index) {
                    final memberId = _memberIds[index];
                    return Chip(
                      label: Text('멤버 ID: $memberId'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeMemberId(memberId),
                    );
                  },
                ),
              ),
            ] else
              const Text(
                '초대할 참가자의 ID를 입력하세요\n(나중에 추가 가능)',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_memberIds.isEmpty ? '건너뛰기' : '취소'),
        ),
        if (_isLoading)
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
            onPressed: _inviteParticipants,
            child: const Text('초대'),
          ),
      ],
    );
  }
}

