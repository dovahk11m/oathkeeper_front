import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';
import 'package:oath_client/view/plans/widgets/plan_card.dart';
import 'package:oath_client/widgets/custom_app_bar.dart';
import 'package:oath_client/widgets/common_widgets.dart';

/// 약속(플랜) 목록 화면
class PlanListScreen extends ConsumerStatefulWidget {
  const PlanListScreen({super.key});

  @override
  ConsumerState<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends ConsumerState<PlanListScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 항상 최신 목록 로드
    Future.microtask(() {
      print('[PlanList] 화면 진입 - 목록 로드 시작');
      ref.read(planProvider.notifier).loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(planProvider);

    return Scaffold(
      backgroundColor: AppDesign.surfaceColor,
      appBar: CustomAppBar(
        title: '약속',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppDesign.textPrimary),
            iconSize: AppDesign.iconLarge,
            onPressed: () {
              context.push('/plans/create');
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

