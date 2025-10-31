import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/domain/members/member.dart';

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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kAppGradientStart, kAppGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('내 정보',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {
                context.go('/home/profile/edit');
              },
            ),
          ],
        ),
        body: const Column(
          children: [
            SizedBox(height: 20),
            _ProfileHeader(),
            SizedBox(height: 20),
            _MenuList(),
            Spacer(),
            _LogoutButton(),
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
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    if (profileState.error != null && profileState.profile == null) {
      return Center(
        child: Text(
          '프로필을 불러오는 중 오류가 발생했습니다.\n${profileState.error}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    final profile = profileState.profile;
    final profileImageUrl = profile?.profileImageUrl;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white24,
          backgroundImage:
              profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
          child: profileImageUrl == null
              ? const Icon(Icons.person, size: 50, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile?.username ?? '사용자',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// 메뉴 리스트 위젯
class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline, color: Colors.white),
          title: const Text('계정 관리', style: TextStyle(color: Colors.white)),
          onTap: () {
            context.go('/home/profile/edit');
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.white),
          title: const Text('도움말', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.info_outline, color: Colors.white),
          title: const Text('앱 정보', style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ],
    );
  }
}

/// 로그아웃 버튼 위젯
class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
          child: const Text('로그아웃'),
        ),
      ),
    );
  }
}
