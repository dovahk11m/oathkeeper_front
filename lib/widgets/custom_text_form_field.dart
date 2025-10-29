import 'package:flutter/material.dart';

// ===================================================================
// 위젯 스펙 (Widget Spec)
// ===================================================================
/// 앱의 그라데이션 배경(로그인 화면 등)에 사용하기 위해 디자인된 공용 텍스트 입력 필드입니다.
///
/// ## 주요 특징
/// - 흰색 계열의 스타일 (입력 텍스트, 라벨, 테두리)을 가집니다.
/// - `labelText`를 필수로 받아 어떤 입력 필드인지 표시합니다.
/// - `obscureText`를 통해 비밀번호 입력을 지원합니다.
///
/// ## 현재 사용처
/// - `lib/view/auth/email_login_screen.dart`
// ===================================================================

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white), // 입력 텍스트 색상
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
