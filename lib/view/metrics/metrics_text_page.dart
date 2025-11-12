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

  // 상태 플래그(✅ SummarySheet와 동일한 분기)
  bool _noActivePlan = false;  // 플랜 없음/유효하지 않음(404)
  bool _notReadyYet  = false;  // 플랜은 있으나 메트릭 미집계(409)

  String _mode = 'rules';      // 'rules' | 'llm'

  // 점( . .. ... ) 애니메이션
  String _dots = '';
  Timer? _dotTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // ✅ planId 가드: 0 이하 → 플랜 없음 화면
      if (widget.planId <= 0) {
        setState(() {
          _noActivePlan = true;
          _notReadyYet  = false;
          _text = '';
        });
        return;
      }

      final Dio ai  = ref.read(aiDioProvider);
      final Dio app = ref.read(dioProvider);
      _metricsRepo = MetricsRepository(ai);
      _membersRepo = MembersRepository(app);

      // 멤버 이름 (실패해도 비치명)
      try {
        _nameMap = await _membersRepo?.fetchNameMapByPlan(widget.planId);
      } catch (_) {}

      if (!mounted) return;
      _loadRules(); // 기본 진입은 규칙 요약
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
    if (mounted) setState(() => _loading = v);
  }

  @override
  void dispose() {
    _stopDotAnim();
    super.dispose();
  }

  // ===== API 호출 =====
  Future<void> _loadRules() async {
    if (_metricsRepo == null) return;

    // 진입 가드(페이지도 SummarySheet와 동일)
    if (widget.planId <= 0) {
      setState(() {
        _noActivePlan = true;
        _notReadyYet  = false;
        _text = '';
        _mode = 'rules';
      });
      return;
    }

    _setLoading(true);
    setState(() {
      _noActivePlan = false;
      _notReadyYet  = false;
      _mode = 'rules';
    });

    try {
      final t = await _metricsRepo!.fetchRulesText(widget.planId);
      if (!mounted) return;
      setState(() => _text = t);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (!mounted) return;
      if (code == 404) {
        setState(() { _noActivePlan = true; _text = ''; });
      } else if (code == 409) {
        setState(() { _notReadyYet = true; _text = ''; });
      } else {
        setState(() => _text = '요약 생성 실패: $e');
        _toast('요약 생성 실패');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _text = '요약 생성 실패: $e');
        _toast('요약 생성 실패');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadLLM() async {
    if (_metricsRepo == null) return;

    if (widget.planId <= 0) {
      setState(() {
        _noActivePlan = true;
        _notReadyYet  = false;
        _text = '';
        _mode = 'llm';
      });
      return;
    }

    _setLoading(true);
    setState(() {
      _noActivePlan = false;
      _notReadyYet  = false;
      _mode = 'llm';
      _text = 'AI 요약 생성 중…';
    });

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
      if (!mounted) return;
      setState(() => _text = t);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (!mounted) return;
      if (code == 404) {
        setState(() { _noActivePlan = true; _text = ''; });
      } else if (code == 409) {
        setState(() { _notReadyYet = true; _text = ''; });
      } else {
        setState(() => _text = '요약 생성 실패: $e');
        _toast('요약 생성 실패');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _text = '요약 생성 실패: $e');
        _toast('요약 생성 실패');
      }
    } finally {
      _setLoading(false);
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

    final bool disableActions = _loading || _noActivePlan;

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
                        label: Text(e.value),
                        visualDensity: VisualDensity.compact,
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 모드 토글( SummarySheet와 동일)
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'rules', label: Text('규칙 요약'), icon: Icon(Icons.rule)),
                      ButtonSegment(value: 'llm',   label: Text('AI 요약'), icon: Icon(Icons.auto_awesome)),
                    ],
                    selected: {_mode},
                    onSelectionChanged: _loading
                        ? null
                        : (s) {
                      if (_noActivePlan) {
                        _toast('진행 중인 약속이 없어요.');
                        return;
                      }
                      final m = s.first;
                      setState(() => _mode = m);
                      if (m == 'rules') {
                        _loadRules();
                      } else {
                        _loadLLM();
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // 내용 영역: 플랜 없음 / 집계 전 / 요약 카드
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _noActivePlan
                        ? KeyedSubtree(key: const ValueKey('no_plan'), child: _buildNoPlanView(context))
                        : (_notReadyYet
                        ? KeyedSubtree(key: const ValueKey('not_ready'), child: _buildNotReadyView(context))
                        : KeyedSubtree(key: const ValueKey('summary'), child: _buildSummaryCard(theme))),
                  ),

                  const SizedBox(height: 16),

                  // 하단 버튼
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: disableActions ? null : _loadRules,
                          icon: const Icon(Icons.refresh),
                          label: const Text('다시 불러오기'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: disableActions ? null : _loadLLM,
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

  // 요약 카드
  Widget _buildSummaryCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _text.isEmpty ? '텍스트 없음' : _text,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }

  // 플랜 없음
  Widget _buildNoPlanView(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text('아직 등록된 약속이 없어요.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '약속을 생성한 뒤 다시 시도해 주세요.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('뒤로'),
            ),
          ],
        ),
      ),
    );
  }

  // 집계 전(메트릭 없음)
  Widget _buildNotReadyView(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.tertiaryContainer.withOpacity(0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty_rounded, size: 42, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text('아직 집계 준비 중이에요.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '실시간 추적을 종료하고 도착 기록이 저장되면 요약을 만들 수 있어요.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.check),
              label: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  // 로딩 오버레이 (스피너 + 점 애니메이션, 폭 고정)
  Widget _buildLoadingOverlay(BuildContext context) {
    final theme = Theme.of(context);
    final label = _mode == 'llm' ? 'AI 요약 생성 중' : '규칙 요약 불러오는 중';
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
                  const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 4)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 180,
                    child: Text(
                      '$label$_dots',
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
