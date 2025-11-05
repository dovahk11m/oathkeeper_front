import 'package:freezed_annotation/freezed_annotation.dart';

// 서버 API 응답의 문자열과 매핑하기 위해 JsonValue 어노테이션 사용
enum Role {
  @JsonValue('USER')
  USER,
  @JsonValue('ADMIN')
  ADMIN,
}

enum SocialType {
  @JsonValue('KAKAO')
  KAKAO,
  @JsonValue('FACEBOOK')
  FACEBOOK,
  @JsonValue('NAVER')
  NAVER,
  @JsonValue('GOOGLE')
  GOOGLE,
  @JsonValue('EMAIL')
  EMAIL,
}

enum Status {
  @JsonValue('ACTIVE')
  ACTIVE, // 활성
  @JsonValue('DEACTIVATED')
  DEACTIVATED, // 비활성 (탈퇴)
  @JsonValue('SUSPENDED')
  SUSPENDED, // 정지
}
