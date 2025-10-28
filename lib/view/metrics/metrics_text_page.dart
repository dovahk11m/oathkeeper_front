import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../common/api/ai_api.dart'; // aiDioProvider
import '../../domain/metrics/repository/metrics_repository.dart';
import '../../domain/metrics/models/text_options.dart';

class MetricsTextPage extends ConsumerStatefulWidget {
  final int planId;
  const MetricsTextPage({super.key, required this.planId});

  @override
  ConsumerState<MetricsTextPage> createState() => _MetricsTextPageState();
}

class _MetricsTextPageState extends ConsumerState<MetricsTextPage> {
  late MetricsRepository _repo;
  String _text = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // ref.read는 initState에서 바로 써도 됨(ConsumerState)
    final Dio ai = ref.read(aiDioProvider);
    _repo = MetricsRepository(ai);
    _loadRules(); // 기본 rules 텍스트 한번 가져오기
  }

  Future<void> _loadRules() async {
    setState(() => _loading = true);
    try {
      final t = await _repo.fetchRulesText(widget.planId);
      setState(() => _text = t);
    } catch (e) {
      setState(() => _text = '요약 생성 실패: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadPrompt() async {
    setState(() => _loading = true);
    try {
      final t = await _repo.fetchText(
        widget.planId,
        TextOptions(
          mode: 'prompt',
          notes: 'A가 B보다 늦는 점 강조, 격려로 마무리',
          // 필요하면 nameMap 넣기: {7: '테스터1', 8: '테스터2', 9: '테스터3'}
        ),
      );
      setState(() => _text = t);
    } catch (e) {
      setState(() => _text = '요약 생성 실패: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('약속 ${widget.planId} 요약')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(_text.isEmpty ? '텍스트 없음' : _text),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'rules',
            onPressed: _loadRules,
            label: const Text('규칙 요약'),
            icon: const Icon(Icons.rule),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'prompt',
            onPressed: _loadPrompt,
            label: const Text('프롬프트 요약'),
            icon: const Icon(Icons.edit_note),
          ),
        ],
      ),
    );
  }
}
