import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/domain/members/password/password_provider.dart';
import 'package:oath_client/domain/members/password/password_state.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';

/// 비밀번호 변경 화면
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _listenPasswordState(PasswordState? previous, PasswordState next) {
    final wasLoading = previous?.isLoading ?? false;

    // 로딩 시작/종료 처리
    if (next.isLoading && !wasLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    } else if (!next.isLoading && wasLoading) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
    }

    // 에러 발생 시
    if (next.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.errorMessage!)),
      );
      // 에러가 발생하면 상태를 초기화하고 이전 화면으로 돌려보낼 수 있습니다.
      ref.read(passwordProvider.notifier).resetState();
      context.pop();
    }
    // 비밀번호 변경 성공 시
    else if (next.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
      );
      ref.read(passwordProvider.notifier).resetState(); // 상태 초기화
      context.go('/home/profile'); // 프로필 화면으로 이동
    }
  }

  void _changePassword() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 클라이언트 단에서 간단한 유효성 검사
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    // Notifier의 updatePassword 메소드 호출 (새로운 비밀번호만 전달)
    ref.read(passwordProvider.notifier).updatePassword(newPassword);
  }

  @override
  Widget build(BuildContext context) {
    // 비밀번호 프로바이더의 상태 변화를 감지
    ref.listen<PasswordState>(passwordProvider, _listenPasswordState);
    final passwordState = ref.watch(passwordProvider);

    return Container(
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
          title: const Text('비밀번호 변경',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                controller: _newPasswordController,
                labelText: '새 비밀번호',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _confirmPasswordController,
                labelText: '새 비밀번호 확인',
                obscureText: true,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: passwordState.isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('변경 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
