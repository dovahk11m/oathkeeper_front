import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/metrics/group_metrics_provider.dart';

/// 그룹 통계 탭 위젯
class GroupStatsTab extends ConsumerWidget {
  const GroupStatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final groupMetricsState = ref.watch(groupMetricsProvider);

    if (groupMetricsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (groupMetricsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('오류가 발생했습니다', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(groupMetricsState.error!,
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // 재시도 로직은 부모에서 전달받아야 함
              },
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final summary = groupMetricsState.summary;
    if (summary == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text('그룹 통계를 불러오려면 버튼을 눌러주세요.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // 로드 로직은 부모에서 전달받아야 함
              },
              icon: const Icon(Icons.refresh),
              label: const Text('통계 불러오기'),
            ),
          ],
        ),
      );
    }

    // 약속이 없는 경우
    if (summary.message != null && summary.message!.contains('없습니다')) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined,
                size: 64, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text('아직 완료된 약속이 없습니다', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(summary.message ?? '',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    // 정상 데이터 표시
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.groupSummary != null) ...[
            // 통계 카드들
            _buildStatCard(
              theme,
              '분석된 약속',
              '${summary.groupSummary!.totalPlansAnalyzed ?? 0}개',
              Icons.event_available,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              theme,
              '총 이동 거리',
              '${summary.groupSummary!.totalDistanceKm?.toStringAsFixed(1) ?? '0.0'} km',
              Icons.route,
              theme.colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              theme,
              '평균 이동 거리',
              '${summary.groupSummary!.avgDistancePerPlanKm?.toStringAsFixed(1) ?? '0.0'} km/약속',
              Icons.directions_walk,
              theme.colorScheme.tertiary,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              theme,
              '총 지각 시간',
              '${summary.groupSummary!.totalLateMinutes ?? 0}분',
              Icons.access_time,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              theme,
              '평균 지각 시간',
              '${summary.groupSummary!.avgLateMinutesPerPlan?.toStringAsFixed(1) ?? '0.0'}분/약속',
              Icons.timer,
              Colors.red,
            ),
            const SizedBox(height: 20),
          ],

          // AI 요약
          if (summary.textSummary != null &&
              summary.textSummary!.isNotEmpty) ...[
            Text('AI 요약', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  summary.textSummary!,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 통계 카드 위젯
  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(value,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
