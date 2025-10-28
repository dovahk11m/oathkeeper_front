import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_summary.freezed.dart';
part 'group_summary.g.dart';

/// 그룹 목록의 각 아이템을 나타내는 DTO (실제 서버 응답 기반)
@freezed
class GroupSummary with _$GroupSummary {
  const factory GroupSummary({
    required int groupId,
    required String groupName,
    required int chatRoomId,
    String? lastMessage,
    String? lastMessageSentAt,
    required int unreadCount,
  }) = _GroupSummary;

  factory GroupSummary.fromJson(Map<String, dynamic> json) =>
      _$GroupSummaryFromJson(json);
}
