import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/reviews/review.dart';
import 'package:oath_client/domain/reviews/review_repository.dart';

/// 후기 목록 상태
final reviewListProvider =
    StateNotifierProvider<ReviewListNotifier, AsyncValue<List<Review>>>((ref) {
  return ReviewListNotifier(ref.read(reviewRepositoryProvider));
});

class ReviewListNotifier extends StateNotifier<AsyncValue<List<Review>>> {
  final ReviewRepository _repository;

  ReviewListNotifier(this._repository) : super(const AsyncValue.loading());

  /// 내가 작성한 후기 목록 가져오기
  Future<void> fetchMyReviews() async {
    state = const AsyncValue.loading();
    try {
      final reviews = await _repository.getMyReviews();
      state = AsyncValue.data(reviews);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 후기 생성
  Future<void> createReview(CreateReviewRequest request) async {
    try {
      await _repository.createReview(request);
      await fetchMyReviews();
    } catch (e) {
      rethrow;
    }
  }

  /// 후기 삭제
  Future<void> deleteReview(int reviewId) async {
    try {
      await _repository.deleteReview(reviewId);
      state.whenData((reviews) {
        state =
            AsyncValue.data(reviews.where((r) => r.id != reviewId).toList());
      });
    } catch (e) {
      rethrow;
    }
  }
}

/// 후기 상세 상태
final reviewDetailProvider =
    StateNotifierProvider.family<ReviewDetailNotifier, AsyncValue<Review>, int>(
        (ref, reviewId) {
  return ReviewDetailNotifier(ref.read(reviewRepositoryProvider), reviewId);
});

class ReviewDetailNotifier extends StateNotifier<AsyncValue<Review>> {
  final ReviewRepository _repository;
  final int reviewId;

  ReviewDetailNotifier(this._repository, this.reviewId)
      : super(const AsyncValue.loading()) {
    fetchReview();
  }

  /// 후기 상세 가져오기
  Future<void> fetchReview() async {
    state = const AsyncValue.loading();
    try {
      final review = await _repository.getReview(reviewId);
      state = AsyncValue.data(review);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 후기 수정
  Future<void> updateReview(String content, double? rating) async {
    try {
      await _repository.updateReview(reviewId, content, rating);
      await fetchReview();
    } catch (e) {
      rethrow;
    }
  }

  /// 댓글 추가
  Future<void> addReply(String content) async {
    try {
      final reply = await _repository.createReply(reviewId, content);
      state = state.whenData((review) => review.copyWith(
            replies: [...review.replies, reply],
            replyCount: review.replyCount + 1,
          ));
    } catch (e) {
      rethrow;
    }
  }

  /// 댓글 삭제
  Future<void> deleteReply(int replyId) async {
    try {
      await _repository.deleteReply(replyId);
      state = state.whenData((review) => review.copyWith(
            replies: review.replies.where((r) => r.id != replyId).toList(),
            replyCount: review.replyCount > 0 ? review.replyCount - 1 : 0,
          ));
    } catch (e) {
      rethrow;
    }
  }
}
