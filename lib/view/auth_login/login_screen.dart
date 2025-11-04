import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/size.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/widgets/custom_link_grey.dart';
import 'package:oath_client/view/auth_login/widgets/social_login_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kAppGradientStart, kAppGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: xxLarge),
            child: LayoutBuilder(builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 3),
                        Image.asset(
                          'assets/images/logo.jpg',
                          height: 180,
                        ),
                        const SizedBox(height: medium),
                        const Text(
                          '약속지킴이',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: xLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '친구들과의 약속\n쉽게 관리하세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: large,
                          ),
                        ),
                        const SizedBox(height: medium),
                        SocialLoginButton(
                          text: '카카오로 시작하기',
                          icon: Icons.chat_bubble,
                          backgroundColor: const Color(0xFFFFE812),
                          textColor: const Color(0xFF3C1E1E),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('카카오 로그인은 아직 구현되지 않았습니다.')),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SocialLoginButton(
                          text: 'Facebook으로 시작하기',
                          icon: Icons.facebook,
                          backgroundColor: const Color(0xFF1877F2),
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Facebook 로그인은 아직 구현되지 않았습니다.')),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SocialLoginButton(
                          text: '이메일로 시작하기',
                          icon: Icons.email_outlined,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          onPressed: () {
                            // GoRouter를 사용하여 이메일 로그인 화면으로 이동
                            context.go('/login/email');
                          },
                        ),
                        const SizedBox(height: small),
                        Center(
                          child: CustomLinkGrey(
                            text: '아직 아이디가 없으신가요? 회원가입',
                            onPressed: () {
                              context.go("/signup");
                            },
                          ),
                        ),
                        Center(
                          child: CustomLinkGrey(
                            text: '비밀번호가 생각나지 않으세요? 비밀번호찾기',
                            onPressed: () {
                              context.go("/find-account");
                            },
                          ),
                        ),
                        const Spacer(flex: 2),
                        const Text(
                          '계속 진행하면 이용약관 및 개인정보처리방침에 동의하는 것으로 간주됩니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: small,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
