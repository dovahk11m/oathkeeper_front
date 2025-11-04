// [배럴 파일: Barrel File]
// 이 파일은 member 도메인의 공개 API 역할을 하는 '배럴 파일'입니다.
// member 도메인 내부의 여러 기능들을 이 파일 하나를 통해 외부에 공개합니다.
//
// [사용법]
// UI 레이어나 다른 도메인에서는 아래와 같이 이 파일 하나만 import하면,
// 여기에 export된 모든 기능을 사용할 수 있습니다.
// import 'package:oath_client/domain/members/member.dart';

// ===================
// Auth: 인증 및 세션 관리 (로그인, 로그아웃, 토큰)
// ===================
export 'auth/auth.dart';
export 'auth/auth_provider.dart' show authProvider, isLoggedInProvider;
// 로그인 전략들 (Strategy Pattern)
export 'auth/strategies/login_strategy.dart';
export 'auth/strategies/email_login_strategy.dart';
export 'auth/strategies/kakao_login_strategy.dart';
export 'auth/strategies/facebook_login_strategy.dart';

// ===================
// Signup: 회원가입
// ===================
export 'signup/signup.dart';
export 'signup/signup_state.dart';
export 'signup/signup_provider.dart' show signupProvider;

// ===================
// Find Account: 비밀번호 찾기
// ===================
export 'find_account/find_password_request.dart';
export 'find_account/find_password_state.dart';
export 'find_account/find_password_provider.dart' show findPasswordProvider;

// ===================
// Profile: 내 정보 조회, 수정, 탈퇴 및 프로필 이미지 관리
// ===================
export 'profile/profile.dart';
export 'profile/profile_update_dto.dart';
export 'profile/profile_provider.dart' show profileProvider;

// ===================
// Password: 비밀번호 변경
// ===================
export 'password/password_update_dto.dart';
export 'password/password_state.dart';
export 'password/password_provider.dart' show passwordProvider;
