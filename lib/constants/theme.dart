import 'package:flutter/material.dart';
import 'package:oath_client/constants/size.dart';

// 로그인 화면 그라데이션 배경색
const Color kAppGradientStart = Color(0xFF5B7BFE);
const Color kAppGradientEnd = Color(0xFF6B55FE);

// 기본 강조 색상 (글자색으로 사용될 어두운 보라)
const Color kAppPrimaryColor = Colors.deepPurple;
// 보조 색상 (Primary 색상의 배경으로 사용될 연보라)
const Color kAppSecondaryColor = Color(0xFFEDE7F6);
// 버튼용 단색 강조 색상 (이것은 그대로 유지)
const Color kAppButtonSolidColor = Colors.deepPurpleAccent; // 진보라

// 앱 전체 테마 데이터
ThemeData theme() {
  // 기본 TextTheme을 가져와서 CookieRun 폰트 및 기본 색상 적용
  final TextTheme baseTextTheme = ThemeData.light().textTheme;
  final TextTheme cookieRunTextTheme = baseTextTheme.apply(
    fontFamily: 'CookieRun', // 폰트 이름은 Assets 클래스 대신 직접 문자열로 사용 (해당 클래스 없음)
    bodyColor: Colors.black87, // 기본 본문 텍스트 색상을 Colors.black87로 설정
    displayColor: Colors.black87, // 기본 제목/디스플레이 텍스트 색상을 Colors.black87로 설정
  );

  return ThemeData(
    useMaterial3: true, // Material 3 사용
    fontFamily: 'CookieRun', // 최상위 fontFamily도 유지 (혹시 모를 경우 대비)
    // 색상 구성표
    colorScheme: ColorScheme.fromSeed(
      seedColor: kAppButtonSolidColor, // 기준 색상 (진보라)
      primary: kAppPrimaryColor, // 기본 강조색 (어두운 보라)
      secondary: kAppSecondaryColor, // 보조색 (연보라)
      error: Colors.redAccent, // 오류 표시색 (빨강 계열)
    ),
    textTheme: cookieRunTextTheme, // 모든 Text 위젯에 CookieRun 폰트가 적용된 TextTheme 사용
    appBarTheme: _appBarTheme(cookieRunTextTheme),
    elevatedButtonTheme: _elevatedButtonTheme(cookieRunTextTheme),
    outlinedButtonTheme: _outlinedButtonTheme(cookieRunTextTheme),
    inputDecorationTheme:
        _inputDecorationTheme(cookieRunTextTheme), // TextTheme 전달
  );
}

// AppBar 테마
AppBarTheme _appBarTheme(TextTheme textTheme) {
  return AppBarTheme(
    titleTextStyle: textTheme.titleLarge?.copyWith(
      color: Colors.white, // AppBar의 타이틀 색상은 흰색 유지
    ),
    centerTitle: true,
    backgroundColor: Colors.black12,
    elevation: 0,
  );
}

// ElevatedButton 테마
ElevatedButtonThemeData _elevatedButtonTheme(TextTheme textTheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, xxLarge),
      backgroundColor: kAppButtonSolidColor,
      foregroundColor: Colors.white, // ElevatedButton의 텍스트 색상은 흰색 유지
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(small),
      ),
      textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700, color: Colors.white), // 여기도 흰색 유지
    ),
  );
}

// OutlinedButton 테마
OutlinedButtonThemeData _outlinedButtonTheme(TextTheme textTheme) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: kAppSecondaryColor, // 연보라 배경
      foregroundColor:
          kAppPrimaryColor, // OutlinedButton의 텍스트 색상은 kAppPrimaryColor 유지
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(small),
      ),
      side: BorderSide.none,
      textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: kAppPrimaryColor), // 여기도 kAppPrimaryColor 유지
    ),
  );
}

// InputDecoration (입력 필드) 테마
InputDecorationTheme _inputDecorationTheme(TextTheme textTheme) {
  return InputDecorationTheme(
    labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
    hintStyle: textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
    errorStyle: textTheme.bodySmall?.copyWith(color: Colors.redAccent.shade700),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(medium),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(medium),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(medium),
      borderSide: const BorderSide(
          color: kAppButtonSolidColor, // 포커스 시 테두리는 버튼 색상 유지
          width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(medium),
      borderSide: BorderSide(color: Colors.redAccent.shade200),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(medium),
      borderSide: BorderSide(color: Colors.redAccent.shade700, width: 2.0),
    ),
  );
}
