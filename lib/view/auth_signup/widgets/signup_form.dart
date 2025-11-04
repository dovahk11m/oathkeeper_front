import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';
import 'package:oath_client/widgets/primary_button.dart';

class SignupForm extends ConsumerStatefulWidget {
  final List<int> agreedTermIds;

  const SignupForm({super.key, required this.agreedTermIds});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'user10@test.com');
  final _nameController = TextEditingController(text: '강철우');
  final _passwordController = TextEditingController(text: '12341234');
  final _passwordConfirmController = TextEditingController(text: '12341234');

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  // 최종 폼 제출 로직
  Future<void> _submitForm() async {
    // 1. 폼 유효성 검사
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // 2. SignupProvider를 통해 회원가입 API 호출
    final signupInfo = Signup(
      email: _emailController.text,
      username: _nameController.text,
      password: _passwordController.text,
      agreedTermIds: widget.agreedTermIds, // 동의한 약관 ID 목록 전달
    );
    await ref.read(signupProvider.notifier).signup(signupInfo);
  }

  @override
  Widget build(BuildContext context) {
    // Provider의 상태를 감시하고, 변경 시 UI를 다시 그리거나 스낵바를 표시
    ref.listen<SignupState>(signupProvider, (previous, next) {
      // 에러가 발생한 경우
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
      // 회원가입에 성공한 경우
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다!')),
        );
        // 가입 성공 후 로그인 페이지로 이동
        context.go('/login');
      }
    });

    // 로딩 상태를 감시
    final isLoading = ref.watch(signupProvider).isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 이메일 입력 ---
            CustomTextFormField(
              controller: _emailController,
              labelText: '이메일',
              hintText: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) return '이메일을 입력해주세요.';
                final emailRegex = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if (!emailRegex.hasMatch(value)) return '유효한 이메일 형식이 아닙니다.';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // --- 이름 입력 ---
            CustomTextFormField(
              controller: _nameController,
              labelText: '이름',
              hintText: '이름을 입력하세요',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) return '이름을 입력해주세요.';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // --- 비밀번호 입력 ---
            CustomTextFormField(
              controller: _passwordController,
              labelText: '비밀번호',
              hintText: '영문, 숫자 포함 8자 이상',
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';
                if (value.length < 8) return '비밀번호는 8자 이상이어야 합니다.';
                // TODO: 영문, 숫자 포함 정규식 검사 추가
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _passwordConfirmController,
              labelText: '비밀번호 확인',
              hintText: '비밀번호를 한번 더 입력해주세요',
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호 확인을 위해 입력해주세요.';
                }
                if (value != _passwordController.text) {
                  return '비밀번호가 일치하지 않습니다.';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),

            // --- 가입하기 버튼 ---
            PrimaryButton(
              text: '가입하기',
              onPressed: isLoading ? null : _submitForm,
              isLoading: isLoading,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6B55FE),
            ),
          ],
        ),
      ),
    );
  }
}
