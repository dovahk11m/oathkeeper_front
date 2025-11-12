// [수정된] lib/view/plans/create_plan_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/groups/group_member.dart';
import 'package:oath_client/domain/groups/group_provider.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/domain/places/place.dart';
import 'package:oath_client/domain/places/place_repository.dart';
import 'package:oath_client/domain/places/recommend_place/recommend_place.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';
import 'package:intl/intl.dart';

/// 약속 생성 화면 (전체 화면)
class CreatePlanScreen extends ConsumerStatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  ConsumerState<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends ConsumerState<CreatePlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  // 단계
  int _currentStep = 0;
  bool _isLoading = false; // [추가] 로딩 상태

  // 입력 데이터
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedGroupId;
  List<int> _selectedMemberIds = [];
  Place? _selectedPlace;
  int? _tempPlanId; // Step3 완료 후 생성된 임시 약속 ID
  int? _currentMemberId;

  // [추가] 장소 추천 관련
  List<String> _selectedTags = [];
  RecommendPlace? _recommendPlace;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppDesign.animationNormal,
    );
    _loadCurrentMember();
  }

  Future<void> _loadCurrentMember() async {
    final auth = ref.read(authProvider).auth;
    if (auth != null) {
      setState(() => _currentMemberId = auth.id);
      print('[CreatePlan] 현재 멤버 ID 로드: $_currentMemberId');
    } else {
      print('[CreatePlan] 현재 멤버 ID 로드 실패');
      // 에러 처리 (예: 이전 화면으로 튕기기)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자 정보를 불러오는데 실패했습니다')),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // [수정] _Step4 (장소 추천) 관련 로직 추가
  Future<void> _loadPlacesByTags() async {
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추천을 받으려면 태그를 1개 이상 선택하세요')),
      );
      return;
    }
    if (_tempPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약속 정보가 준비되지 않았습니다')),
      );
      return;
    }

    setState(() => _isLoading = true);
    print('[CreatePlan] 태그 검색 시작: $_selectedTags, planId: $_tempPlanId');

    try {
      final places = await ref.read(placeRepositoryProvider).recommendByTags(
            planId: _tempPlanId!,
            tags: _selectedTags,
          );
      setState(() {
        _recommendPlace = places; // 결과 저장
        _isLoading = false;
        _currentStep++; // [수정] 로딩 완료 후 다음 단계로 이동
        _animController.forward(from: 0.0);
      });
      print('[CreatePlan] 태그 검색 완료');
    } catch (e) {
      print('[CreatePlan] 태그 검색 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('장소 추천 실패: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  // [수정] _nextStep 로직 변경
  Future<void> _nextStep() async {
    // 3단계 (장소 태그 선택) -> 4단계 (장소 추천 결과)
    if (_currentStep == 3) {
      await _loadPlacesByTags(); // [수정] API 호출 로직 실행
    }
    // 그 외 단계
    else if (_currentStep < 4) {
      setState(() => _currentStep++);
      _animController.forward(from: 0.0);

      // Step3(참가자 선택) 완료와 PlanId가 없다면? → 임시 약속 생성
      if (_currentStep == 3 && _tempPlanId == null) {
        _createTempPlan();
      }
    }
    // 4단계 (장소 추천 결과) -> 5단계 (약속 생성)
    // 이 로직은 하단 버튼 로직 변경으로 인해 사실상 사용되지 않음
    // _currentStep == 4 일때는 _createPlan이 호출됨
  }

  Future<void> _createTempPlan() async {
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _currentMemberId == null) {
      print('[CreatePlan] 임시 약속 생성 정보 부족');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('약속 정보가 불완전합니다')),
        );
      }
      return;
    }

    print('[CreatePlan] 임시 약속 생성 시작');
    final planDatetime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final selectedParticipants = List<int>.from(_selectedMemberIds);
    if (!selectedParticipants.contains(_currentMemberId!)) {
      selectedParticipants.add(_currentMemberId!);
      print('[CreatePlan] 본인(${_currentMemberId!})을 참가자에 추가');
    }

    try {
      final plan =
          await ref.read(planProvider.notifier).createPlanWithParticipants(
                title: _titleController.text,
                planDatetime: planDatetime,
                participantIds: selectedParticipants,
              );

      if (plan != null) {
        setState(() => _tempPlanId = plan.id);
        print('[CreatePlan] 임시 약속 생성 완료: ${plan.id}');
      } else {
        print('[CreatePlan] 임시 약속 생성 실패');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('약속 생성에 실패했습니다')),
          );
        }
      }
    } catch (e) {
      print('[CreatePlan] 임시 약속 생성 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _createPlan() async {
    // 이미 임시 약속이 생성되어 있으므로, 장소만 확정
    if (_tempPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약속 정보가 없습니다')),
      );
      return;
    }

    print('[CreatePlan] 장소 확정 시작');
    print('[CreatePlan] 플랜 ID: $_tempPlanId');
    print('[CreatePlan] 선택 장소: ${_selectedPlace?.name}');

    if (_selectedPlace != null && context.mounted) {
      try {
        await ref.read(planProvider.notifier).confirmPlace(
              planId: _tempPlanId!,
              location: _selectedPlace!.name,
              latitude: _selectedPlace!.lat,
              longitude: _selectedPlace!.lng,
            );
        print('[CreatePlan] 장소 확정 완료');
      } catch (e) {
        print('[CreatePlan] 장소 확정 실패: $e');
      }
    } else {
      print('[CreatePlan] 장소 선택 없이 완료');
      // 장소 없어도 목록은 갱신
      await ref.read(planProvider.notifier).loadPlans();
    }

    // 약속 목록 갱신 대기 (UI 반영 보장)
    print('[CreatePlan] 약속 목록 갱신 대기 중...');
    await Future.delayed(const Duration(milliseconds: 300));
    print('[CreatePlan] 약속 목록 갱신 완료');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약속이 생성되었습니다')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppDesign.backgroundColor,
        elevation: AppDesign.elevationSmall,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '새 약속 만들기',
          style: TextStyle(
            fontSize: AppDesign.fontSizeHeading,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // [수정] 로딩 UI 추가
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppDesign.paddingMedium),
                  Text(
                    '장소를 추천받고 있습니다...',
                    style: TextStyle(color: AppDesign.textSecondary),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildProgressIndicator(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDesign.paddingMedium),
                    child: _buildCurrentStep(),
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.paddingMedium,
        vertical: AppDesign.paddingSmall,
      ),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
              decoration: BoxDecoration(
                color:
                    isActive ? AppDesign.primaryColor : AppDesign.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    return AnimatedSwitcher(
      duration: AppDesign.animationNormal,
      child: _getStepWidget(),
    );
  }

  Widget _getStepWidget() {
    switch (_currentStep) {
      case 0:
        return _Step1Title(
          key: const ValueKey(0),
          controller: _titleController,
          onNext: _nextStep,
        );
      case 1:
        return _Step2DateTime(
          key: const ValueKey(1),
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          onDateChanged: (date) => setState(() => _selectedDate = date),
          onTimeChanged: (time) => setState(() => _selectedTime = time),
        );
      case 2:
        return _Step3Participants(
          key: const ValueKey(2),
          currentMemberId: _currentMemberId,
          selectedGroupId: _selectedGroupId,
          selectedMemberIds: _selectedMemberIds,
          onGroupSelected: (id) => setState(() => _selectedGroupId = id),
          onMembersSelected: (ids) => setState(() => _selectedMemberIds = ids),
        );
      case 3:
        return _Step4PlaceSearch(
          key: const ValueKey(3),
          planId: _tempPlanId,
          selectedPlace: _selectedPlace,
          onPlaceSelected: (place) => setState(() => _selectedPlace = place),
          // [추가]
          selectedTags: _selectedTags,
          onTagsChanged: (tags) => setState(() => _selectedTags = tags),
        );
      case 4:
        return _Step5SelectPlace(
          key: const ValueKey(4),
          selectedPlace: _selectedPlace,
          onPlaceSelected: (place) => setState(() => _selectedPlace = place),
          recommendPlace: _recommendPlace, // [수정]
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.only(
        left: AppDesign.paddingMedium,
        right: AppDesign.paddingMedium,
        top: AppDesign.paddingMedium,
        bottom: MediaQuery.of(context).padding.bottom + AppDesign.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppDesign.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppDesign.dividerColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                  ),
                ),
                child: const Text('이전'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: AppDesign.paddingMedium),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              // [수정]
              onPressed: _isLoading
                  ? null // 로딩 중 비활성화
                  : (_currentStep == 4 ? _createPlan : _nextStep),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesign.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                ),
                disabledBackgroundColor: AppDesign.dividerColor, // [추가]
              ),
              child: Text(_currentStep == 4
                  ? '약속 만들기'
                  : _currentStep == 3
                      ? '장소 추천 받기'
                      : '다음'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ Step 1: 제목 입력 ============
class _Step1Title extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;

  const _Step1Title({
    super.key,
    required this.controller,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '약속 이름을 정해주세요',
          style: TextStyle(
            fontSize: AppDesign.fontSizeLarge,
            fontWeight: FontWeight.w700,
            color: AppDesign.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.paddingLarge),
        TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '예: 홍대 카페 모임',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
            ),
            filled: true,
            fillColor: AppDesign.backgroundColor,
          ),
          onSubmitted: (_) => onNext(),
        ),
      ],
    );
  }
}

