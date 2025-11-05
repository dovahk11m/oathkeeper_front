import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/error_messages.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';
import 'package:oath_client/widgets/primary_button.dart';

class EmailLoginForm extends ConsumerStatefulWidget {
  const EmailLoginForm({super.key});

  @override
  ConsumerState<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends ConsumerState<EmailLoginForm> {
  final _emailController = TextEditingController(text: 'user1@test.com');
  final _passwordController = TextEditingController(text: '1234');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
      );
      return;
    }

    // authProvider 내부에서 오류를 처리하고 상태를 업데이트하므로 try-catch는 불필요.
    await ref.read(authProvider.notifier).login(
          EmailLoginStrategy(
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      // 로그인 성공
      if (next.auth != null) {
        context.go('/');
        return;
      }

      // 로그인 실패 (에러가 발생했고, 이전 상태와 다를 때만 UI 처리)
      if (next.error != null && previous?.error != next.error) {
        final error = next.error!;
        // "이메일 미인증" 에러 메시지를 상수로 확인
        if (error.contains(unverifiedAccountError)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('계정 미활성'),
              content: const Text('이메일 인증이 완료되지 않았습니다. 전송된 인증 메일을 확인해주세요.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        } else {
          // 그 외 다른 에러는 SnackBar로 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      }
    });

    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _emailController,
            labelText: '이메일 주소',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _passwordController,
            labelText: '비밀번호',
            obscureText: true,
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: '로그인',
            isLoading: authState.isLoading,
            onPressed: _submitForm,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF6B55FE),
          ),
        ],
      ),
    );
  }
}
