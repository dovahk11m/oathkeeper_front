import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

/// 플랜 참가자
@freezed
class Participant with _$Participant {
  const factory Participant({
    required int id,
    required int memberId,
    required String memberNickname,
    String? memberProfileImageUrl,
    required String participantStatus, // PENDING, ACCEPTED, REJECTED
    String? transportMethod, // WALK, TRANSIT, DRIVE
    int? expectedTravelTimeMinutes,
    DateTime? expectedDepartureTime,
    DateTime? actualDepartureTime,
    DateTime? actualArrivalTime,
    String? arrivalStatus, // ON_TIME, LATE, ABSENT
    int? timeBurdenMinutes,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
}

