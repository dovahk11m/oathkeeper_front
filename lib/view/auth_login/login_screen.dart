import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/size.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/view/auth_login/widgets/social_login_form.dart';
import 'package:oath_client/widgets/custom_link_grey.dart';

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
                        // 소셜 로그인 버튼들을 포함한 폼 위젯
                        const SocialLoginForm(),
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
