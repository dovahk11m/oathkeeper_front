import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/reviews/review.dart';
import 'package:oath_client/domain/reviews/review_provider.dart';
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
                if (review.replies.isNotEmpty) ...[
                  Icon(Icons.comment, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${review.replies.length}',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('후기 상세'),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 후기 정보
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('yyyy.MM.dd HH:mm').format(review.createdAt),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      review.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    // 댓글 목록
                    Text(
                      '댓글 ${review.replies.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...review.replies.map((reply) => _ReplyItem(
                          reply: reply,
                          reviewId: widget.reviewId,
                        )),
                  ],
                ),
              ),
            ),
            // 댓글 입력
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력하세요',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      maxLength: 500,
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) =>
                          null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _addReply(),
                    icon: const Icon(Icons.send),
                    color: AppDesign.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('오류: $error')),
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
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('수정'),
            onTap: () {
              Navigator.pop(context);
              // TODO: 수정 기능
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('삭제', style: TextStyle(color: Colors.red)),
            onTap: () async {
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
          ),
        ],
      ),
    );
  }
}

class _ReplyItem extends ConsumerWidget {
  final Reply reply;
  final int reviewId;

  const _ReplyItem({required this.reply, required this.reviewId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '작성자 #${reply.authorId}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const Spacer(),
              Text(
                DateFormat('MM.dd HH:mm').format(reply.createdAt),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 16),
                onPressed: () async {
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
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(reply.content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
