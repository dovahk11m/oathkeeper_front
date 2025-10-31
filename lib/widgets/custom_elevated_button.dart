import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onPressed;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
    this.elevation = 0.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        elevation: elevation,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
