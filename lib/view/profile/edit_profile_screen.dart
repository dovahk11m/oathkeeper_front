import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/widgets/custom_alert_dialog.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';

/// 내 정보 수정 화면
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _usernameController;
  late final String _initialUsername;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initialUsername = ref.read(profileProvider).profile?.username ?? '';
    _usernameController = TextEditingController(text: _initialUsername);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onProfileImageTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // 바텀시트 배경은 흰색
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('앨범에서 사진 선택'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
              if (ref.read(profileProvider).profile?.profileImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('프로필 사진 삭제',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _deleteImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await ref.read(profileProvider.notifier).uploadImage(image.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 이미지가 변경되었습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드에 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _deleteImage() async {
    try {
      await ref.read(profileProvider.notifier).deleteImage();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필 이미지가 삭제되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 삭제에 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    final newUsername = _usernameController.text;

    if (newUsername == _initialUsername) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return CustomAlertDialog(
            contentText: '변경사항이 없습니다.\n수정을 취소할까요?',
            onConfirm: () {
              Navigator.of(dialogContext).pop();
              context.go('/home/profile');
            },
            onCancel: () => Navigator.of(dialogContext).pop(),
          );
        },
      );
      return;
    }

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 이름은 비워둘 수 없습니다.')),
      );
      return;
    }

    final dto = ProfileUpdateDto(username: newUsername);

    try {
      await ref.read(profileProvider.notifier).updateProfile(dto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 성공적으로 수정되었습니다.')),
        );
        context.go('/home/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 수정에 실패했습니다: $e')),
        );
      }
    }
  }

  void _onPasswordChangeTap() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('비밀번호 확인'),
          content: CustomTextFormField(
            controller: passwordController,
            labelText: '현재 비밀번호를 입력하세요',
            obscureText: true,
            isLight: true, // AlertDialog는 밝은 배경이므로 isLight: true
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final currentPassword = passwordController.text;
                if (currentPassword.isNotEmpty) {
                  Navigator.of(dialogContext).pop();
                  context.go('/home/profile/edit/password',
                      extra: currentPassword);
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileImageUrl = profileState.profile?.profileImageUrl;

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
          title: const Text('내 정보 수정',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _onProfileImageTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white24,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl)
                          : null,
                      child: profileImageUrl == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                controller: _usernameController,
                labelText: '사용자 이름',
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white30),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.lock_outline, color: Colors.white),
                title: const Text('비밀번호 변경',
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.white70),
                onTap: _onPasswordChangeTap,
              ),
              const Divider(color: Colors.white30),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: profileState.isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: profileState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('수정 완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
