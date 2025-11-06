import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/error_messages.dart';
import 'package:oath_client/domain/members/member.dart';

/// AuthState의 변화를 감지하여 UI 피드백(화면 이동, 에러 메시지)을 처리하는 공용 함수
void handleAuthStatus(WidgetRef ref, BuildContext context) {
  ref.listen<AuthState>(authProvider, (previous, next) {
    // 위젯이 화면에 보이는 상태가 아니면 아무것도 하지 않음
    if (!context.mounted) return;

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
        // 다른 종류의 에러가 표시되기 전에 이전 SnackBar를 숨김
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  });
}
