import 'package:flutter/material.dart';

/// 공통 앱바 (흰색 배경, 검은 텍스트)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions; // 오른쪽에 추가할 위젯 목록

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.actions, // 생성자에 actions 추가
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions, // AppBar에 actions 전달
      // 앱바의 아이콘들(뒤로가기 버튼 포함) 색상을 검은색으로 통일합니다.
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
