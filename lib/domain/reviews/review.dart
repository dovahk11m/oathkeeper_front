import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// 후기 모델
@freezed
class Review with _$Review {
  const factory Review({
    required int id,
    required int planId,
    required String planTitle,
    required int authorId,
    required String authorName,
    required String title,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<Reply> replies,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}

/// 댓글 모델
@freezed
class Reply with _$Reply {
  const factory Reply({
    required int id,
    required int reviewId,
    required int authorId,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Reply;

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
}

/// 후기 생성 요청
@freezed
class CreateReviewRequest with _$CreateReviewRequest {
  const factory CreateReviewRequest({
    required int planId,
    required String title,
    required String content,
  }) = _CreateReviewRequest;

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);
}

/// 댓글 생성 요청
@freezed
class CreateReplyRequest with _$CreateReplyRequest {
  const factory CreateReplyRequest({
    required String content,
  }) = _CreateReplyRequest;

  factory CreateReplyRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReplyRequestFromJson(json);
}
