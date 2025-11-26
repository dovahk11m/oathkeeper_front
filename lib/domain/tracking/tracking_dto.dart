/// 단일 위치 포인트(업로드 요청 본문용)
class TrackPoint {
  final double lat;
  final double lng;
  final DateTime ts;
  final double? speedMps;
  final double? accuracyM;
  final String? source; // GPS, NETWORK 등
  final bool? isMock;

  const TrackPoint({
    required this.lat,
    required this.lng,
    required this.ts,
    this.speedMps,
    this.accuracyM,
    this.source,
    this.isMock,
  });

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'ts': ts.toUtc().toIso8601String(),
        if (speedMps != null) 'speedMps': speedMps,
        if (accuracyM != null) 'accuracyM': accuracyM,
        if (source != null) 'source': source,
        if (isMock != null) 'isMock': isMock,
      };
}

/// 위치 배치 업로드 요청
class TrackBatchRequest {
  final int participantId;
  final List<TrackPoint> points;

  TrackBatchRequest({
    required this.participantId,
    required List<TrackPoint> points,
  }) : points = List.unmodifiable(points);

  Map<String, dynamic> toJson() => {
        'participantId': participantId,
        'points': points.map((p) => p.toJson()).toList(),
      };
}

/// 서버 업로드 응답 data 예시: {"value": 2}
class TrackUploadResult {
  final int savedCount;

  const TrackUploadResult(this.savedCount);

  factory TrackUploadResult.fromJson(dynamic json) {
    if (json is Map && json['value'] is num) {
      return TrackUploadResult((json['value'] as num).toInt());
    }
    if (json is num) {
      return TrackUploadResult(json.toInt());
    }
    return const TrackUploadResult(0);
  }
}

/// (레거시) 기존 TrackingDto - 구 엔드포인트 호환용
@Deprecated('Use TrackPoint/TrackBatchRequest with /api/track/tracks/bulk')
class TrackingDto {
  final int planId;
  final int memberId;
  final double lat, lng;
  final double? accuracy, speed, heading;
  final DateTime ts;

  TrackingDto({
    required this.planId,
    required this.memberId,
    required this.lat,
    required this.lng,
    this.accuracy,
    this.speed,
    this.heading,
    required this.ts,
  });

  factory TrackingDto.fromJson(Map<String, dynamic> j) => TrackingDto(
        planId: j['planId'] ?? 0,
        memberId: j['memberId'] ?? 0,
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        accuracy: (j['accuracy'] as num?)?.toDouble(),
        speed: (j['speed'] as num?)?.toDouble(),
        heading: (j['heading'] as num?)?.toDouble(),
        ts: DateTime.parse(j['ts']),
      );

  Map<String, dynamic> toUploadJson() => {
        'planId': planId,
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
        'speed': speed,
        'heading': heading,
        'ts': ts.toUtc().toIso8601String(),
      };
}
