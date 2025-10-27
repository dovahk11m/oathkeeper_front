import 'package:flutter/material.dart';

/// [size.dart]
///
/// ## 목적
/// 앱 전체에서 사용될 공통적인 간격(Gap) 크기 및 화면 크기 관련 유틸리티를 정의합니다.
/// 일관된 레이아웃과 디자인을 유지하고, 반복적인 수치 입력을 줄여 가독성과 유지보수성을 높입니다.
///
/// ## 주요 사용처
/// ### Gap 상수 (fiveGap, tenGap 등)
/// - RegisterForm (예: 위젯 간의 SizedBox 높이 설정)
/// - CustomAuthTextFormField (예: 제목과 TextFormField 사이의 간격)
/// - SocialLoginForm (예: 버튼 간의 간격)
///
/// ### 화면 크기 유틸리티 (getScreenWidth, getScreenHeight 등)
/// - Drawer의 너비를 화면 너비의 일정 비율로 설정할 때 (예: getDrawerWidth 함수)

// 공통 상수
const double xxSmall = 2.0;
const double xSmall = 4.0;
const double small = 8.0;
const double medium = 16.0;
const double large = 24.0;
const double xLarge = 32.0;
const double xxLarge = 48.0;
const double huge = 100.0;

// 현재 화면 너비 반환 유틸리티
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// 현재 화면 높이 반환 유틸리티
double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Drawer 너비 계산 유틸리티 (화면 너비의 60%)
double getDrawerWidth(BuildContext context) {
  return getScreenWidth(context) * 0.6;
}
