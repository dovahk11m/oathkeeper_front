import 'package:flutter/material.dart';
import 'package:oath_client/view/chat/chat_list_screen.dart';
import 'package:oath_client/view/plans/plan_list_screen.dart';
import 'package:oath_client/view/profile/profile_screen.dart';
import 'package:oath_client/view/review/review_screen.dart';
import 'package:oath_client/widgets/custom_bottom_nav_bar.dart';

/// 하단 탭바 메인 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const ChatListScreen(),
    const PlanListScreen(),
    const ReviewScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
