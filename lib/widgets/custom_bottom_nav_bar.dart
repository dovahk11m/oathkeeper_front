import 'package:flutter/material.dart';
import 'package:oath_client/constants/design_tokens.dart';

/// 하단 네비게이션 바 (개선된 스타일)
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppDesign.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: '채팅',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: '약속',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.star_outline,
                activeIcon: Icons.star,
                label: '후기',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '내 정보',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: AppDesign.animationFast,
          curve: AppDesign.animationCurve,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: AppDesign.animationFast,
                curve: AppDesign.animationCurve,
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected
                      ? AppDesign.primaryColor
                      : AppDesign.textTertiary,
                  size: isSelected ? 26 : 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppDesign.primaryColor
                      : AppDesign.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

