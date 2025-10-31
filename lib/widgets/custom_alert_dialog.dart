import 'package:flutter/material.dart';
import 'package:oath_client/widgets/custom_elevated_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String contentText;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color confirmButtonColor;

  const CustomAlertDialog({
    super.key,
    required this.contentText,
    this.confirmText = '예',
    this.cancelText = '아니오',
    required this.onConfirm,
    required this.onCancel,
    this.confirmButtonColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contentText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: confirmText,
                    onPressed: onConfirm,
                    backgroundColor: confirmButtonColor,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomElevatedButton(
                    text: cancelText,
                    onPressed: onCancel,
                    backgroundColor: Colors.grey[700],
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
