import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/error_messages.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/view/auth_login/widgets/social_login_button.dart';

class SocialLoginForm extends ConsumerWidget {
  const SocialLoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authProvider의 상태 변화를 감지하여 UI 업데이트 (에러 처리, 화면 이동 등)
    ref.listen<AuthState>(authProvider, (previous, next) {
      // 로그인 성공 시 홈으로 이동
      if (next.auth != null) {
        context.go('/');
        return;
      }

      // 에러 발생 시 (이전 상태와 다를 때만) 메시지 표시
      if (next.error != null && previous?.error != next.error) {
        final error = next.error!;
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      }
    });

    // authProvider의 로딩 상태를 지켜보며 버튼의 로딩 상태를 업데이트
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
