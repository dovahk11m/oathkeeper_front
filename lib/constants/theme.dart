import 'package:flutter/material.dart';

// 로그인 화면 그라데이션 배경색
const Color kAppGradientStart = Color(0xFF5B7BFE);
const Color kAppGradientEnd = Color(0xFF6B55FE);

// 기본 강조 색상 (글자색으로 사용될 어두운 보라)
const Color kAppPrimaryColor = Colors.deepPurple;
// 보조 색상 (Primary 색상의 배경으로 사용될 연보라)
const Color kAppSecondaryColor = Color(0xFFEDE7F6);
// 버튼용 단색 강조 색상 (이것은 그대로 유지)
const Color kAppButtonSolidColor = Colors.deepPurpleAccent; // 진보라

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Pretendard',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w900),
      titleMedium: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(fontWeight: FontWeight.w500),
      bodySmall: TextStyle(fontWeight: FontWeight.w100),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: kAppGradientStart,
    ),
  );
}
