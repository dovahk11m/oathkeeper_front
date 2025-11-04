import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/websocket_service.dart';
import 'package:oath_client/view/chat/chat_list_screen.dart';
import 'package:oath_client/view/plans/plan_list_screen.dart';
import 'package:oath_client/view/profile/profile_screen.dart';
import 'package:oath_client/view/review/review_screen.dart';
import 'package:oath_client/widgets/custom_bottom_nav_bar.dart';

/// 하단 탭바 메인 화면
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  late int _currentIndex;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);

    // WebSocket 초기 연결
    Future.microtask(() {
      ref.read(websocketInitProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print('[Home] 앱 포그라운드 복귀 - WebSocket 재연결');
        ref.read(websocketServiceProvider).reconnect();
        break;
      case AppLifecycleState.paused:
        print('[Home] 앱 백그라운드 진입');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  final List<Widget> _screens = [
    const ChatListScreen(),
    const PlanListScreen(),
    const ReviewScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 뒤로가기 이벤트를 직접 제어
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }

        final now = DateTime.now();
        // 마지막으로 누른 시간이 없거나, 2초 이상 지났으면 경고 메시지 표시
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('한 번 더 누르면 종료됩니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // 2초 안에 다시 눌렀으면 앱 종료
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
