import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';
import 'package:oath_client/view/review/create_review_screen.dart';
import 'package:oath_client/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

/// 후기 작성할 약속 선택 화면
class SelectPlanForReviewScreen extends ConsumerWidget {
  const SelectPlanForReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planProvider);

    if (planState.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: '약속 선택'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (planState.error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: '약속 선택'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('약속 불러오기 실패: ${planState.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(planProvider.notifier).loadPlans(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    // COMPLETED 상태인 약속만 필터링
    final completedPlans =
        planState.plans.where((p) => p.status == 'COMPLETED').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '약속 선택'),
      body: completedPlans.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '완료된 약속이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '후기는 완료된 약속에만 작성할 수 있습니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: completedPlans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final plan = completedPlans[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateReviewScreen(
                          planId: plan.id,
                          planTitle: plan.title,
                        ),
                      ),
                    ).then((result) {
                      if (result == true) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '완료',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          plan.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('yyyy.MM.dd HH:mm')
                                  .format(plan.planDatetime),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        if (plan.location != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  plan.location!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
