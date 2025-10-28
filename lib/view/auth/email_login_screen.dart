import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/auth/auth_provider.dart';
import 'package:oath_client/view/auth/widgets/custom_text_form_field.dart';
import 'package:oath_client/view/main_screen.dart';

class EmailLoginScreen extends ConsumerWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authState = ref.watch(authProvider);

    // 로그인 성공/실패에 따른 UI 반응 처리
    ref.listen(authProvider, (previous, next) {
      if (next.auth != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainScreen()),
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
      // 1. 배경 그라데이션 적용
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B7BFE), Color(0xFF6B55FE)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // 내부 Scaffold는 투명하게
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white, // 뒤로가기 버튼 색상
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
                  // 2. 재사용 위젯으로 교체
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
                  // 3. 버튼 스타일 통일
                  if (authState.isLoading)
                    const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                  else
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text;
                        final password = passwordController.text;
                        if (email.isNotEmpty && password.isNotEmpty) {
                          ref
                              .read(authProvider.notifier)
                              .login(email, password);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('이메일과 비밀번호를 모두 입력해주세요.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B55FE),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
