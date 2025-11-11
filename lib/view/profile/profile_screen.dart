import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/design_tokens.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';
import 'package:oath_client/domain/members/profile/profile_provider.dart';

/// 내 정보 화면
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).getProfile());
  }

  @override
  Widget build(BuildContext context) {
    // 다른 화면에서 로그아웃 했을 경우를 대비하여 프로필 화면이 다시 빌드될 때
    // 로그인 상태가 아니라면 프로필을 다시 불러오지 않도록 방어 로직 추가
    ref.listen(authProvider.select((value) => value.auth), (previous, next) {
      if (next != null && previous?.id != next.id) {
        ref.read(profileProvider.notifier).getProfile();
      }
    });

    return Scaffold(
      backgroundColor: AppDesign.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppDesign.backgroundColor,
        elevation: AppDesign.elevationSmall,
        shadowColor: Colors.black.withOpacity(0.05),
        title: const Text(
          '내 정보',
          style: TextStyle(
            color: AppDesign.textPrimary,
            fontSize: AppDesign.fontSizeHeading,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppDesign.textPrimary),
            onPressed: () {
              context.go('/home/profile/edit');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppDesign.paddingMedium),
            const _ProfileHeader(),
            const SizedBox(height: AppDesign.paddingMedium),
            const _MenuList(),
            const SizedBox(height: AppDesign.paddingMedium),
            const _LogoutButton(),
            SizedBox(
                height: MediaQuery.of(context).padding.bottom +
                    AppDesign.paddingMedium),
          ],
        ),
      ),
    );
  }
}

/// 프로필 이미지와 사용자 이름을 보여주는 헤더 위젯
class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    if (profileState.isLoading && profileState.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profileState.error != null && profileState.profile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDesign.paddingMedium),
          child: Text(
            '프로필을 불러오는 중 오류가 발생했습니다.\n${profileState.error}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppDesign.textSecondary),
          ),
        ),
      );
    }

    // 로그아웃 직후 잠시 이전 프로필이 보이는 것을 방지
    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) {
      return const Center(child: CircularProgressIndicator());
    }

    final profile = profileState.profile;
    final profileImageUrl = profile?.profileImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.paddingMedium),
      child: Container(
        padding: const EdgeInsets.all(AppDesign.paddingLarge),
        decoration: BoxDecoration(
          color: AppDesign.backgroundColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppDesign.primaryColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppDesign.surfaceColor,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.person,
                            size: 50, color: AppDesign.textSecondary)
                        : null,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppDesign.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppDesign.backgroundColor, width: 2),
                    ),
                    child:
                        const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.paddingMedium),
            Text(
              profile?.username ?? '사용자',
              style: const TextStyle(
                fontSize: AppDesign.fontSizeHeading,
                fontWeight: FontWeight.w700,
                color: AppDesign.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppDesign.paddingSmall),
            Text(
              profile?.email ?? '',
              style: const TextStyle(
                fontSize: AppDesign.fontSizeBody,
                color: AppDesign.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 메뉴 리스트 위젯
class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.paddingMedium),
      child: Container(
        decoration: BoxDecoration(
          color: AppDesign.backgroundColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _MenuItem(
              icon: Icons.person_outline,
              title: '계정 관리',
              onTap: () => context.go('/home/profile/edit'),
            ),
            const Divider(height: 1, indent: 56),
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: '알림 설정',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            _MenuItem(
              icon: Icons.help_outline,
              title: '도움말',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            _MenuItem(
              icon: Icons.info_outline,
              title: '앱 정보',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.paddingMedium,
            vertical: AppDesign.paddingMedium,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppDesign.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMedium),
                ),
                child: Icon(icon, color: AppDesign.primaryColor, size: 24),
              ),
              const SizedBox(width: AppDesign.paddingMedium),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDesign.fontSizeBody,
                    fontWeight: FontWeight.w500,
                    color: AppDesign.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppDesign.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 로그아웃 버튼 위젯
class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.paddingMedium),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppDesign.backgroundColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('로그아웃',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                // 프로필 상태를 먼저 초기화합니다.
                ref.read(profileProvider.notifier).reset();
                // 그 다음 로그아웃을 처리합니다.
                await ref.read(authProvider.notifier).logout();
              }
            },
            borderRadius: BorderRadius.circular(AppDesign.radiusLarge),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppDesign.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red.shade400, size: 20),
                  const SizedBox(width: AppDesign.paddingSmall),
                  Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: AppDesign.fontSizeBody,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
