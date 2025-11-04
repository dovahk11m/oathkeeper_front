import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/domain/groups/group_summary.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';

class CreatePlanDialog extends ConsumerStatefulWidget {
  final int? groupId;

  const CreatePlanDialog({super.key, this.groupId});

  @override
  ConsumerState<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends ConsumerState<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _lateFineController = TextEditingController();
  DateTime? _selectedDateTime;
  GroupSummary? _selectedGroup;
  List<Map<String, dynamic>> _groupMembers = [];
  Set<int> _selectedMemberIds = {};
  bool _isLoadingMembers = false;

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {
      Future.microtask(() => _loadGroupMembers(widget.groupId!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _lateFineController.dispose();
    super.dispose();
  }

  Future<void> _loadGroupMembers(int groupId) async {
    setState(() {
      _isLoadingMembers = true;
      _groupMembers = [];
      _selectedMemberIds.clear();
    });

    try {
      final members = await ref.read(groupStateProvider.notifier).getMembers(groupId);
      setState(() {
        _groupMembers = members;
        _isLoadingMembers = false;
      });
    } catch (e) {
      print('[CreatePlan] 멤버 조회 실패: $e');
      setState(() {
        _isLoadingMembers = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('멤버 조회 실패: $e')),
        );
      }
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _createPlan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약속 시간을 선택하세요')),
      );
      return;
    }

    final title = _titleController.text.trim();
    final location = _locationController.text.trim();
    final lateFineText = _lateFineController.text.trim();
    final lateFine = lateFineText.isEmpty ? null : int.tryParse(lateFineText);

    print('[CreatePlan] 약속 생성 시도: $title');
    print('[CreatePlan] 선택된 참가자: $_selectedMemberIds');

    final plan = await ref.read(planProvider.notifier).createPlanWithParticipants(
          title: title,
          planDatetime: _selectedDateTime!,
          location: location.isEmpty ? null : location,
          lateFineAmount: lateFine,
          participantIds: _selectedMemberIds.isEmpty ? null : _selectedMemberIds.toList(),
        );

    if (plan != null && mounted) {
      print('[CreatePlan] 약속 생성 성공 (ID: ${plan.id})');
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약속이 생성되었습니다')),
      );
    } else if (mounted) {
      final error = ref.read(planProvider).error;
      print('[CreatePlan] 약속 생성 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? '약속 생성에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planProvider);
    final groupsAsync = ref.watch(groupsProvider);

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
                    Icons.event_rounded,
                    color: AppDesign.primaryColor,
                    size: AppDesign.iconLarge,
                  ),
                ),
                const SizedBox(width: AppDesign.spacing16),
                const Expanded(
                  child: Text(
                    '새 약속',
                    style: TextStyle(
                      fontSize: AppDesign.fontSizeHeading,
                      fontWeight: FontWeight.w700,
                      color: AppDesign.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spacing20),
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: '약속 제목',
                    hintText: '예: 강남역 저녁 모임',
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
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '약속 제목을 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDesign.spacing16),
                InkWell(
                  onTap: _selectDateTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '약속 시간',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedDateTime == null
                          ? '날짜와 시간 선택'
                          : '${_selectedDateTime!.year}년 ${_selectedDateTime!.month}월 ${_selectedDateTime!.day}일 ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: '장소 (선택)',
                    hintText: '예: 강남역 2번 출구',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lateFineController,
                  decoration: const InputDecoration(
                    labelText: '지각 벌금 (선택)',
                    hintText: '예: 5000',
                    border: OutlineInputBorder(),
                    suffixText: '원',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  '참가자 선택 (선택)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (widget.groupId == null)
                  groupsAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('그룹 조회 실패: $err'),
                    data: (groups) {
                      if (groups.isEmpty) {
                        return const Text('채팅방이 없습니다');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<GroupSummary>(
                            key: ValueKey(_selectedGroup?.groupId),
                            decoration: const InputDecoration(
                              labelText: '채팅방 선택',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: _selectedGroup,
                            items: groups.map((group) {
                              return DropdownMenuItem(
                                value: group,
                                child: Text(group.groupName),
                              );
                            }).toList(),
                            onChanged: (group) {
                              setState(() {
                                _selectedGroup = group;
                              });
                              if (group != null) {
                                _loadGroupMembers(group.groupId);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                if (_isLoadingMembers)
                  const Center(child: CircularProgressIndicator())
                else if (_groupMembers.isNotEmpty) ...[
                  const Text('멤버 선택:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Builder(
                      builder: (context) {
                        final currentUserId = ref.watch(authProvider).auth?.id;
                        final filteredMembers = _groupMembers.where((m) => m['memberId'] != currentUserId).toList();

                        if (filteredMembers.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              '초대할 수 있는 멤버가 없습니다',
                              style: TextStyle(color: AppDesign.textSecondary),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            final memberId = member['memberId'] as int;
                            final nickname = (member['nickname'] ?? member['username'] ?? '이름 없음') as String;
                            final email = (member['email'] ?? '') as String;

                            return CheckboxListTile(
                              title: Text(nickname),
                              subtitle: email.isNotEmpty ? Text(email) : null,
                              value: _selectedMemberIds.contains(memberId),
                              onChanged: (selected) {
                                setState(() {
                                  if (selected == true) {
                                    _selectedMemberIds.add(memberId);
                                  } else {
                                    _selectedMemberIds.remove(memberId);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text('선택된 참가자: ${_selectedMemberIds.length}명'),
                ],
              ],
            ),
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
                  child: planState.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _createPlan,
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

