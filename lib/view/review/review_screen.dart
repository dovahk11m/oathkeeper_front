import 'package:flutter/material.dart';
import 'package:oath_client/widgets/custom_app_bar.dart';
import 'package:oath_client/widgets/common_widgets.dart';

/// 후기 화면 (임시)
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '후기'),
      body: const EmptyWidget(
        message: '후기 화면 준비중입니다',
        icon: Icons.star_outline,
      ),
    );
  }
}

