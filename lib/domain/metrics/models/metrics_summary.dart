// metrics_summary.dart (필요 키만)
class MetricsMember {
  final int memberId;
  final String? memberName;
  final double distanceKm;
  final int travelMinutes;
  MetricsMember(
      {required this.memberId,
      this.memberName,
      required this.distanceKm,
      required this.travelMinutes});
  factory MetricsMember.fromJson(Map<String, dynamic> j) => MetricsMember(
        memberId: j['member_id'],
        memberName: j['member_name'],
        distanceKm: (j['distance_km'] as num).toDouble(),
        travelMinutes: j['travel_minutes'],
      );
}

class MetricsSummaryResp {
  final Map<String, dynamic> summary; // 원본 유지
  MetricsSummaryResp(this.summary);
  factory MetricsSummaryResp.fromJson(Map<String, dynamic> j) =>
      MetricsSummaryResp(j['summary'] ?? j);
}
