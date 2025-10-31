import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/api/ai_api.dart';            // aiDioProvider (http://10.0.2.2:8001/metrics)
import '../../common/http_util.dart';             // dioProvider   (http://10.0.2.2:8080/api)
import '../../domain/metrics/models/text_options.dart';
import '../../domain/metrics/repository/metrics_repository.dart';
import '../../domain/members/members_repository.dart';

class MetricsTextPage extends ConsumerStatefulWidget {
  final int planId;
  const MetricsTextPage({super.key, required this.planId});

  @override
  ConsumerState<MetricsTextPage> createState() => _MetricsTextPageState();
}

class _MetricsTextPageState extends ConsumerState<MetricsTextPage> {
  MetricsRepository? _metricsRepo;   // AI 요약 호출
  MembersRepository? _membersRepo;   // 멤버 이름 조회
  Map<int, String>? _nameMap;

  String _text = '';
  bool _loading = false;
  String _mode = 'rules';            // 'rules' | 'llm'

  // 점( . .. ... ) 애니메이션
  String _dots = '';
  Timer? _dotTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Dio ai  = ref.read(aiDioProvider);
      final Dio app = ref.read(dioProvider);
      _metricsRepo = MetricsRepository(ai);
      _membersRepo = MembersRepository(app);

      try {
        _nameMap = await _membersRepo?.fetchNameMapByPlan(widget.planId);
      } catch (_) {}

      _loadRules();
    });
  }

  // ===== 로딩 도트 애니메이션 =====
  void _startDotAnim() {
    _dotTimer?.cancel();
    _dots = '';
    _dotTimer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      if (!mounted) return;
      setState(() {
        _dots = (_dots.length >= 3) ? '' : '$_dots.';
      });
    });
  }

  void _stopDotAnim() {
    _dotTimer?.cancel();
    _dotTimer = null;
    _dots = '';
  }

  void _setLoading(bool v) {
    if (v) {
      _startDotAnim();
    } else {
      _stopDotAnim();
    }
    setState(() => _loading = v);
  }

  @override
  void dispose() {
    _stopDotAnim();
    super.dispose();
  }

  // ===== API 호출 =====
  Future<void> _loadRules() async {
    if (_metricsRepo == null) return;
    _setLoading(true);
    try {
      _mode = 'rules';
      final t = await _metricsRepo!.fetchRulesText(widget.planId);
      setState(() => _text = t);
    } catch (e) {
      setState(() => _text = '요약 생성 실패: $e');
      _toast('요약 생성 실패');
    } finally {
      if (mounted) _setLoading(false);
    }
  }

  Future<void> _loadLLM() async {
    if (_metricsRepo == null) return;
    _setLoading(true);
    try {
      _mode = 'llm';
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
      if (mounted) _setLoading(false);
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('약속 ${widget.planId} 요약')),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if ((_nameMap ?? {}).isNotEmpty) ...[
                    Text('참여 멤버', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _nameMap!.entries
                          .map((e) => Chip(
                        label: Text('${e.value} (id:${e.key})'),
                        visualDensity: VisualDensity.compact,
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'rules',
                        label: Text('규칙 요약'),
                        icon: Icon(Icons.rule),
                      ),
                      ButtonSegment(
                        value: 'llm',
                        label: Text('AI 요약'),
                        icon: Icon(Icons.auto_awesome),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: _loading
                        ? null
                        : (s) {
                      final m = s.first;
                      if (m == 'rules') {
                        _loadRules();
                      } else {
                        _loadLLM();
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SelectableText(
                        _text.isEmpty ? '텍스트 없음' : _text,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _loading ? null : _loadRules,
                          icon: const Icon(Icons.refresh),
                          label: const Text('다시 불러오기'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _loading ? null : _loadLLM,
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

          if (_loading) _buildLoadingOverlay(context),
        ],
      ),
    );
  }

  // ===== 로딩 오버레이 (스피너 위, 텍스트 아래, 크기 고정) =====
  Widget _buildLoadingOverlay(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          color: Colors.black.withOpacity(0.06),
          alignment: Alignment.center,
          child: Material(
            elevation: 6,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 4),
                  ),
                  const SizedBox(height: 12),
                  // 폭을 고정해 점 애니메이션으로 흔들리지 않게
                  SizedBox(
                    width: 160, // 박스 폭 고정
                    child: Text(
                      'AI 요약 생성 중$_dots',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
