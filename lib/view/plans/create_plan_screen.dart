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

  // 입력 데이터
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedGroupId;
  List<int> _selectedMemberIds = [];
  Place? _selectedPlace;
  int? _tempPlanId; // Step3 완료 후 생성된 임시 약속 ID

  // 추가
  RecommendPlace? _recommendPlace;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppDesign.animationNormal,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      _animController.forward(from: 0.0);

      // Step3(참가자 선택) 완료와 PlanId가 없다면? → 임시 약속 생성
      if (_currentStep == 3 && _tempPlanId == null) {
        _createTempPlan();
      }
    } else if (_currentStep == 4) {
      _loadPlacesByTags();
    }
  }

  Future<void> _createTempPlan() async {
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
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

    try {
      final plan =
          await ref.read(planProvider.notifier).createPlanWithParticipants(
                title: _titleController.text,
                planDatetime: planDatetime,
                participantIds:
                    _selectedMemberIds.isNotEmpty ? _selectedMemberIds : null,
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
      body: Column(
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
        );
      case 4:
        return _Step5SelectPlace(
          key: const ValueKey(4),
          selectedPlace: _selectedPlace,
          onPlaceSelected: (place) => setState(() => _selectedPlace = place),
          recommendPlace: _recommendPlace,
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
              onPressed: _currentStep == 4 ? _createPlan : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesign.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                ),
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
  final List<int> selectedMemberIds;
  final ValueChanged<int?> onGroupSelected;
  final ValueChanged<List<int>> onMembersSelected;

  const _Step3Participants({
    super.key,
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
  int? _currentMemberId;

  @override
  void initState() {
    super.initState();
    _loadCurrentMember();
  }

  Future<void> _loadCurrentMember() async {
    final auth = ref.read(authProvider).auth;
    if (auth != null) {
      setState(() => _currentMemberId = auth.id);
    }
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
                  .where((m) => m.memberId != _currentMemberId)
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

  const _Step4PlaceSearch({
    super.key,
    required this.planId,
    required this.selectedPlace,
    required this.onPlaceSelected,
  });

  @override
  ConsumerState<_Step4PlaceSearch> createState() => _Step4PlaceSearchState();
}

class _Step4PlaceSearchState extends ConsumerState<_Step4PlaceSearch> {
  final _searchController = TextEditingController();
  bool _isSearchingByName = false;
  List<String> _suggestions = [];
  List<String> _selectedTags = [];
  late RecommendPlace? _places;
  bool _isLoading = false;

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

  Future<void> _loadPlacesByTags() async {
    if (_selectedTags.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      print('[Step4] 태그 검색: $_selectedTags, planId: ${widget.planId}');
      final places = await ref.read(placeRepositoryProvider).recommendByTags(
            planId: widget.planId ?? 0,
            tags: _selectedTags,
          );
      setState(() {
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      print('[Step4] 태그 검색 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  void _addTag(String tag) {
    if (!_selectedTags.contains(tag)) {
      setState(() => _selectedTags.add(tag));
    }
    _searchController.clear();
    setState(() => _suggestions = []);
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
      if (_selectedTags.isEmpty) {
        _places = null;
      }
    });
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
                    _selectedTags = [];
                    _places = null;
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
        if (!_isSearchingByName && _selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags.map((tag) {
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

        // 기본 태그 (태그 모드 & 검색 안 할 때)
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['카페', '맛집', '데이트', '핫플', '힐링', '분위기좋은'].map((tag) {
              return ActionChip(
                label: Text(tag),
                onPressed: () => _addTag(tag),
                backgroundColor: AppDesign.surfaceColor,
                side: const BorderSide(color: AppDesign.dividerColor),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _Step5SelectPlace extends StatefulWidget {
  final Place? selectedPlace;
  final Function(Place) onPlaceSelected;
  final RecommendPlace? recommendPlace; // 추가

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
  late List<Place> _places;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePlaces();
  }

  void _initializePlaces() {
    if (widget.recommendPlace != null) {
      // centerAvgPlace와 equalAvgPlace 모두 포함
      _places = [
        ...widget.recommendPlace!.centerAvgPlace.map((e) => e.destination),
        ...widget.recommendPlace!.equalAvgPlace.map((e) => e.destination),
      ];
    } else {
      _places = [];
    }
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
          '거리 순으로 두 곳을 추려봤어요.',
          style: const TextStyle(
            fontSize: AppDesign.fontSizeBody,
            color: AppDesign.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesign.paddingLarge),
        if (_places.isEmpty) ...[
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
          // map을 사용한 리스트 생성
          ..._places.map((place) {
            final isSelected = widget.selectedPlace?.id == place.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDesign.paddingMedium),
              child: InkWell(
                onTap: () => widget.onPlaceSelected(place),
                borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                child: Container(
                  padding: const EdgeInsets.all(AppDesign.paddingMedium),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppDesign.primaryColor.withValues(alpha: 0.1)
                        : AppDesign.backgroundColor,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                    border: Border.all(
                      color: isSelected
                          ? AppDesign.primaryColor
                          : AppDesign.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // 이미지 표시 부분
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
                      // 장소 정보 (이름, 주소, 태그)
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
                          ], // Column children
                        ), // Column
                      ), // Expanded
                      // 선택되었을 때 체크 아이콘
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppDesign.primaryColor,
                        ),
                    ], // Row children
                  ), // Row
                ), // Container
              ), // InkWell
            ); // Padding
          }).toList(), // _places.map
        ], // else spread
      ], // main Column children
    ); // main Column
  } // build method
}
