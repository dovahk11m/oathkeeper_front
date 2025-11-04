import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/auth/strategies/email_login_strategy.dart';
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

    try {
      await ref.read(authProvider.notifier).login(
            EmailLoginStrategy(
              email: email,
              password: password,
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.auth != null) {
        // 로그인 성공 시 go_router를 사용하여 홈으로 이동
        context.go('/');
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
