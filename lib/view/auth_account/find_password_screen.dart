import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/view/auth_account/widgets/find_password_form.dart';

class FindPasswordScreen extends StatelessWidget {
  const FindPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kAppGradientStart,
            kAppGradientEnd,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '비밀번호 찾기',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              // go_router를 사용하여 이전 화면으로 돌아가거나 특정 경로로 이동
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/login'); // 돌아갈 수 없는 경우, 로그인 화면으로 이동
              }
            },
          ),
        ),
        body: const FindPasswordForm(),
      ),
    );
  }
}
