import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';

import 'login/login_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authProvider로부터 사용자 정보를 가져옵니다.
    final username = ref.watch(usernameProvider) ?? '사용자';

    // 로그아웃 상태 변화를 감지하여 화면을 전환합니다.
    ref.listen(isLoggedInProvider, (previous, next) {
      // isLoggedIn이 false가 되면 로그인 화면으로 이동시킵니다.
      if (next == false) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false, // 이전의 모든 화면 기록을 삭제합니다.
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('환영합니다, $username님'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: () {
              // AuthNotifier의 로그아웃 메소드를 호출합니다.
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '메인 화면입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
