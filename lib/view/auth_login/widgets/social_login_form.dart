import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/view/auth_login/widgets/auth_status_handler.dart';
import 'package:oath_client/view/auth_login/widgets/social_login_button.dart';

class SocialLoginForm extends ConsumerWidget {
  const SocialLoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 공용 핸들러 함수 호출
    handleAuthStatus(ref, context);

    final authState = ref.watch(authProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SocialLoginButton(
          text: '카카오로 시작하기',
          icon: Icons.chat_bubble,
          backgroundColor: const Color(0xFFFFE812),
          textColor: const Color(0xFF3C1E1E),
          isLoading: authState.isLoading, // 로딩 상태 연결
          onPressed: () => ref.read(authProvider.notifier).signInWithKakao(),
        ),
        const SizedBox(height: 12),
        SocialLoginButton(
          text: 'Facebook으로 시작하기',
          icon: Icons.facebook,
          backgroundColor: const Color(0xFF1877F2),
          textColor: Colors.white,
          isLoading: authState.isLoading, // 로딩 상태 연결
          onPressed: () => ref.read(authProvider.notifier).signInWithFacebook(),
        ),
        const SizedBox(height: 12),
        SocialLoginButton(
          text: '이메일로 시작하기',
          icon: Icons.email_outlined,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          isLoading: authState.isLoading, // 로딩 상태 연결
          onPressed: () {
            context.go('/login/email');
          },
        ),
      ],
    );
  }
}
