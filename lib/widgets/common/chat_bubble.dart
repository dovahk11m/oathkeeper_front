import 'package:flutter/material.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/chat/chat_message.dart';

/// 채팅 메시지 버블 위젯
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final VoidCallback? onLongPress;
  final VoidCallback? onRetry;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onLongPress,
    this.onRetry,
  });

  String _formatTime(String sentAt) {
    try {
      final dateTime = DateTime.parse(sentAt);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? '오전' : '오후';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$period $displayHour:$minute';
    } catch (e) {
      return sentAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 60 : AppDesign.spacing16,
        right: isMe ? AppDesign.spacing16 : 60,
        bottom: AppDesign.spacing8,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.status == MessageStatus.pending)
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: AppDesign.textTertiary,
                  )
                else if (message.status == MessageStatus.failed)
                  GestureDetector(
                    onTap: onRetry,
                    child: Icon(
                      Icons.error,
                      size: 14,
                      color: AppDesign.errorColor,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(message.sentAt),
                  style: TextStyle(
                    fontSize: AppDesign.fontSizeCaption,
                    color: AppDesign.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppDesign.spacing4),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spacing12,
                  vertical: AppDesign.spacing8,
                ),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          colors: message.status == MessageStatus.failed
                              ? [
                                  AppDesign.errorColor.withValues(alpha: 0.3),
                                  AppDesign.errorColor.withValues(alpha: 0.2),
                                ]
                              : [
                                  AppDesign.chatMyBubble,
                                  AppDesign.primaryLight,
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isMe ? null : AppDesign.chatOtherBubble,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    fontSize: AppDesign.fontSizeBody,
                    color: isMe ? Colors.white : AppDesign.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          if (!isMe) ...[
            const SizedBox(width: AppDesign.spacing4),
            Text(
              _formatTime(message.sentAt),
              style: TextStyle(
                fontSize: AppDesign.fontSizeCaption,
                color: AppDesign.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

