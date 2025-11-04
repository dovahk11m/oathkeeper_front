import 'package:flutter/material.dart';

import '../constants/size.dart';

/// 빅버튼 아래에 들어가는 회색 텍스트 링크
// 아직 아이디가 없으세요? 회원가입
class CustomLinkGrey extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomLinkGrey({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: small),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
      ),
    );
  }
}
