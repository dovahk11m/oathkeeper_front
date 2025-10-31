import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/members/password/password_check_dto.dart';
import 'package:oath_client/domain/members/password/password_provider.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';

class PasswordCheckDialog extends ConsumerStatefulWidget {
  const PasswordCheckDialog({super.key});

  @override
  ConsumerState<PasswordCheckDialog> createState() =>
      _PasswordCheckDialogState();
}

class _PasswordCheckDialogState extends ConsumerState<PasswordCheckDialog> {
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final currentPassword = _passwordController.text;
    if (currentPassword.isNotEmpty) {
      Navigator.of(context).pop(); // 현재 다이얼로그 닫기
      ref.read(passwordProvider.notifier).checkPassword(
            PasswordCheckDto(password: currentPassword),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('비밀번호 확인'),
      content: CustomTextFormField(
        controller: _passwordController,
        labelText: '현재 비밀번호를 입력하세요',
        obscureText: true,
        isLight: true, // AlertDialog는 밝은 배경이므로 isLight: true
        onFieldSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('확인'),
        ),
      ],
    );
  }
}
