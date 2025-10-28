import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/auth/auth_provider.dart';
import 'package:oath_client/view/auth/login_screen.dart';
import 'package:oath_client/view/groups/group_list_screen.dart'; // 수정

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp(
      title: 'Oath-Keeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // 수정: 로그인 성공 시 GroupListScreen으로 이동
      home: isLoggedIn ? const GroupListScreen() : const LoginScreen(),
    );
  }
}
