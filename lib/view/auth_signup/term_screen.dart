import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/member.dart';

import '../../constants/theme.dart';
import '../../widgets/primary_button.dart';

// 약관 동의 페이지 (경로, AppBar, 제목 담당)
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('약관동의',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent, // AppBar 배경을 투명하게
        elevation: 0, // 그림자 제거
      ),
      extendBodyBehindAppBar: true, // Body를 AppBar 뒤로 확장
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kAppGradientStart, kAppGradientEnd],
          ),
        ),
        child: const SafeArea(
          child: TermsBody(),
        ),
      ),
    );
  }
}

/// 약관 목록과 동의 로직을 처리하는 화면의 본문입니다.
class TermsBody extends ConsumerWidget {
  const TermsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsAsync = ref.watch(termListProvider);
    final agreementData = ref.watch(termsAgreementProvider);
    final agreementNotifier = ref.read(termsAgreementProvider.notifier);

    return termsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (terms) {
        // 데이터가 비어있는 경우의 UI
        if (terms.isEmpty) {
          return const Center(child: Text('표시할 약관이 없습니다.'));
        }

        // 데이터 로딩 성공 시 UI 빌드
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // '전체 동의' 행
                    _buildAllAgreedRow(
                        agreementNotifier, agreementData.isAllAgreed),
                    const Divider(),
                    // 약관 목록
                    _buildTermList(
                        terms, agreementData.agreedMap, agreementNotifier),
                  ],
                ),
              ),
              const Spacer(),
              // '다음' 버튼
              PrimaryButton(
                onPressed: agreementNotifier.isNavigationEnabled
                    ? () {
                        final agreedIds = agreementNotifier.agreedTermIds;
                        context.go('/signup-details', extra: agreedIds);
                      }
                    : null,
                text: '다음',
              ),
            ],
          ),
        );
      },
    );
  }

  // '전체 동의' 체크박스 행을 빌드합니다.
  Widget _buildAllAgreedRow(TermsAgreementNotifier notifier, bool isAllAgreed) {
    return Row(
      children: [
        Checkbox(
          value: isAllAgreed,
          onChanged: (value) => notifier.toggleAll(value),
        ),
        const Expanded(
          child: Text(
            '전체동의',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  // 약관 목록을 빌드합니다.
  Widget _buildTermList(List<Term> terms, Map<int, bool> agreedMap,
      TermsAgreementNotifier notifier) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: terms.length,
      itemBuilder: (context, index) {
        final term = terms[index];
        return _buildTermRow(
            context, term, agreedMap[term.id] ?? false, notifier);
      },
    );
  }

  // 개별 약관 행을 빌드합니다.
  Widget _buildTermRow(BuildContext context, Term term, bool isAgreed,
      TermsAgreementNotifier notifier) {
    return Row(
      children: [
        Checkbox(
          value: isAgreed,
          onChanged: (value) => notifier.toggleTerm(term.id, value),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: term.isRequired ? '[필수] ' : '[선택] '),
                TextSpan(text: term.title),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () => context.go('/signup/term-detail', extra: term),
        ),
      ],
    );
  }
}
