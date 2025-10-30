import 'package:flutter/material.dart';

// ===================================================================
// 위젯 스펙 (Widget Spec)
// ===================================================================
/// 앱 전반에서 사용되는 공용 텍스트 입력 필드입니다.
///
/// ## 주요 특징
/// - `isLight` 파라미터를 통해 밝은 배경과 어두운 배경 모두에 대응하는 스타일을 제공합니다.
///   - `isLight: false` (기본값): 어두운 배경용 (흰색 텍스트 및 테두리)
///   - `isLight: true`: 밝은 배경용 (검은색 텍스트 및 회색 테두리)
/// - `labelText`를 필수로 받아 어떤 입력 필드인지 표시합니다.
/// - `obscureText`를 통해 비밀번호 입력을 지원합니다.
///
/// ## 현재 사용처
/// - lib/view/login/email_login_screen.dart (isLight: false)
/// - lib/view/profile/edit_profile_screen.dart (isLight: true)
/// - lib/view/profile/change_password_screen.dart (isLight: true)
// ===================================================================

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool isLight; // 밝은 배경용 스타일을 적용할지 여부

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.isLight = false, // 기본값은 어두운 배경용 (기존 스타일)
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLight ? Colors.black87 : Colors.white;
    final labelColor = isLight ? Colors.grey[600] : Colors.white70;
    final borderColor = isLight ? Colors.grey[400]! : Colors.white54;
    final focusedBorderColor = isLight ? Colors.blue : Colors.white;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        filled: isLight, // 밝은 배경에서는 약간의 채움색을 줍니다.
        fillColor: isLight ? Colors.grey[50] : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
