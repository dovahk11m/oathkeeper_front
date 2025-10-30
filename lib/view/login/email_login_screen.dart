import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/widgets/primary_button.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/view/home_screen.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';

class EmailLoginScreen extends ConsumerWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController(text: 'user1@test.com');
    final passwordController = TextEditingController(text: '1234');
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.auth != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else if (next.error != null &&
          (ModalRoute.of(context)?.isCurrent ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kAppGradientStart, kAppGradientEnd],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 1),
                  const Text(
                    '이메일로 로그인',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: '이메일 주소',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: '비밀번호',
                    obscureText: true,
                  ),
                  const Spacer(flex: 2),
                  PrimaryButton(
                    text: '로그인',
                    isLoading: authState.isLoading,
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;
                      if (email.isNotEmpty && password.isNotEmpty) {
                        ref.read(authProvider.notifier).login(email, password);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
                        );
                      }
                    },
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
