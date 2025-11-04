import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/view/auth_login/widgets/email_login_form.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kAppGradientStart,
            kAppGradientEnd,
          ],
        ),
      ),
      child: Focus(
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            context.go('/login');
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                context.go('/login');
              },
            ),
            title:
                const Text('이메일로 로그인', style: TextStyle(color: Colors.white)),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Divider(
                color: Colors.white.withAlpha(51),
                height: 1.0,
                thickness: 1.0,
              ),
            ),
          ),
          body: const EmailLoginForm(),
        ),
      ),
    );
  }
}
