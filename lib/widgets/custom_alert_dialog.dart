import 'package:flutter/material.dart';
import 'package:oath_client/widgets/custom_elevated_button.dart';

/// 앱 전반에서 사용되는 공용 다이얼로그입니다.
///
/// ## 주요 특징
/// - `title`과 `content`를 통해 제목과 내용을 표시합니다.
/// - `onCancel` 콜백의 제공 여부에 따라 버튼이 1개(정보) 또는 2개(확인)로 자동 조절됩니다.
///
/// ## 사용 예시
///
/// ### 1. 정보 제공용 (버튼 1개)
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => CustomAlertDialog(
///     title: '알림',
///     content: '작업이 완료되었습니다.',
///     onConfirm: () => Navigator.of(context).pop(),
///   ),
/// );
/// ```
///
/// ### 2. 확인용 (버튼 2개)
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => CustomAlertDialog(
///     title: '삭제 확인',
///     content: '정말로 삭제하시겠습니까?',
///     confirmText: '삭제',
///     onConfirm: () {
///       // 삭제 로직
///     },
///     onCancel: () => Navigator.of(context).pop(),
///   ),
/// );
/// ```
class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String content;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;

  const CustomAlertDialog({
    super.key,
    this.title,
    required this.content,
    this.confirmText = '확인',
    this.cancelText = '취소',
    required this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // `onCancel`의 존재 여부에 따라 버튼 목록을 동적으로 구성합니다.
    final buttonWidgets = <Widget>[
      Expanded(
        child: CustomElevatedButton(
          text: confirmText,
          onPressed: onConfirm,
          backgroundColor: confirmButtonColor ?? theme.colorScheme.primary,
          textColor: Colors.white,
        ),
      ),
      if (onCancel != null) ...[
        const SizedBox(width: 12),
        Expanded(
          child: CustomElevatedButton(
            text: cancelText ?? '취소',
            onPressed: onCancel!,
            backgroundColor: Colors.grey[700],
            textColor: Colors.white,
          ),
        ),
      ],
    ];

    return Dialog(
      backgroundColor: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: buttonWidgets,
            ),
          ],
        ),
      ),
    );
  }
}
