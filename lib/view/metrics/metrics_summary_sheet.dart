import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/api/ai_api.dart'; // aiDioProvider (http://10.0.2.2:8001/metrics)
import '../../common/utils/http_util.dart'; // dioProvider   (http://10.0.2.2:8080/api)
import '../../domain/metrics/models/text_options.dart';
import '../../domain/metrics/repository/metrics_repository.dart';
import '../../domain/members/members_repository.dart';

class MetricsSummarySheet extends ConsumerStatefulWidget {
  final int planId;
  final VoidCallback? onTapCreatePlan;
  const MetricsSummarySheet(
      {super.key, required this.planId, this.onTapCreatePlan});

  @override
  ConsumerState<MetricsSummarySheet> createState() =>
      _MetricsSummarySheetState();
}

class _MetricsSummarySheetState extends ConsumerState<MetricsSummarySheet> {
  MetricsRepository? _metricsRepo;
  MembersRepository? _membersRepo;
  Map<int, String>? _nameMap;

  String _text = '';
  bool _loading = false;

  // 상태 플래그
  bool _noActivePlan = false; // 플랜 없음/유효하지 않음
  bool _notReadyYet = false; // 플랜은 있으나 메트릭 미집계

  String _mode = 'rules'; // 'rules' | 'llm'

  // 로딩 도트 애니메이션
  String _dots = '';
  Timer? _dotTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      if (widget.planId <= 0) {
        // 플랜 없음 → 안내 카드
        setState(() {
          _noActivePlan = true;
          _notReadyYet = false;
          _text = '';
        });
        return;
      }

      final Dio ai = ref.read(aiDioProvider);
      final Dio app = ref.read(dioProvider);

      _metricsRepo = MetricsRepository(ai);
      _membersRepo = MembersRepository(app);

      // 멤버 이름 (실패해도 비치명)
      try {
        _nameMap = await _membersRepo?.fetchNameMapByPlan(widget.planId);
      } catch (_) {}

      if (!mounted) return;
      _loadRules();
    });
  }

  // ===== 도트 애니메이션 =====
  void _startDotAnim() {
    _dotTimer?.cancel();
    _dots = '';
    _dotTimer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      if (!mounted) return;
      setState(() => _dots = (_dots.length >= 3) ? '' : '$_dots.');
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
    print('[Summary] _loadRules() planId=${widget.planId}');
    if (widget.planId <= 0 || _metricsRepo == null) {
      print('[Summary] guard hit: noActivePlan (rules) -> stop');
      if (!mounted) return;
      setState(() {
        _noActivePlan = true;
        _notReadyYet = false;
        _text = '';
      });
      return; // ✅ 여기서 끝
    }

    _setLoading(true);
    setState(() {
      _noActivePlan = false;
      _notReadyYet = false;
      _mode = 'rules';
    });

    try {
      print('[Summary] calling fetchRulesText...');
      final t = await _metricsRepo!.fetchRulesText(widget.planId);
      if (!mounted) return;
      setState(() => _text = t);
    } on DioException catch (e) {
      final code = e.response?.statusCode ?? 0;
      if (!mounted) return;
      if (code == 404) {
        setState(() {
          _noActivePlan = true;
          _text = '';
        });
      } else if (code == 409) {
        setState(() {
          _notReadyYet = true;
          _text = '';
        });
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
    print('[Summary] _loadLLM() planId=${widget.planId}');
    if (widget.planId <= 0 || _metricsRepo == null) {
      print('[Summary] guard hit: noActivePlan (llm) -> stop');
      if (!mounted) return;
      setState(() {
        _noActivePlan = true;
        _notReadyYet = false;
        _text = '';
      });
      return; // ✅ 여기서 끝
    }

    _setLoading(true);
    setState(() {
      _noActivePlan = false;
      _notReadyYet = false;
      _mode = 'llm';
      _text = 'AI 요약 생성 중…';
    });

    try {
      print('[Summary] calling fetchText (llm)...');
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
        setState(() {
          _noActivePlan = true;
          _text = '';
        });
      } else if (code == 409) {
        setState(() {
          _notReadyYet = true;
          _text = '';
        });
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

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Material(
        color: theme.colorScheme.surface,
        child: Stack(
          children: [
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 핸들
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('약속 ${widget.planId} 요약',
                          style: theme.textTheme.titleLarge),
                    ),
                    const SizedBox(height: 8),

                    if ((_nameMap ?? {}).isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text('참여 멤버', style: theme.textTheme.titleMedium),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _nameMap!.entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Chip(
                                        label: Text(e.value),
                                        visualDensity: VisualDensity.compact),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 모드 토글
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'rules',
                            label: Text('규칙 요약'),
                            icon: Icon(Icons.rule)),
                        ButtonSegment(
                            value: 'llm',
                            label: Text('AI 요약'),
                            icon: Icon(Icons.auto_awesome)),
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
                              if (m == 'rules')
                                _loadRules();
                              else
                                _loadLLM();
                            },
                    ),
                    const SizedBox(height: 16),

                    // 내용
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _noActivePlan
                          ? KeyedSubtree(
                              key: const ValueKey('no_plan'),
                              child: _buildNoPlanView(context))
                          : (_notReadyYet
                              ? KeyedSubtree(
                                  key: const ValueKey('not_ready'),
                                  child: _buildNotReadyView(context))
                              : KeyedSubtree(
                                  key: const ValueKey('summary'),
                                  child: _buildSummaryCard(theme))),
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
        child: SelectableText(_text.isEmpty ? '텍스트 없음' : _text,
            style: theme.textTheme.bodyLarge),
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
            Text('바로 약속 잡기로 이동해서 플랜을 만들어 볼까요?',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onTapCreatePlan?.call();
                });
              },
              icon: const Icon(Icons.event_available),
              label: const Text('약속 잡으러 가기'),
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
            const Icon(Icons.hourglass_empty_rounded,
                size: 42, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text('아직 집계 준비 중이에요.', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('실시간 추적을 종료하고 도착 기록이 저장되면 요약을 만들 수 있어요.',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check),
              label: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  // 로딩 오버레이
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
                      child: CircularProgressIndicator(strokeWidth: 4)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 180,
                    child: Text('AI 요약 생성 중$_dots',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface)),
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
