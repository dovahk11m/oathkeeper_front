class TrackingDto {
  final int planId;
  final int memberId; // 업로드 시 0, 서버가 토큰으로 채움
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
    planId: j['planId'],
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
