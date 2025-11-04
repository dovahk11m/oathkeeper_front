import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/view/auth_account/find_password_screen.dart';
import 'package:oath_client/view/auth_signup/signup_screen.dart';
import 'package:oath_client/view/auth_signup/term_screen.dart';
import 'package:oath_client/view/home_screen.dart';
import 'package:oath_client/view/auth_login/email_login_screen.dart';
import 'package:oath_client/view/auth_login/login_screen.dart';
import 'package:oath_client/view/profile/change_password_screen.dart';
import 'package:oath_client/view/profile/edit_profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/', // 앱의 초기 경로
    routes: _routes, // 아래에 정의된 평평한 라우트 리스트 사용
    redirect: (context, state) {
      // 로그인 상태가 아닐 때만 접근 가능한 경로들
      final onLoginRoutes = [
        '/',
        '/login/email',
        '/signup',
        '/signup-details',
        '/find-account'
      ].contains(state.matchedLocation);

      // 로그아웃 상태일 때
      if (!isLoggedIn) {
        // onLoginRoutes에 포함된 경로로 가려는 경우, 그대로 허용
        // 그렇지 않은 경우, 메인 로그인 화면으로 리다이렉트
        return onLoginRoutes ? null : '/';
      }

      // 로그인 상태일 때
      // onLoginRoutes에 포함된 경로로 가려는 경우, 홈 화면으로 리다이렉트
      if (onLoginRoutes) {
        return '/home';
      }

      // 그 외의 경우는 그대로 허용
      return null;
    },
  );
});

// 모든 라우트를 평평한(flat) 리스트로 정의하여 가독성을 높입니다.
final List<GoRoute> _routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/login/email',
    builder: (context, state) => const EmailLoginScreen(),
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const TermsPage(), // 약관 동의 페이지를 먼저 보여줌
  ),
  GoRoute(
    path: '/signup-details',
    builder: (context, state) {
      // 약관 동의 페이지에서 전달받은 agreedTermIds 리스트
      final agreedTermIds = state.extra as List<int>? ?? [];
      return SignupScreen(agreedTermIds: agreedTermIds);
    },
  ),
  GoRoute(
    path: '/find-account',
    builder: (context, state) => const FindPasswordScreen(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/home/groups',
    builder: (context, state) => const HomeScreen(initialIndex: 1),
  ),
  GoRoute(
    path: '/home/profile',
    builder: (context, state) => const HomeScreen(initialIndex: 3),
  ),
  GoRoute(
    path: '/home/profile/edit',
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    path: '/home/profile/edit/password',
    builder: (context, state) => const ChangePasswordScreen(),
  ),
];
