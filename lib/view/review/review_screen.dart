import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/reviews/review.dart';
import 'package:oath_client/domain/reviews/review_provider.dart';
import 'package:oath_client/view/review/edit_review_screen.dart';
import 'package:oath_client/view/review/select_plan_for_review_screen.dart';
import 'package:oath_client/widgets/custom_app_bar.dart';
import 'package:oath_client/widgets/common_widgets.dart';
import 'package:intl/intl.dart';

/// 후기 화면
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewListProvider.notifier).fetchMyReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '후기'),
      body: reviewState.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return const EmptyWidget(
              message: '등록된 후기가 없습니다',
              icon: Icons.star_outline,
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(reviewListProvider.notifier).fetchMyReviews(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _ReviewCard(review: review);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('후기 불러오기 실패: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(reviewListProvider.notifier).fetchMyReviews(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectPlanForReviewScreen(),
            ),
          ).then((result) {
            if (result == true) {
              ref.read(reviewListProvider.notifier).fetchMyReviews();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 이전 다이얼로그 기반 작성 코드는 명세 변경으로 제거되었습니다.
}

class _ReviewCard extends ConsumerWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _showReviewDetail(context, ref),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약속 제목
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                review.planTitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 후기 제목
            Text(
              review.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 8),
            // 후기 내용
            Text(
              review.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            // 하단 정보
            Row(
              children: [
                Text(
                  review.authorName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '·',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy.MM.dd').format(review.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (review.replies.isNotEmpty || review.replyCount > 0) ...[
                  Icon(Icons.comment, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${review.replyCount > 0 ? review.replyCount : review.replies.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewDetail(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ReviewDetailScreen(reviewId: review.id),
      ),
    );
  }
}

class _ReviewDetailScreen extends ConsumerStatefulWidget {
  final int reviewId;

  const _ReviewDetailScreen({required this.reviewId});

  @override
  ConsumerState<_ReviewDetailScreen> createState() =>
      _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends ConsumerState<_ReviewDetailScreen> {
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewDetailProvider(widget.reviewId));

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('후기'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.grey900,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showReviewOptions(context),
          ),
        ],
      ),
      body: reviewState.when(
        data: (review) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 후기 카드
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: AppColors.grey300),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 약속 태그
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.event,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    review.planTitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 장소 정보
                          if (review.placeName != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.placeName!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (review.latitude != null &&
                                          review.longitude != null)
                                        Text(
                                          '${review.latitude!.toStringAsFixed(6)}, ${review.longitude!.toStringAsFixed(6)}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),
                          // 후기 제목
                          Text(
                            review.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey900,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 작성자 & 날짜
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                                child: Text(
                                  review.authorName[0],
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.authorName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.grey900,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yyyy.MM.dd HH:mm')
                                        .format(review.createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // 후기 내용
                          Text(
                            review.content,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: AppColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 댓글 섹션
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.comment_outlined,
                                size: 20,
                                color: AppColors.grey700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '댓글 ${review.replyCount}개',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.grey900,
                                ),
                              ),
                            ],
                          ),
                          if (review.replies.isEmpty) ...[
                            const SizedBox(height: 12),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '첫 댓글을 남겨보세요',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 12),
                            ...review.replies.map((reply) => _ReplyItem(
                                  reply: reply,
                                  reviewId: widget.reviewId,
                                  reviewAuthorId: review.authorId,
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 댓글 입력
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _replyController,
                          decoration: InputDecoration(
                            hintText: '댓글을 입력하세요...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          maxLength: 500,
                          buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => _addReply(),
                        icon: const Icon(Icons.send_rounded, size: 20),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: AppColors.grey400),
              const SizedBox(height: 16),
              Text(
                '오류가 발생했습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addReply() async {
    if (_replyController.text.trim().isEmpty) return;

    try {
      await ref
          .read(reviewDetailProvider(widget.reviewId).notifier)
          .addReply(_replyController.text);
      _replyController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글이 작성되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 작성 실패: $e')),
        );
      }
    }
  }

  void _showReviewOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: AppColors.primary, size: 20),
              ),
              title: const Text('수정하기',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 20),
              ),
              title: const Text('삭제하기',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600)),
              onTap: () async {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final reviewState = ref.read(reviewDetailProvider(widget.reviewId));
    reviewState.whenData((review) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditReviewScreen(review: review),
        ),
      ).then((result) {
        if (result == true) {
          // 수정 완료 후 상세 화면 새로고침
          ref
              .read(reviewDetailProvider(widget.reviewId).notifier)
              .fetchReview();
        }
      });
    });
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:
            const Text('후기 삭제', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('정말로 이 후기를 삭제하시겠습니까?\n삭제된 후기는 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(reviewListProvider.notifier)
                    .deleteReview(widget.reviewId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('후기가 삭제되었습니다')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제 실패: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

class _ReplyItem extends ConsumerWidget {
  final Reply reply;
  final int reviewId;
  final int reviewAuthorId;

  const _ReplyItem({
    required this.reply,
    required this.reviewId,
    required this.reviewAuthorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 익명/실명 선택 로직:
    // 1. 댓글 작성자가 후기 작성자와 같으면 실명 표시
    // 2. authorName이 있으면 실명 표시
    // 3. 그 외는 익명
    final bool isReviewAuthor = reply.authorId == reviewAuthorId;
    final String displayName = isReviewAuthor
        ? (reply.authorName ?? '작성자')
        : (reply.authorName ?? '익명');
    final bool isAnonymous = !isReviewAuthor && reply.authorName == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isReviewAuthor
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.grey.shade200,
                child: isAnonymous
                    ? Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.grey.shade600,
                      )
                    : Text(
                        displayName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isReviewAuthor
                              ? AppColors.primary
                              : Colors.grey.shade700,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isReviewAuthor
                                ? AppColors.primary
                                : AppColors.grey900,
                          ),
                        ),
                        if (isReviewAuthor) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '후기 작성자',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      DateFormat('MM.dd HH:mm').format(reply.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                onPressed: () => _showDeleteConfirm(context, ref),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reply.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:
            const Text('댓글 삭제', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(reviewDetailProvider(reviewId).notifier)
                    .deleteReply(reply.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('댓글이 삭제되었습니다')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('삭제 실패: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
