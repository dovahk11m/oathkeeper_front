import 'package:flutter/material.dart';

/// 접속자 수 표시 위젯
class OnlinePill extends StatelessWidget {
  final int count;

  const OnlinePill({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.people_alt, size: 16),
          const SizedBox(width: 6),
          Text('접속자 $count명',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
