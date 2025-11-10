import 'package:flutter/material.dart';

/// 디자인 토큰 - 앱 전체에서 사용하는 디자인 상수
class AppDesign {
  // ========== 색상 ==========
  static const Color primaryColor = Color(0xFF5B7BFE);
  static const Color primaryLight = Color(0xFF8BA4FF);
  static const Color primaryDark = Color(0xFF3D5FD9);

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color dividerColor = Color(0xFFE9ECEF);

  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFFADB5BD);

  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFB300);
  static const Color errorColor = Color(0xFFFF3D00);

  static const Color chatMyBubble = Color(0xFF5B7BFE);
  static const Color chatOtherBubble = Color(0xFFF1F3F5);
  static const Color unreadBadge = Color(0xFFFF3D00);

  // ========== 간격 ==========
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // ========== 패딩 ==========
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // ========== 모서리 반경 ==========
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusFull = 999.0;

  // ========== 그림자 ==========
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // ========== 애니메이션 ==========
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 350);

  static const Curve animationCurve = Curves.easeInOut;

  // ========== 아이콘 크기 ==========
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;

  // ========== 폰트 크기 ==========
  static const double fontSizeCaption = 11.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeSubtitle = 16.0;
  static const double fontSizeTitle = 18.0;
  static const double fontSizeHeading = 20.0;
  static const double fontSizeLarge = 24.0;

  // ========== 높이 (elevation) ==========
  static const double elevationNone = 0.0;
  static const double elevationSmall = 0.5;
  static const double elevationMedium = 2.0;
  static const double elevationLarge = 4.0;

  // ========== 프로필 크기 ==========
  static const double profileSmall = 32.0;
  static const double profileMedium = 48.0;
  static const double profileLarge = 56.0;
  static const double profileXLarge = 80.0;
}

