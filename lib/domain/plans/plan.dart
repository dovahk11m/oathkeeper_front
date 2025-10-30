import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oath_client/domain/plans/participant.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

/// 플랜(약속)
@freezed
class Plan with _$Plan {
  const factory Plan({
    required int id,
    required String title,
    required DateTime planDatetime,
    required String status, // PLANNING, CONFIRMED, COMPLETED
    String? location,
    double? placeLatitude,
    double? placeLongitude,
    int? lateFineAmount,
    required CreatorMember creatorMember,
    @Default([]) List<Participant> participants,
    @Default([]) List<String> tags,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}

/// 플랜 생성자 정보
@freezed
class CreatorMember with _$CreatorMember {
  const factory CreatorMember({
    required int id,
    required String email,
    required String nickname,
    String? profileImageUrl,
  }) = _CreatorMember;

  factory CreatorMember.fromJson(Map<String, dynamic> json) => _$CreatorMemberFromJson(json);
}

