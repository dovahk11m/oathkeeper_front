/// 메트릭스 AI 요약 테스트용 메인 파일
///
/// 개별 약속의 AI 요약 기능을 독립적으로 테스트하기 위한 진입점
/// planId를 변경하여 다양한 약속 테스트 가능
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'metrics_text_page.dart';

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
      home: const MetricsTextPage(planId: 1), // ✅ 여기 planId만 바꿔서 테스트
      debugShowCheckedModeBanner: false,
    );
  }
}