// ============ Step 2: 날짜/시간 선택 ============
class _Step2DateTime extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _Step2DateTime({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '언제 만날까요?',
          style: TextStyle(
            fontSize: AppDesign.fontSizeLarge,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDesign.paddingLarge),
        _buildDateButton(context),
        const SizedBox(height: AppDesign.paddingMedium),
        _buildTimeButton(context),
      ],
    );
  }

  Widget _buildDateButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) onDateChanged(date);
      },
      borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppDesign.paddingMedium),
        decoration: BoxDecoration(
          color: AppDesign.backgroundColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
          border: Border.all(color: AppDesign.dividerColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppDesign.primaryColor),
            const SizedBox(width: AppDesign.paddingMedium),
            Text(
              selectedDate != null
                  ? DateFormat('yyyy년 M월 d일').format(selectedDate!)
                  : '날짜 선택',
              style: TextStyle(
                fontSize: AppDesign.fontSizeBody,
                color: selectedDate != null
                    ? AppDesign.textPrimary
                    : AppDesign.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (time != null) onTimeChanged(time);
      },
      borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppDesign.paddingMedium),
        decoration: BoxDecoration(
          color: AppDesign.backgroundColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
          border: Border.all(color: AppDesign.dividerColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppDesign.primaryColor),
            const SizedBox(width: AppDesign.paddingMedium),
            Text(
              selectedTime != null
                  ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                  : '시간 선택',
              style: TextStyle(
                fontSize: AppDesign.fontSizeBody,
                color: selectedTime != null
                    ? AppDesign.textPrimary
                    : AppDesign.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ Step 3: 참가자 선택 ============
class _Step3Participants extends ConsumerStatefulWidget {
  final int? selectedGroupId;
  final int? currentMemberId;
  final List<int> selectedMemberIds;
  final ValueChanged<int?> onGroupSelected;
  final ValueChanged<List<int>> onMembersSelected;

  const _Step3Participants({
    super.key,
    required this.currentMemberId,
    required this.selectedGroupId,
    required this.selectedMemberIds,
    required this.onGroupSelected,
    required this.onMembersSelected,
  });

  @override
  ConsumerState<_Step3Participants> createState() => _Step3ParticipantsState();
}

class _Step3ParticipantsState extends ConsumerState<_Step3Participants> {
  List<GroupMember> _groupMembers = [];
  bool _isLoadingMembers = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadGroupMembers(int groupId) async {
    setState(() => _isLoadingMembers = true);
    try {
      final members =
          await ref.read(groupStateProvider.notifier).getMembers(groupId);
      setState(() {
        _groupMembers = members;
        _isLoadingMembers = false;
      });
    } catch (e) {
      print('[Step3] 멤버 로드 실패: $e');
      setState(() => _isLoadingMembers = false);
    }
  }

  void _toggleMember(int memberId) {
    final newList = List<int>.from(widget.selectedMemberIds);
    if (newList.contains(memberId)) {
      newList.remove(memberId);
    } else {
      newList.add(memberId);
    }
    widget.onMembersSelected(newList);
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '누구와 함께할까요?',
          style: TextStyle(
            fontSize: AppDesign.fontSizeLarge,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDesign.paddingLarge),

        // 1. 그룹 선택
        const Text(
          '채팅방 선택',
          style: TextStyle(
            fontSize: AppDesign.fontSizeBody,
            fontWeight: FontWeight.w600,
            color: AppDesign.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesign.paddingSmall),
        groupsAsync.when(
          data: (groups) {
            if (groups.isEmpty) {
              return const Text(
                '채팅방이 없습니다.\n채팅 탭에서 그룹을 만들어보세요.',
                style: TextStyle(color: AppDesign.textSecondary),
              );
            }
            return Column(
              children: groups.map((group) {
                final isSelected = widget.selectedGroupId == group.groupId;
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDesign.paddingSmall),
                  child: InkWell(
                    onTap: () {
                      final newGroupId = isSelected ? null : group.groupId;
                      widget.onGroupSelected(newGroupId);
                      if (newGroupId != null) {
                        _loadGroupMembers(newGroupId);
                      } else {
                        setState(() => _groupMembers = []);
                        widget.onMembersSelected([]);
                      }
                    },
                    borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                    child: Container(
                      padding: const EdgeInsets.all(AppDesign.paddingMedium),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppDesign.primaryColor.withValues(alpha: 0.1)
                            : AppDesign.backgroundColor,
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusMedium),
                        border: Border.all(
                          color: isSelected
                              ? AppDesign.primaryColor
                              : AppDesign.dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected
                                ? AppDesign.primaryColor
                                : AppDesign.textSecondary,
                          ),
                          const SizedBox(width: AppDesign.paddingMedium),
                          Expanded(
                            child: Text(
                              group.groupName,
                              style: TextStyle(
                                fontSize: AppDesign.fontSizeBody,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: AppDesign.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('오류: $e'),
        ),

        // 2. 멤버 선택
        if (widget.selectedGroupId != null) ...[
          const SizedBox(height: AppDesign.paddingLarge),
          const Text(
            '참가자 선택',
            style: TextStyle(
              fontSize: AppDesign.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: AppDesign.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.paddingSmall),
          if (_isLoadingMembers)
            const Center(child: CircularProgressIndicator())
          else if (_groupMembers.isEmpty)
            const Text(
              '멤버를 불러올 수 없습니다',
              style: TextStyle(color: AppDesign.textSecondary),
            )
          else
            Column(
              children: _groupMembers
                  .where((m) => m.memberId != widget.currentMemberId)
                  .map((member) {
                final isSelected =
                    widget.selectedMemberIds.contains(member.memberId);
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDesign.paddingSmall),
                  child: InkWell(
                    onTap: () => _toggleMember(member.memberId),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSmall),
                    child: Container(
                      padding: const EdgeInsets.all(AppDesign.paddingSmall),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppDesign.primaryColor.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusSmall),
                        border: Border.all(
                          color: isSelected
                              ? AppDesign.primaryColor
                              : AppDesign.dividerColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleMember(member.memberId),
                            activeColor: AppDesign.primaryColor,
                          ),
                          const SizedBox(width: AppDesign.paddingSmall),
                          if (member.profileImageUrl != null)
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(member.profileImageUrl!),
                            )
                          else
                            const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.person),
                            ),
                          const SizedBox(width: AppDesign.paddingSmall),
                          Expanded(
                            child: Text(
                              member.username,
                              style: TextStyle(
                                fontSize: AppDesign.fontSizeBody,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ],
    );
  }
}

// ============ Step 4: 장소 검색 (태그 또는 이름) ============
class _Step4PlaceSearch extends ConsumerStatefulWidget {
  final int? planId;
  final Place? selectedPlace;
  final ValueChanged<Place> onPlaceSelected;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  const _Step4PlaceSearch({
    super.key,
    required this.planId,
    required this.selectedPlace,
    required this.onPlaceSelected,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  ConsumerState<_Step4PlaceSearch> createState() => _Step4PlaceSearchState();
}

class _Step4PlaceSearchState extends ConsumerState<_Step4PlaceSearch> {
  final _searchController = TextEditingController();
  bool _isSearchingByName = false;
  List<String> _suggestions = [];

  // [추가] 서버에서 태그 목록을 받아올 Future
  Future<List<String>>? _popularTagsFuture;

  @override
  void initState() {
    super.initState();
    // [추가] 위젯이 로드될 때 '인기 태그' 목록을 서버에서 불러옴
    _loadPopularTags();
  }

  // [추가] 서버에서 태그 목록을 불러오는 함수
  Future<void> _loadPopularTags() async {
    // 기존 autocompleteTag 함수를 prefix="" 로 호출해서 태그 목록을 가져옴
    setState(() {
      _popularTagsFuture =
          ref.read(placeRepositoryProvider).autocompleteTag("");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    if (_isSearchingByName) {
      final names =
          await ref.read(placeRepositoryProvider).autocompleteName(query);
      setState(() => _suggestions = names);
    } else {
      final tags =
          await ref.read(placeRepositoryProvider).autocompleteTag(query);
      setState(() => _suggestions = tags);
    }
  }

  void _addTag(String tag) {
    final newList = List<String>.from(widget.selectedTags);
    if (!newList.contains(tag)) {
      newList.add(tag);
      widget.onTagsChanged(newList);
    }
    _searchController.clear();
    setState(() => _suggestions = []);
  }

  void _removeTag(String tag) {
    final newList = List<String>.from(widget.selectedTags);
    newList.remove(tag);
    widget.onTagsChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    // planId가 아직 생성되지 않았으면 로딩 표시
    if (widget.planId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppDesign.paddingMedium),
            Text(
              '약속을 준비하고 있습니다...',
              style: TextStyle(color: AppDesign.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 장소를 찾고 있나요?',
          style: TextStyle(
            fontSize: AppDesign.fontSizeLarge,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDesign.paddingMedium),
        Text(
          _isSearchingByName ? '장소 이름으로 직접 검색하세요' : '태그를 선택하고 장소 추천을 받아보세요',
          style: const TextStyle(
            fontSize: AppDesign.fontSizeBody,
            color: AppDesign.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesign.paddingLarge),
        // 검색 모드 토글
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isSearchingByName = false;
                    _searchController.clear();
                    _suggestions = [];
                  });
                },
                icon: Icon(
                  Icons.tag,
                  color: !_isSearchingByName
                      ? AppDesign.primaryColor
                      : AppDesign.textSecondary,
                ),
                label: Text('태그 검색'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: !_isSearchingByName
                      ? AppDesign.primaryColor.withValues(alpha: 0.1)
                      : null,
                  side: BorderSide(
                    color: !_isSearchingByName
                        ? AppDesign.primaryColor
                        : AppDesign.dividerColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDesign.paddingSmall),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isSearchingByName = true;
                    _searchController.clear();
                    _suggestions = [];
                    widget.onTagsChanged([]);
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: _isSearchingByName
                      ? AppDesign.primaryColor
                      : AppDesign.textSecondary,
                ),
                label: Text('장소 검색'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _isSearchingByName
                      ? AppDesign.primaryColor.withValues(alpha: 0.1)
                      : null,
                  side: BorderSide(
                    color: _isSearchingByName
                        ? AppDesign.primaryColor
                        : AppDesign.dividerColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesign.paddingMedium),

        // 선택된 태그 (태그 모드일 때만)
        if (!_isSearchingByName && widget.selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeTag(tag),
                backgroundColor: AppDesign.primaryColor.withValues(alpha: 0.1),
                side: const BorderSide(color: AppDesign.primaryColor),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDesign.paddingMedium),
        ],

        // 검색 입력
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: _isSearchingByName
                ? '장소 이름 입력 (예: 스타벅스 홍대점)'
                : '태그 검색 (예: 카페, 맛집)',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
            ),
            filled: true,
            fillColor: AppDesign.backgroundColor,
          ),
          onChanged: _onSearchChanged,
        ),

        // 자동완성 제안
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: AppDesign.paddingMedium),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: AppDesign.backgroundColor,
              borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
              border: Border.all(color: AppDesign.dividerColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  leading: Icon(
                    _isSearchingByName ? Icons.place : Icons.tag,
                    color: AppDesign.primaryColor,
                  ),
                  title: Text(suggestion),
                  onTap: () {
                    if (_isSearchingByName) {
                      _searchController.text = suggestion;
                      setState(() => _suggestions = []);
                    } else {
                      _addTag(suggestion);
                    }
                  },
                );
              },
            ),
          ),
        ],

        // [수정] 기본 태그 -> FutureBuilder로 변경
        if (!_isSearchingByName &&
            _searchController.text.isEmpty &&
            _suggestions.isEmpty) ...[
          const SizedBox(height: AppDesign.paddingMedium),
          const Text(
            '인기 태그',
            style: TextStyle(
              fontSize: AppDesign.fontSizeCaption,
              color: AppDesign.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // 서버에서 태그 목록을 로드해서 보여주는 FutureBuilder
          FutureBuilder<List<String>>(
            future: _popularTagsFuture,
            builder: (context, snapshot) {
              // 1. 로딩 중
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2));
              }
              // 2. 에러 발생
              if (snapshot.hasError) {
                return const Text(
                  '태그를 불러오는데 실패했습니다.',
                  style: TextStyle(color: AppDesign.textSecondary),
                );
              }
              // 3. 데이터 없음
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                  '표시할 태그가 없습니다.',
                  style: TextStyle(color: AppDesign.textSecondary),
                );
              }

              // 4. 성공!
              final tags = snapshot.data!;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return ActionChip(
                    label: Text(tag),
                    onPressed: () => _addTag(tag),
                    backgroundColor: AppDesign.surfaceColor,
                    side: const BorderSide(color: AppDesign.dividerColor),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _Step5SelectPlace extends StatefulWidget {
  final Place? selectedPlace;
  final Function(Place) onPlaceSelected;
  final RecommendPlace? recommendPlace;

  const _Step5SelectPlace({
    super.key,
    required this.selectedPlace,
    required this.onPlaceSelected,
    required this.recommendPlace,
  });

  @override
  State<_Step5SelectPlace> createState() => __Step5SelectPlaceState();
}

class __Step5SelectPlaceState extends State<_Step5SelectPlace> {
  late List<RecommendPlaceState> _centerPlaceData;
  late List<RecommendPlaceState> _equalPlaceData;
  bool _isDuplicateRecommendation = false; // [추가] A/B 중복 추천 여부

  @override
  void initState() {
    super.initState();
    _initializePlaces();
  }

  void _initializePlaces() {
    _centerPlaceData = widget.recommendPlace?.centerAvgPlace ?? [];
    _equalPlaceData = widget.recommendPlace?.equalAvgPlace ?? [];

    // [추가] 중복 추천(A, B가 같은 장소)인지 확인
    if (_centerPlaceData.isNotEmpty && _equalPlaceData.isNotEmpty) {
      final centerPlaceId = _centerPlaceData.first.destination.id;
      final equalPlaceId = _equalPlaceData.first.destination.id;
      if (centerPlaceId == equalPlaceId) {
        setState(() {
          _isDuplicateRecommendation = true;
        });
      }
    }
  }

  // 거리(m)를 km 또는 m로 변환하는 헬퍼
  String _formatDistance(int meters) {
    if (meters >= 1000) {
      double km = meters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
    return '${meters}m';
  }

  // 시간("...s")을 분으로 변환하는 헬퍼
  String _formatDuration(String durationStr) {
    try {
      final secondsStr = durationStr.replaceAll('s', '');
      final seconds = int.parse(secondsStr);
      if (seconds == 0) return '-';
      final minutes = (seconds / 60).ceil();
      return '약 ${minutes}분 (대중교통)';
    } catch (e) {
      print('[FormatError] duration 파싱 실패: $durationStr');
      return '-';
    }
  }

  /// 참가자별 거리/시간을 보여주는 작은 행 위젯
  Widget _buildParticipantRow(RecommendPlaceState data) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.paddingMedium,
        vertical: AppDesign.paddingSmall,
      ),
      child: Row(
        children: [
          const Icon(Icons.person, size: 16, color: AppDesign.textSecondary),
          const SizedBox(width: AppDesign.paddingSmall),
          Text(
            data.participant.memberNickname,
            style: const TextStyle(
              fontSize: AppDesign.fontSizeBody,
              color: AppDesign.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '${_formatDistance(data.distance)} / ${_formatDuration(data.duration)}',
            style: const TextStyle(
              fontSize: AppDesign.fontSizeBody,
              color: AppDesign.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 장소 카드 + 참가자 목록을 포함하는 전체 카드 위젯
  Widget _buildRecommendationCard({
    required String title,
    required List<RecommendPlaceState> placeData,
  }) {
    if (placeData.isEmpty) return const SizedBox.shrink();

    final place = placeData.first.destination;
    final isSelected = widget.selectedPlace?.id == place.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.paddingMedium),
      child: InkWell(
        onTap: () => widget.onPlaceSelected(place),
        borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppDesign.primaryColor.withValues(alpha: 0.1)
                : AppDesign.backgroundColor,
            borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
            border: Border.all(
              color:
                  isSelected ? AppDesign.primaryColor : AppDesign.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 장소 정보 (기존 카드)
              Padding(
                padding: const EdgeInsets.all(AppDesign.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: AppDesign.fontSizeCaption,
                        fontWeight: FontWeight.w600,
                        color: AppDesign.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppDesign.paddingSmall),
                    Row(
                      children: [
                        if (place.imageUrl != null)
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusSmall),
                            child: Image.network(
                              place.imageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: AppDesign.surfaceColor,
                                child: const Icon(Icons.place),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppDesign.surfaceColor,
                              borderRadius:
                                  BorderRadius.circular(AppDesign.radiusSmall),
                            ),
                            child: const Icon(Icons.place,
                                color: AppDesign.textSecondary),
                          ),
                        const SizedBox(width: AppDesign.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: AppDesign.fontSizeBody,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                place.address,
                                style: const TextStyle(
                                  fontSize: AppDesign.fontSizeCaption,
                                  color: AppDesign.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (place.tags.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  children: place.tags.take(3).map((tag) {
                                    return Text(
                                      '#$tag',
                                      style: const TextStyle(
                                        fontSize: AppDesign.fontSizeCaption,
                                        color: AppDesign.primaryColor,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppDesign.primaryColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. 구분선
              const Divider(
                height: 1,
                color: AppDesign.dividerColor,
                indent: AppDesign.paddingMedium,
                endIndent: AppDesign.paddingMedium,
              ),

              // 3. 참가자별 거리/시간 목록
              ...placeData.map((data) => _buildParticipantRow(data)).toList(),

              const SizedBox(height: AppDesign.paddingSmall), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 장소가 마음에 드시나요?',
          style: TextStyle(
            fontSize: AppDesign.fontSizeLarge,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDesign.paddingMedium),
        Text(
          // [수정] 중복 여부에 따라 설명 멘트 변경
          _isDuplicateRecommendation
              ? '참가자 모두에게 최적인 장소를 1곳 추천했어요.'
              : '두 가지 타입의 장소를 추천해봤어요.',
          style: const TextStyle(
            fontSize: AppDesign.fontSizeBody,
            color: AppDesign.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesign.paddingLarge),
        if (_centerPlaceData.isEmpty && _equalPlaceData.isEmpty) ...[
          const Center(
            child: Text('추천 장소가 없습니다.'),
          ),
        ] else ...[
          const Text(
            '추천 장소',
            style: TextStyle(
              fontSize: AppDesign.fontSizeBody,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDesign.paddingSmall),

          // [수정] 중복 추천(A, B가 같은 장소)인 경우
          if (_isDuplicateRecommendation)
            _buildRecommendationCard(
              title: '⭐ 최적의 장소 (중간 지점 + 공평 거리)',
              placeData: _centerPlaceData, // A, B 둘 다 같으므로 A 사용
            )
          // [수정] 중복이 아닌 경우 (A, B가 다른 장소)
          else ...[
            // 카드 1: 중간 지점 추천
            _buildRecommendationCard(
              title: '중간 지점 추천',
              placeData: _centerPlaceData,
            ),

            // 카드 2: 공평 거리 추천
            _buildRecommendationCard(
              title: '공평 거리 추천',
              placeData: _equalPlaceData,
            ),
          ],
        ],
      ],
    );
  }
}
