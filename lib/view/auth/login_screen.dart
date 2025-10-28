import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/view/auth/email_login_screen.dart';
import 'package:oath_client/view/auth/widgets/social_login_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5B7BFE),
              Color(0xFF6B55FE),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 3),
                // 1. Logo
                Image.asset(
                  'assets/images/logo.jpg',
                  height: 180,
                ),
                const SizedBox(height: 20),
                // 2. Title & Subtitle
                const Text(
                  '약속지킴이',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '친구들과의 약속\n쉽게 관리하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                  ),
                ),
                const Spacer(flex: 1),
                // 3. Login Buttons
                SocialLoginButton(
                  text: '카카오로 시작하기',
                  icon: Icons.chat_bubble,
                  backgroundColor: const Color(0xFFFFE812),
                  textColor: const Color(0xFF3C1E1E),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('카카오 로그인은 아직 구현되지 않았습니다.')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  text: 'Facebook으로 시작하기',
                  icon: Icons.facebook,
                  backgroundColor: const Color(0xFF1877F2),
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Facebook 로그인은 아직 구현되지 않았습니다.')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  text: '이메일로 시작하기',
                  icon: Icons.email_outlined,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const EmailLoginScreen()),
                    );
                  },
                ),
                const Spacer(flex: 2),
                // 4. Disclaimer
                const Text(
                  '계속 진행하면 이용약관 및 개인정보처리방침에 동의하는 것으로 간주됩니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
