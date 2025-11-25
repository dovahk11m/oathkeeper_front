import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/plans/plan_list_provider.dart';

/// 약속 목록 탭 위젯
class PlanListTab extends ConsumerWidget {
  final Function(int planId, String planTitle) onPlanTap;

  const PlanListTab({
    super.key,
    required this.onPlanTap,
  });

  String _formatDateTime(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return datetime;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final planListState = ref.watch(planListProvider);

    if (planListState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (planListState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('오류가 발생했습니다', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(planListState.error!,
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // 재시도 로직
              },
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (planListState.plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text('약속이 없습니다.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('약속을 만들면 여기에 표시됩니다.',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: planListState.plans.length,
      itemBuilder: (context, index) {
        final plan = planListState.plans[index];
        final isCompleted = plan.status == 'COMPLETED';

        return Card(
          elevation: 1,
          color: isCompleted ? null : theme.disabledColor.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            enabled: isCompleted,
            leading: Icon(
              isCompleted ? Icons.event_available : Icons.event,
              color:
                  isCompleted ? theme.colorScheme.primary : theme.disabledColor,
            ),
            title: Text(
              plan.title,
              style: TextStyle(
                color: isCompleted ? null : theme.disabledColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateTime(plan.planDatetime),
                  style: TextStyle(
                    color: isCompleted ? null : theme.disabledColor,
                  ),
                ),
                if (!isCompleted)
                  Text(
                    '완료되지 않은 약속',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.disabledColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            trailing: isCompleted
                ? Icon(Icons.chevron_right, color: theme.colorScheme.primary)
                : Icon(Icons.lock, color: theme.disabledColor),
            onTap:
                isCompleted ? () => onPlanTap(plan.planId, plan.title) : null,
          ),
        );
      },
    );
  }
}
