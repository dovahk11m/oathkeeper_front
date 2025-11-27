import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_location_dto.freezed.dart';
part 'live_location_dto.g.dart';

/// 실시간 위치 업데이트 DTO (서버 → 클라이언트)
///
/// 서버 응답 예시:
/// ```json
/// {
///   "memberId": 1,
///   "username": "김철수",
///   "profileImageUrl": "http://example.com/profile/1.jpg",
///   "lat": 35.123456,
///   "lng": 129.789012,
///   "lastLiveTs": "2025-11-21T14:30:00"
/// }
/// ```
@freezed
class LiveLocationDto with _$LiveLocationDto {
  const factory LiveLocationDto({
    required int memberId,
    required String username,
    String? profileImageUrl,
    required double lat,
    required double lng,
    required String lastLiveTs, // ISO 8601 형식
  }) = _LiveLocationDto;

  factory LiveLocationDto.fromJson(Map<String, dynamic> json) =>
      _$LiveLocationDtoFromJson(json);
}
