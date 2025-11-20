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

    // COMPLETED & completedAt 존재하는 약속만 필터링 -> 서버 최신 상태 반영 위해 필요 시 재검증
    final completedPlans = planState.plans.where((p) {
      final isCompleted = p.status.toUpperCase() == 'COMPLETED';
      final hasCompletedAt = p.completedAt != null;
      return isCompleted && hasCompletedAt;
    }).toList();
    // 목록이 비어있을 때 한번 더 서버 상세 요청으로 completedAt 누락 케이스 보완
    if (completedPlans.isEmpty && planState.plans.isNotEmpty) {
      // 간단한 재확인: completedAt 없이 COMPLETED인 경우 상세 조회 후 completedAt 채워 넣기
      final maybeCompleted = <int>[];
      for (final p in planState.plans) {
        if (p.status.toUpperCase() == 'COMPLETED' && p.completedAt == null) {
          maybeCompleted.add(p.id);
        }
      }
      // 이 화면은 ConsumerWidget이므로 ref 사용 가능. 동기 재검증은 사용자 경험 위해 최소화.
      // 여기서는 간단히 스낵바 안내만 (전체 자동 재조회는 별도 버튼 권장)
      if (maybeCompleted.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('일부 완료된 약속의 완료 시간(completedAt)이 누락되었습니다. 새로고침을 시도하세요.')),
        );
      }
    }

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
                    // 안전장치: 혹시 조건이 어긋나면 안내
                    if (plan.status.toUpperCase() != 'COMPLETED' ||
                        plan.completedAt == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('완료된 약속만 후기 작성 가능')));
                      return;
                    }
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
