import 'package:flutter/material.dart';

/// 하단 네비게이션 바
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: '약속',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          label: '후기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '내 정보',
        ),
      ],
    );
  }
}

