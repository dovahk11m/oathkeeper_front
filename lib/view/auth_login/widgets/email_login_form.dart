import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/domain/members/auth/strategies/email_login_strategy.dart';
import 'package:oath_client/view/auth_login/widgets/auth_status_handler.dart';
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

    ref.read(authProvider.notifier).login(
          EmailLoginStrategy(
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // initState에서 호출하던 것을 build 메소드로 이동하여 `ref.listen` 오류 해결
    handleAuthStatus(ref, context);

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
