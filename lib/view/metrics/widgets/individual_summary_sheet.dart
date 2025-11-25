import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/http_util.dart';
import '../../../domain/members/members_repository.dart';
import '../../../domain/metrics/metrics_provider.dart';
import '../../../domain/metrics/metrics_state.dart';

/// 개별 약속 요약 바텀시트
class IndividualSummarySheet extends ConsumerStatefulWidget {
  final int planId;
  final String planTitle;

  const IndividualSummarySheet({
    super.key,
    required this.planId,
    required this.planTitle,
  });

  @override
  ConsumerState<IndividualSummarySheet> createState() =>
      _IndividualSummarySheetState();
}

class _IndividualSummarySheetState
    extends ConsumerState<IndividualSummarySheet> {
  MembersRepository? _membersRepo;
  Map<int, String>? _nameMap;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 멤버 이름 조회
      final Dio app = ref.read(dioProvider);
      _membersRepo = MembersRepository(app);

      try {
        _nameMap = await _membersRepo?.fetchNameMapByPlan(widget.planId);
        if (mounted) setState(() {});
      } catch (_) {}

      if (!mounted) return;

      // 폴링 시작
      ref.read(metricsProvider.notifier).pollPlanSummary(widget.planId);
    });
  }

  @override
  void dispose() {
    ref.read(metricsProvider.notifier).cancelSummaryPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metricsState = ref.watch(metricsProvider);

    Widget content;
    if (metricsState.summaryStatus == SummaryStatus.failed) {
      content = _buildErrorCard(theme, metricsState.error ?? '알 수 없는 오류');
    } else if (metricsState.summaryStatus == SummaryStatus.completed) {
      content = _buildSummaryCard(theme, metricsState.summaryText ?? '');
    } else {
      content = _buildSummaryCard(theme, '');
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Material(
          color: theme.colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Column(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(widget.planTitle,
                            style: theme.textTheme.titleLarge),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // 내용
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 멤버 목록 (있으면)
                            if ((_nameMap ?? {}).isNotEmpty) ...[
                              Text('참여 멤버', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: _nameMap!.entries
                                    .map((e) => Chip(
                                        label: Text(e.value),
                                        visualDensity: VisualDensity.compact))
                                    .toList(),
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
                                onPressed: metricsState.isSummaryLoading
                                    ? null
                                    : () => ref
                                        .read(metricsProvider.notifier)
                                        .pollPlanSummary(widget.planId),
                                icon: const Icon(Icons.refresh),
                                label: const Text('다시 불러오기'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (metricsState.isSummaryLoading)
                        _buildLoadingOverlay(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, String text) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(text.isEmpty ? '로딩 중...' : text,
            style: theme.textTheme.bodyLarge),
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme, String errorMessage) {
    return Card(
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

  Widget _buildLoadingOverlay(ThemeData theme) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.06),
        alignment: Alignment.center,
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('AI가 열심히 요약 중입니다...', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
