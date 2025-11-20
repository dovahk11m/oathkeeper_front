import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/plans/plan.dart';
import 'package:oath_client/widgets/common/common_components.dart'
    as common_components;
import 'package:oath_client/widgets/common/profile_avatar.dart';
import 'package:intl/intl.dart';
import 'package:oath_client/domain/plans/plan_provider.dart';

/// 약속 카드 (토스 스타일)
class PlanCard extends ConsumerWidget {
  final Plan plan;

  const PlanCard({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('M월 d일 HH:mm');

    return common_components.AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDesign.spacing16,
        vertical: AppDesign.spacing8,
      ),
      padding: const EdgeInsets.all(AppDesign.spacing20),
      onTap: () {
        // TODO: 약속 상세 화면
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.title,
                  style: const TextStyle(
                    fontSize: AppDesign.fontSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppDesign.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spacing8),
              _buildStatusBadge(plan.status),
            ],
          ),
          const SizedBox(height: AppDesign.spacing12),
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            text: dateFormat.format(plan.planDatetime),
          ),
          if (plan.location != null) ...[
            const SizedBox(height: AppDesign.spacing8),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              text: plan.location!,
            ),
          ],
          if (plan.lateFineAmount != null) ...[
            const SizedBox(height: AppDesign.spacing8),
            _buildInfoRow(
              icon: Icons.payments_outlined,
              text: '지각 벌금 ${plan.lateFineAmount}원',
              color: AppDesign.warningColor,
            ),
          ],
          const SizedBox(height: AppDesign.spacing16),
          const Divider(height: 1),
          const SizedBox(height: AppDesign.spacing12),
          Row(
            children: [
              _buildParticipantsStack(),
              const SizedBox(width: AppDesign.spacing8),
              Text(
                '${plan.participants.length + 1}명 참가',
                style: const TextStyle(
                  fontSize: AppDesign.fontSizeBody,
                  fontWeight: FontWeight.w600,
                  color: AppDesign.textSecondary,
                ),
              ),
              const Spacer(),
              // 생성자일 때만 보이는 간단한 '종료' 버튼 (서버 호출)
              if (plan.status.toUpperCase() != 'COMPLETED')
                TextButton(
                  onPressed: () async {
                    final should = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('약속 종료'),
                        content: const Text('이 약속을 완료 상태로 변경하시겠습니까?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('취소')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('종료')),
                        ],
                      ),
                    );

                    if (should == true) {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('약속 종료 요청 전송 중...')));
                        await ref
                            .read(planProvider.notifier)
                            .completePlan(plan.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('약속이 완료 처리되었습니다')));
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('종료 실패: $e')));
                      }
                    }
                  },
                  child: const Text('종료'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDesign.iconSmall,
          color: color ?? AppDesign.textTertiary,
        ),
        const SizedBox(width: AppDesign.spacing4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppDesign.fontSizeBody,
              color: color ?? AppDesign.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsStack() {
    final displayCount =
        plan.participants.length > 3 ? 3 : plan.participants.length;

    return SizedBox(
      width: 24.0 + (displayCount * 16.0),
      height: 32,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * 16.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ProfileAvatar(
                  name: plan.participants[i].memberNickname,
                  imageUrl: plan.participants[i].memberProfileImageUrl,
                  size: 28,
                ),
              ),
            ),
          if (plan.participants.length > 3)
            Positioned(
              left: 3 * 16.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppDesign.surfaceColor,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+${plan.participants.length - 3}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppDesign.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status.toUpperCase()) {
      case 'PLANNING':
        backgroundColor = AppDesign.primaryLight.withValues(alpha: 0.2);
        textColor = AppDesign.primaryColor;
        label = '계획중';
        break;
      case 'CONFIRMED':
        backgroundColor = AppDesign.successColor.withValues(alpha: 0.2);
        textColor = AppDesign.successColor;
        label = '확정';
        break;
      case 'COMPLETED':
        backgroundColor = AppDesign.textTertiary.withValues(alpha: 0.2);
        textColor = AppDesign.textSecondary;
        label = '완료';
        break;
      case 'CANCELLED':
        backgroundColor = AppDesign.errorColor.withValues(alpha: 0.2);
        textColor = AppDesign.errorColor;
        label = '취소';
        break;
      default:
        backgroundColor = AppDesign.surfaceColor;
        textColor = AppDesign.textSecondary;
        label = status;
    }

    return common_components.Badge(
      text: label,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
