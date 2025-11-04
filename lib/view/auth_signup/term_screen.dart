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

class TermsBody extends ConsumerStatefulWidget {
  const TermsBody({super.key});

  @override
  ConsumerState<TermsBody> createState() => _TermsBodyState();
}

class _TermsBodyState extends ConsumerState<TermsBody> {
  // 각 약관의 동의 여부를 ID를 key로 하여 관리
  Map<int, bool> _agreedTerms = {};

  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후 첫 프레임에서 약관 목록을 불러옵니다.
    Future.microtask(() => ref.read(termProvider.notifier).getTerms());
  }

  void _toggleAllAgreed(bool? value) {
    if (value == null) return;
    final terms = ref.read(termProvider).terms;
    setState(() {
      for (var term in terms) {
        _agreedTerms[term.id] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termProvider);
    final terms = state.terms;

    final isAllAgreed = terms.isNotEmpty &&
        terms.every((term) => _agreedTerms[term.id] == true);

    // 모든 필수 약관에 동의했는지 확인
    final isAllRequiredAgreed = terms
        .where((term) => term.isRequired)
        .every((term) => _agreedTerms[term.id] == true);

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
                _buildAllAgreedRow(isAllAgreed),
                const Divider(),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.error != null)
                  Center(child: Text(state.error!))
                else
                  _buildTermList(terms),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            onPressed: isAllRequiredAgreed
                ? () {
                    final agreedIds = _agreedTerms.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                    context.go('/signup-details', extra: agreedIds);
                  }
                : null, // 비활성화
            text: '다음',
          ),
        ],
      ),
    );
  }

  Widget _buildAllAgreedRow(bool isAllAgreed) {
    return Row(
      children: [
        Checkbox(value: isAllAgreed, onChanged: _toggleAllAgreed),
        const Expanded(
          child: Text(
            '전체동의',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTermList(List<Term> terms) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: terms.length,
      itemBuilder: (context, index) {
        final term = terms[index];
        return _buildTermRow(term);
      },
    );
  }

  Widget _buildTermRow(Term term) {
    return Row(
      children: [
        Checkbox(
          value: _agreedTerms[term.id] ?? false,
          onChanged: (bool? value) {
            setState(() {
              _agreedTerms[term.id] = value ?? false;
            });
          },
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
