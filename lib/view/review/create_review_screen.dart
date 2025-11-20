import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/reviews/review.dart';
import 'package:oath_client/domain/reviews/review_provider.dart';
import 'package:oath_client/widgets/custom_app_bar.dart';

/// 후기 작성 화면
class CreateReviewScreen extends ConsumerStatefulWidget {
  final int planId;
  final String planTitle;

  const CreateReviewScreen({
    super.key,
    required this.planId,
    required this.planTitle,
  });

  @override
  ConsumerState<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends ConsumerState<CreateReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final request = CreateReviewRequest(
        planId: widget.planId,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      await ref.read(reviewListProvider.notifier).createReview(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('후기가 작성되었습니다')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('후기 작성 실패: ${_cleanError(e)}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _cleanError(Object e) {
    final msg = e.toString();
    // Exception: 앞부분 제거
    return msg.replaceFirst('Exception: ', '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '후기 작성',
        actions: [
          if (!_isSubmitting)
            TextButton(
              onPressed: _submitReview,
              child: const Text(
                '완료',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 약속 정보
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '약속',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.planTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 제목 입력
            const Text(
              '제목',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '후기 제목을 입력하세요',
                hintStyle: const TextStyle(color: AppColors.grey400),
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                counterText: '',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '제목을 입력해주세요';
                }
                if (value.trim().length > 100) {
                  return '제목은 100자 이내로 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 내용 입력
            const Text(
              '내용',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _contentController,
              maxLength: 500,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '약속에 대한 후기를 작성해주세요',
                hintStyle: TextStyle(color: AppColors.grey400),
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '내용을 입력해주세요';
                }
                if (value.trim().length > 500) {
                  return '내용은 500자 이내로 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 안내 문구
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '작성한 후기는 다른 참여자들도 볼 수 있습니다.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
