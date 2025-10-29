class Assets {
  Assets._();

  static const Images = _Images();
  static const Svgs = _Svgs();
  static const Fonts = _Fonts();
}

class _Images {
  const _Images();

  /// 이미지 하드코딩 방지용
  // 이미지 공통 경로
  static const String _baseImagePath = "assets";

  // 이미지 경로
  final String defaultProfile = "$_baseImagePath/default_profile.png";
  final String geminiLogo = "$_baseImagePath/gemini_logo.png";
  final String listButton = "$_baseImagePath/list-button.png";
  final String logo = "$_baseImagePath/logo.png";
  final String lun = "$_baseImagePath/lun.jpg";
  final String marker = "$_baseImagePath/marker.png";
  final String menu = "$_baseImagePath/menu.png";
  final String community = "$_baseImagePath/community1.png";
  final String community2 = "$_baseImagePath/community2.jpg";
}

class _Svgs {
  const _Svgs();

  /// svg 하드코딩 방지용
  // svg 공통 경로
  static const String _baseSvgPath = "assets/social";

  // svg 경로
  final String google = "$_baseSvgPath/google.svg";
  final String kakaoTalk = "$_baseSvgPath/kakao-talk.svg";
  final String kakao = "$_baseSvgPath/kakao.svg";
  final String naver = "$_baseSvgPath/naver.svg";
}

class _Fonts {
  const _Fonts();

  // 폰트
  final String cookieRun = "CookieRun";
}
