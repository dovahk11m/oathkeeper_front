// lib/main_metrics_text_debug.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view/metrics/metrics_text_page.dart'; // 경로는 네 실제 파일 구조에 맞게

void main() {
  runApp(const ProviderScope(child: _MetricsTextApp()));
}

class _MetricsTextApp extends StatelessWidget {
  const _MetricsTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MetricsText Debug',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MetricsTextPage(planId: 4), // ✅ 여기 planId만 바꿔서 테스트
      debugShowCheckedModeBanner: false,
    );
  }
}
