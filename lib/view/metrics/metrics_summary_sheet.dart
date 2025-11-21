import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/api/ai_api.dart'; // aiDioProvider (http://10.0.2.2:8001/metrics)
import '../../common/utils/http_util.dart'; // dioProvider   (http://10.0.2.2:8080/api)
import '../../domain/metrics/repository/metrics_repository.dart';
import '../../domain/members/members_repository.dart';
import '../../domain/plans/plan_provider.dart'; // PlanProvider 추가
import '../../domain/plans/plan_state.dart'; // PlanState 추가

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
  // _loading은 로컬 로딩(규칙 요약 등)만 관리하고, AI 요약 로딩은 PlanState를 따름
  bool _localLoading = false;

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
      // 초기 진입 시에는 규칙 요약을 먼저 보여줌
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
    if (mounted) setState(() => _localLoading = v);
  }

  @override
  void dispose() {
    _stopDotAnim();
    // 화면 이탈 시 폴링 취소
    // (주의: ref.read를 dispose에서 사용할 때는 주의가 필요하지만,
    //  여기서는 Notifier의 메소드 호출이므로 허용 범위 내)
    //  단, 안전하게 Future.microtask 등으로 감싸거나,
    //  Riverpod 2.0에서는 onDispose에서 처리하는 것이 권장됨.
    //  PlanNotifier 내부에서 onDispose로 처리하고 있으므로 여기서는 명시적 호출이 필수는 아닐 수 있으나,
    //  화면이 닫힐 때 즉시 중단하기 위해 호출.
    ref.read(planProvider.notifier).cancelSummaryPolling();
    super.dispose();
  }

  // ===== API 호출 =====
  Future<void> _loadRules() async {
    print('[Summary] _loadRules() planId=${widget.planId}');
    if (widget.planId <= 0 || _metricsRepo == null) {
      if (!mounted) return;
      setState(() {
        _noActivePlan = true;
        _notReadyYet = false;
        _text = '';
      });
      return;
    }

    _setLoading(true);
    // AI 폴링 중단 (규칙 모드로 전환 시)
    ref.read(planProvider.notifier).cancelSummaryPolling();

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
    if (widget.planId <= 0) {
      if (!mounted) return;
      setState(() {
        _noActivePlan = true;
        _notReadyYet = false;
        _text = '';
      });
      return;
    }

    // 로컬 로딩 해제 (AI 로딩은 Provider 상태로 관리)
    _setLoading(false);

    setState(() {
      _noActivePlan = false;
      _notReadyYet = false;
      _mode = 'llm';
      // 텍스트 초기화 (로딩 중 표시를 위해)
      _text = '';
    });

    // 폴링 시작
    ref.read(planProvider.notifier).pollPlanSummary(widget.planId);
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final planState = ref.watch(planProvider);

    // AI 요약 상태
    final isAiLoading = planState.isSummaryLoading;
    final aiStatus = planState.summaryStatus;
    final aiSummary = planState.summary;

    // 전체 로딩 상태 (로컬 규칙 로딩 OR AI 폴링 로딩)
    final bool anyLoading = _localLoading || isAiLoading;
    final bool disableActions = anyLoading || _noActivePlan;

    // AI 모드일 때 텍스트 업데이트
    if (_mode == 'llm') {
      if (aiStatus == 'COMPLETED' && aiSummary != null) {
        // 서버 응답 구조에 따라 텍스트 필드 추출
        // 예: { "summary_text": "..." } 또는 { "text": "..." }
        // MetricsPayload 스키마 참고: "summary_text"가 유력하나,
        // PlanRepository에서 data['data']를 그대로 가져오므로 확인 필요.
        // 일단 안전하게 여러 키 시도.
        final content = aiSummary['summary_text'] ??
            aiSummary['text'] ??
            aiSummary['summary'] ??
            '요약 내용이 없습니다.';
        if (_text != content) {
          // 빌드 중에 setState 호출 방지 위해 microtask 사용 가능하지만,
          // 여기서는 로컬 변수 _text를 업데이트하는 대신
          // 아래 UI 렌더링 시 바로 content를 사용하도록 구조 변경이 나음.
          // 하지만 기존 구조 유지를 위해 _text 변수를 쓴다면:
          // _text = content; // (빌드 중 변수 할당은 괜찮음)
        }
      } else if (aiStatus == 'FAILED') {
        // 에러 처리
      }
    }

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
                      onSelectionChanged: anyLoading
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

                    // 내용
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _buildContent(context, theme, planState),
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
            if (anyLoading) _buildLoadingOverlay(context, isAiLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ThemeData theme, PlanState planState) {
    if (_noActivePlan) {
      return KeyedSubtree(
          key: const ValueKey('no_plan'), child: _buildNoPlanView(context));
    }
    if (_notReadyYet) {
      return KeyedSubtree(
          key: const ValueKey('not_ready'), child: _buildNotReadyView(context));
    }

    // AI 모드이고 에러가 났을 때
    if (_mode == 'llm' && planState.summaryStatus == 'FAILED') {
      return KeyedSubtree(
        key: const ValueKey('error'),
        child: Card(
          color: theme.colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'AI 요약 생성에 실패했습니다.\n${planState.error ?? ""}',
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ),
      );
    }

    // 텍스트 결정
    String displayText = _text;
    if (_mode == 'llm' && planState.summary != null) {
      displayText = planState.summary!['summary_text'] ??
          planState.summary!['text'] ??
          planState.summary!['summary'] ??
          '요약 내용이 없습니다.';
    }

    return KeyedSubtree(
        key: const ValueKey('summary'),
        child: _buildSummaryCard(theme, displayText));
  }

  // 요약 카드
  Widget _buildSummaryCard(ThemeData theme, String text) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(text.isEmpty ? '텍스트 없음' : text,
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
  Widget _buildLoadingOverlay(BuildContext context, bool isAi) {
    final theme = Theme.of(context);
    // AI 로딩일 때는 애니메이션 도트 대신 Provider 상태에 의존하거나
    // 여기서도 도트 애니메이션을 돌릴 수 있음.
    // _startDotAnim()은 _localLoading일 때만 호출되므로,
    // AI 로딩일 때도 도트를 보고 싶다면 별도 처리가 필요하나,
    // 간단히 '...' 텍스트로 대체하거나 _dots 변수를 공유해서 쓸 수 있음.
    // 여기서는 간단히 처리.

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
                    child: Text(
                        isAi ? 'AI가 열심히 요약 중입니다...' : '요약 생성 중$_dots',
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

