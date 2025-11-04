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
  final String sample = "$_baseImagePath/sample.png";
}

class _Svgs {
  const _Svgs();

  /// svg 하드코딩 방지용
  // svg 공통 경로
  static const String _baseSvgPath = "assets/social";

  // svg 경로
  final String sample = "$_baseSvgPath/sample.svg";
}

class _Fonts {
  const _Fonts();

  // 폰트
  final String cookieRun = "CookieRun";
}
