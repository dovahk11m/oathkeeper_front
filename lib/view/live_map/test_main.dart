import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_map_page.dart';

void main() {
  // Riverpod 사용 중이면 ProviderScope로 감싸주는 게 안전해요
  runApp(const ProviderScope(child: _LiveMapTestApp()));
}

class _LiveMapTestApp extends StatelessWidget {
  const _LiveMapTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveMap Test',
      debugShowCheckedModeBanner: false,
      home: const LiveMapPage(planId: 1), // 원하는 planId로 바꿔서 테스트
    );
  }
}
