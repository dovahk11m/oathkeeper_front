import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/auth/auth_provider.dart';
import 'package:oath_client/view/auth/login_screen.dart';
import 'package:oath_client/view/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 로그인 상태를 감시합니다.
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp(
      title: 'Oath-Keeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // 전반적인 텍스트 테마를 설정하여 가독성을 높입니다.
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // 로그인 상태에 따라 다른 화면을 보여줍니다.
      home: isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}
