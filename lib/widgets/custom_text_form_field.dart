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
/// - `onFieldSubmitted` 콜백을 지원하여 키보드의 '완료' 버튼 동작을 처리할 수 있습니다.
/// - `validator` 콜백을 통해 입력값의 유효성 검사를 지원합니다.
///
/// ## 현재 사용처
/// - lib/view/login/email_login_screen.dart (isLight: false)
/// - lib/view/profile/edit_profile_screen.dart (isLight: true)
/// - lib/view/profile/change_password_screen.dart (islight: true)
// ===================================================================

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool isLight; // 밝은 배경용 스타일을 적용할지 여부
  final ValueSetter<String>? onFieldSubmitted; // 키보드 완료 버튼 콜백
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.isLight = false, // 기본값은 어두운 배경용 (기존 스타일)
    this.onFieldSubmitted,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLight ? Colors.black87 : Colors.white;
    final labelColor = isLight ? Colors.grey[600] : Colors.white70;
    final hintColor = isLight ? Colors.grey[500] : const Color(0xFFB0B5C1);
    final borderColor = isLight ? Colors.grey[400]! : Colors.white54;
    final focusedBorderColor = isLight ? Colors.blue : Colors.white;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        filled: isLight, // 밝은 배경에서는 약간의 채움색을 줍니다.
        fillColor: isLight ? Colors.grey[50] : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
