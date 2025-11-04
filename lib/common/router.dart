import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/view/auth_signup/signup_screen.dart';
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
      final onLoginRoutes = state.matchedLocation == '/' ||
          state.matchedLocation == '/login/email' ||
          state.matchedLocation == '/signup';

      if (!isLoggedIn) {
        return onLoginRoutes ? null : '/';
      }
      if (onLoginRoutes) {
        return '/home';
      }
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
    builder: (context, state) => const SignupScreen(),
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
