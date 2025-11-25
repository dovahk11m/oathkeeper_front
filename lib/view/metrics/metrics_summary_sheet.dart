import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/metrics/group_metrics_provider.dart';
import '../../domain/plans/plan_list_provider.dart';
import 'widgets/group_stats_tab.dart';
import 'widgets/individual_summary_sheet.dart';
import 'widgets/plan_list_tab.dart';

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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 약속 목록 조회
  void _loadPlanList() {
    if (widget.groupId <= 0) return;
    ref.read(planListProvider.notifier).fetchGroupPlans(widget.groupId);
  }

  // 그룹 통계 조회
  void _loadGroupStats() {
    if (widget.groupId <= 0) return;
    ref.read(groupMetricsProvider.notifier).fetchGroupSummary(widget.groupId);
  }

  // 개별 약속 요약 바텀시트 표시
  void _showIndividualSummarySheet(int planId, String planTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => IndividualSummarySheet(
        planId: planId,
        planTitle: planTitle,
      ),
    );
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
                  Tab(text: '그룹 통계', icon: Icon(Icons.analytics)),
                  Tab(text: '약속 목록', icon: Icon(Icons.list)),
                ],
                onTap: (index) {
                  if (index == 0) {
                    _loadGroupStats();
                  } else if (index == 1) {
                    _loadPlanList();
                  }
                },
              ),

              // 탭 내용
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const GroupStatsTab(),
                    PlanListTab(
                      onPlanTap: _showIndividualSummarySheet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
