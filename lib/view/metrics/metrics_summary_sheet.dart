import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../common/utils/http_util.dart';
import '../../domain/groups/group_repository.dart';
import '../../domain/metrics/metrics_provider.dart';
import '../../domain/metrics/metrics_state.dart';
import '../../domain/members/members_repository.dart';
import '../../domain/plans/simple_plan.dart';

class MetricsSummarySheet extends ConsumerStatefulWidget {
  final int groupId;
  final int? initialPlanId;
  final VoidCallback? onTapCreatePlan;

  const MetricsSummarySheet({
    super.key,
    required this.groupId,
    this.initialPlanId,
    this.onTapCreatePlan,
  });

  @override
  ConsumerState<MetricsSummarySheet> createState() =>
      _MetricsSummarySheetState();
}

class _MetricsSummarySheetState extends ConsumerState<MetricsSummarySheet>
    with SingleTickerProviderStateMixin {
  MembersRepository? _membersRepo;
  Map<int, String>? _nameMap;

  late TabController _tabController;
  int _selectedPlanId = 0;
  List<SimplePlan> _planList = [];
  bool _loadingPlanList = false;

  @override
  void initState() {
    super.initState();
    _selectedPlanId = widget.initialPlanId ?? 0;
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 멤버 이름 조회
      final Dio app = ref.read(dioProvider);
      _membersRepo = MembersRepository(app);

      if (_selectedPlanId > 0) {
        try {
          _nameMap = await _membersRepo?.fetchNameMapByPlan(_selectedPlanId);
          if (mounted) setState(() {});
        } catch (_) {}
      }

      if (!mounted) return;

      // 초기 planId가 있으면 폴링 시작
      if (_selectedPlanId > 0) {
        ref.read(metricsProvider.notifier).pollPlanSummary(_selectedPlanId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    ref.read(metricsProvider.notifier).cancelSummaryPolling();
    super.dispose();
  }

  // 약속 목록 조회
  Future<void> _loadPlanList() async {
    if (widget.groupId <= 0) return;

    setState(() => _loadingPlanList = true);

    try {
      final groupRepo = ref.read(groupRepositoryProvider);
      final response = await groupRepo.fetchCompletedPlans(widget.groupId);

      if (mounted) {
        setState(() {
          _planList = response.items;
          _loadingPlanList = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingPlanList = false);
        _toast('약속 목록 조회 실패: $e');
      }
    }
  }

  // 약속 선택 핸들러
  void _onPlanSelected(int planId) async {
    setState(() => _selectedPlanId = planId);

    // 상세보기 탭으로 전환
    _tabController.animateTo(0);

    // 멤버 이름 조회
    try {
      _nameMap = await _membersRepo?.fetchNameMapByPlan(planId);
      if (mounted) setState(() {});
    } catch (_) {}

    // 해당 약속 요약 로딩 시작
    ref.read(metricsProvider.notifier).pollPlanSummary(planId);
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatDateTime(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return datetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Material(
        color: theme.colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              // 제목
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('약속 요약', style: theme.textTheme.titleLarge),
                ),
              ),

              // 탭바
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '상세보기', icon: Icon(Icons.description)),
                  Tab(text: '목록보기', icon: Icon(Icons.list)),
                ],
                onTap: (index) {
                  if (index == 1 && _planList.isEmpty) {
                    // 목록보기 탭 클릭 시 목록 로드
                    _loadPlanList();
                  }
                },
              ),

              // 탭 내용
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailTab(theme),
                    _buildListTab(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 상세보기 탭
  Widget _buildDetailTab(ThemeData theme) {
    final metricsState = ref.watch(metricsProvider);

    Widget content;
    if (_selectedPlanId <= 0) {
      content = _buildNoPlanView(theme);
    } else if (metricsState.summaryStatus == SummaryStatus.failed) {
      // 에러 코드별 분기
      if (metricsState.error?.contains('활성화된 약속') ?? false) {
        content = _buildNoPlanView(theme);
      } else if (metricsState.error?.contains('집계되지') ?? false) {
        content = _buildNotReadyView(theme);
      } else {
        content = _buildErrorCard(theme, metricsState.error ?? '알 수 없는 오류');
      }
    } else if (metricsState.summaryStatus == SummaryStatus.completed) {
      content = _buildSummaryCard(theme, metricsState.summaryText ?? '');
    } else {
      // processing or idle - 로딩 표시
      content = _buildSummaryCard(theme, '');
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 멤버 목록 (있으면)
              if ((_nameMap ?? {}).isNotEmpty) ...[
                Text('참여 멤버', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _nameMap!.entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Chip(
                                  label: Text(e.value),
                                  visualDensity: VisualDensity.compact),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 내용
              content,

              const SizedBox(height: 16),

              // 다시 불러오기 버튼
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      metricsState.isSummaryLoading || _selectedPlanId <= 0
                          ? null
                          : () => ref
                              .read(metricsProvider.notifier)
                              .pollPlanSummary(_selectedPlanId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 불러오기'),
                ),
              ),
            ],
          ),
        ),
        if (metricsState.isSummaryLoading) _buildLoadingOverlay(theme),
      ],
    );
  }

  // 목록보기 탭
  Widget _buildListTab(ThemeData theme) {
    if (_loadingPlanList) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_planList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text('완료된 약속이 없습니다.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('약속을 완료하면 여기에 표시됩니다.',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _planList.length,
      itemBuilder: (context, index) {
        final plan = _planList[index];
        final isSelected = plan.planId == _selectedPlanId;

        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? theme.colorScheme.primaryContainer : null,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              Icons.event_available,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
            title: Text(
              plan.title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(_formatDateTime(plan.planDatetime)),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                : null,
            onTap: () => _onPlanSelected(plan.planId),
          ),
        );
      },
    );
  }

  // 요약 카드
  Widget _buildSummaryCard(ThemeData theme, String text) {
    return Card(
      key: const ValueKey('summary'),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(text.isEmpty ? '텍스트 없음' : text,
            style: theme.textTheme.bodyLarge),
      ),
    );
  }

  // 에러 카드
  Widget _buildErrorCard(ThemeData theme, String errorMessage) {
    return Card(
      key: const ValueKey('error'),
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          errorMessage,
          style: TextStyle(color: theme.colorScheme.onErrorContainer),
        ),
      ),
    );
  }

  // 플랜 없음
  Widget _buildNoPlanView(ThemeData theme) {
    return Card(
      key: const ValueKey('no_plan'),
      color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text('아직 등록된 약속이 없어요.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('바로 약속 잡기로 이동해서 플랜을 만들어 볼까요?',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onTapCreatePlan?.call();
                });
              },
              icon: const Icon(Icons.event_available),
              label: const Text('약속 잡으러 가기'),
            ),
          ],
        ),
      ),
    );
  }

  // 집계 전(메트릭 없음)
  Widget _buildNotReadyView(ThemeData theme) {
    return Card(
      key: const ValueKey('not_ready'),
      color: theme.colorScheme.tertiaryContainer.withOpacity(0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty_rounded,
                size: 42, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text('아직 집계 준비 중이에요.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('실시간 추적을 종료하고 도착 기록이 저장되면 요약을 만들 수 있어요.',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check),
              label: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  // 로딩 오버레이
  Widget _buildLoadingOverlay(ThemeData theme) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.black.withOpacity(0.06),
          alignment: Alignment.center,
          child: Material(
            elevation: 6,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 4)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 180,
                    child: Text('AI가 열심히 요약 중입니다...',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
