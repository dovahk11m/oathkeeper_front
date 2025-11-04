import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 색상을 테마나 특정 값으로 지정
    final bgColor = backgroundColor ?? Colors.white;
    final fgColor = foregroundColor ?? const Color(0xFF6B55FE);

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // 로딩 중일 때는 비활성화
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: isLoading
          ? SizedBox(
              height: 24, // 버튼 텍스트 높이와 유사하게
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: fgColor, // 로딩 인디케이터 색상도 통일
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
