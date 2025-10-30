import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../common/api/ai_api.dart';           // aiDioProvider (http://10.0.2.2:8001/metrics)
import '../../common/http_util.dart';        // dioProvider   (http://10.0.2.2:8080/api)
import '../../domain/metrics/repository/metrics_repository.dart';
import '../../domain/metrics/models/text_options.dart';
import '../../domain/members/members_repository.dart';

class MetricsTextPage extends ConsumerStatefulWidget {
  final int planId;
  const MetricsTextPage({super.key, required this.planId});

  @override
  ConsumerState<MetricsTextPage> createState() => _MetricsTextPageState();
}

class _MetricsTextPageState extends ConsumerState<MetricsTextPage> {
  MetricsRepository? _metricsRepo;     // AI 요약
  MembersRepository? _membersRepo;     // 멤버 이름
  Map<int, String>? _nameMap;

  String _text = '';
  bool _loading = false;
  String _mode = 'rules'; // 'rules' | 'llm'

  @override
  void initState() {
    super.initState();
    // Provider는 frame 이후 안전하게 읽자
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Dio ai  = ref.read(aiDioProvider);
      final Dio app = ref.read(dioProvider);

      _metricsRepo  = MetricsRepository(ai);
      _membersRepo  = MembersRepository(app);

      // 1) 멤버 이름 로딩
      try {
        _nameMap = await _membersRepo?.fetchNameMapByPlan(widget.planId);
      } catch (_) {}
      // 2) 기본 rules 로딩
      _loadRules();
    });
  }

  Future<void> _loadRules() async {
    if (_metricsRepo == null) return; // ❗ 초기화 전이면 리턴
    setState(() => _loading = true);
    try {
      final t = await _metricsRepo!.fetchRulesText(widget.planId);
      setState(() => _text = t);
    } catch (e) {
      setState(() => _text = '요약 생성 실패: $e');
      _toast('요약 생성 실패');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadLLM() async {
    if (_metricsRepo == null) return;
    setState(() { _loading = true; _text = "AI 요약 생성 중…"; });
    try {
      final t = await _metricsRepo!.fetchText(
        widget.planId,
        TextOptions(
          mode: 'llm',
          style: '친근하고 간결하게',
          notes: '메타문구 금지, 비교 1문장, 마지막은 격려',
          nameMap: _nameMap,
        ),
      );
      setState(() => _text = t);
    } catch (e) {
      setState(() => _text = '요약 생성 실패: $e');
      _toast('요약 생성 실패');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('약속 ${widget.planId} 요약'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 멤버 칩 영역
              if ((_nameMap ?? {}).isNotEmpty) ...[
                Text('참여 멤버', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (_nameMap!.entries.map((e) {
                    return Chip(
                      label: Text('${e.value} (id:${e.key})'),
                      visualDensity: VisualDensity.compact,
                    );
                  })).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // 모드 토글
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'rules', label: Text('규칙 요약'), icon: Icon(Icons.rule)),
                  ButtonSegment(value: 'llm',   label: Text('AI 요약'),  icon: Icon(Icons.auto_awesome)),
                ],
                selected: {_mode},
                onSelectionChanged: (s) {
                  final m = s.first;
                  if (m == 'rules') {
                    _loadRules();
                  } else {
                    _loadLLM();
                  }
                },
              ),
              const SizedBox(height: 16),

              // 결과 카드
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    _text.isEmpty ? '텍스트 없음' : _text,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // 하단 액션
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _loadRules,
                      icon: const Icon(Icons.refresh),
                      label: const Text('다시 불러오기'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _loadLLM,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('AI로 다듬기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
