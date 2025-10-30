import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';
import 'package:oath_client/view/plans/widgets/plan_card.dart';
import 'package:oath_client/widgets/custom_app_bar.dart';
import 'package:oath_client/widgets/common_widgets.dart';

/// 약속(플랜) 목록 화면
class PlanListScreen extends ConsumerWidget {
  const PlanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '약속',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // TODO: 약속 생성 화면
            },
          ),
        ],
      ),
      body: planState.isLoading
          ? const LoadingWidget()
          : planState.error != null
              ? CustomErrorWidget(
                  message: '약속을 불러오는데 실패했습니다\n${planState.error}',
                  onRetry: () => ref.read(planProvider.notifier).loadPlans(),
                )
              : planState.plans.isEmpty
                  ? const EmptyWidget(
                      message: '약속이 없습니다\n새 약속을 만들어보세요!',
                      icon: Icons.calendar_today_outlined,
                    )
                  : ListView.builder(
                      itemCount: planState.plans.length,
                      itemBuilder: (context, index) {
                        return PlanCard(plan: planState.plans[index]);
                      },
                    ),
    );
  }
}

