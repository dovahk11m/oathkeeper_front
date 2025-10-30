import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';
import 'package:oath_client/view/plans/widgets/plan_card.dart';

/// 약속(플랜) 목록 화면
class PlanListScreen extends ConsumerWidget {
  const PlanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '약속',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          ? const Center(child: CircularProgressIndicator())
          : planState.error != null
              ? Center(child: Text('에러: ${planState.error}'))
              : planState.plans.isEmpty
                  ? const Center(child: Text('약속이 없습니다'))
                  : ListView.builder(
                      itemCount: planState.plans.length,
                      itemBuilder: (context, index) {
                        return PlanCard(plan: planState.plans[index]);
                      },
                    ),
    );
  }
}

