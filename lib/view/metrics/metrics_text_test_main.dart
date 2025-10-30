import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view/metrics/metrics_text_page.dart';

void main() {
  runApp(
    const ProviderScope(    // ✅ 반드시 있어야 함!
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MetricsTextPage(planId: 4),
      ),
    ),
  );
}
