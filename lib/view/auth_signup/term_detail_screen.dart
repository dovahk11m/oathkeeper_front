import 'package:flutter/material.dart';
import 'package:oath_client/domain/members/member.dart';

import '../../constants/theme.dart';

class TermDetailPage extends StatelessWidget {
  final Term term;

  const TermDetailPage({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(term.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent, // AppBar 배경을 투명하게
        elevation: 0, // 그림자 제거
      ),
      extendBodyBehindAppBar: true, // Body를 AppBar 뒤로 확장
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kAppGradientStart, kAppGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Text(term.content,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
