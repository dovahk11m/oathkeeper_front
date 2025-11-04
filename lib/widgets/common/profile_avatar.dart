import 'package:flutter/material.dart';
import 'package:oath_client/constants/design_tokens.dart';

/// 공통 프로필 아바타 위젯
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showBadge;
  final int? badgeCount;
  final bool showRing;
  final Color? ringColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = AppDesign.profileMedium,
    this.showBadge = false,
    this.badgeCount,
    this.showRing = false,
    this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 링 (읽지 않은 메시지 강조)
        if (showRing)
          Container(
            width: size + 4,
            height: size + 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ringColor ?? AppDesign.primaryColor,
                  ringColor?.withValues(alpha: 0.6) ?? AppDesign.primaryLight,
                ],
              ),
            ),
            child: Center(
              child: _buildAvatar(),
            ),
          )
        else
          _buildAvatar(),

        // 배지
        if (showBadge && (badgeCount ?? 0) > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spacing4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppDesign.unreadBadge,
                borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Center(
                child: Text(
                  badgeCount! > 99 ? '99+' : '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppDesign.primaryLight.withValues(alpha: 0.2),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w600,
                  color: AppDesign.primaryColor,
                ),
              ),
            )
          : null,
    );
  }
}

