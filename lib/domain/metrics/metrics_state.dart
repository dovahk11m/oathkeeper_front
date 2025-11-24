import 'package:freezed_annotation/freezed_annotation.dart';

part 'metrics_state.freezed.dart';

/// 메트릭 요약 상태
enum SummaryStatus {
  idle, // 초기 상태
  processing, // 생성 중
  completed, // 완료
  failed, // 실패
}

/// 메트릭 상태 관리
@freezed
class MetricsState with _$MetricsState {
  const factory MetricsState({
    // 요약 로딩 상태
    @Default(false) bool isSummaryLoading,
    // 요약 상태
    @Default(SummaryStatus.idle) SummaryStatus summaryStatus,
    // 요약 데이터 (완료 시)
    String? summaryText,
    int? summaryPlanId,
    String? summaryTitle,
    // 에러 메시지
    String? error,
  }) = _MetricsState;
}
