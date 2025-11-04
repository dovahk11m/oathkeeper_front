import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/widgets/custom_alert_dialog.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';
import 'package:oath_client/widgets/primary_button.dart';

class FindPasswordForm extends ConsumerStatefulWidget {
  const FindPasswordForm({super.key});

  @override
  ConsumerState<FindPasswordForm> createState() => _FindPasswordFormState();
}

class _FindPasswordFormState extends ConsumerState<FindPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    ref.read(findPasswordProvider.notifier).resetState(); // 이전 상태를 초기화하고 시작
    final request = FindPasswordRequest(email: _emailController.text);
    await ref.read(findPasswordProvider.notifier).findPassword(request);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findPasswordProvider);

    ref.listen(findPasswordProvider, (previous, next) {
      if (previous == next) return; // 상태 변경이 없으면 무시

      // 에러 발생 시
      if (next.error != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.error!)));
      }

      // 성공 시
      if (next.successMessage != null) {
        showDialog(
          context: context,
          builder: (_) => CustomAlertDialog(
            title: '비밀번호 재설정',
            content: next.successMessage!, // 서버에서 받은 메시지를 표시
            onConfirm: () {
              // 1. 다이얼로그 닫기
              Navigator.of(context).pop();
              // 2. 로그인 화면으로 이동
              context.go('/login');
              // 3. 상태 초기화
              ref.read(findPasswordProvider.notifier).resetState();
            },
          ),
        );
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              '가입 시 사용한 이메일 주소를 입력해주세요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              isLight: true,
              controller: _emailController,
              labelText: '이메일 주소',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return '이메일을 입력해주세요.';
                final emailRegex = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if (!emailRegex.hasMatch(value)) return '유효한 이메일 형식이 아닙니다.';
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: '이메일로 임시 비밀번호 전송하기',
              isLoading: state.isLoading,
              onPressed: _submit,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
