import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oath_client/common/utils/http_util.dart';
import 'package:oath_client/constants/theme.dart';
import 'package:oath_client/domain/members/member.dart';
import 'package:oath_client/widgets/custom_alert_dialog.dart';
import 'package:oath_client/widgets/custom_text_form_field.dart';
import 'package:oath_client/widgets/password_check_dialog.dart';

/// 내 정보 수정 화면
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _usernameController;
  late final String _initialUsername;
  late final String? _initialProfileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).profile;
    _initialUsername = profile?.username ?? '';
    _initialProfileImageUrl = profile?.profileImageUrl;
    _usernameController = TextEditingController(text: _initialUsername);

    // 위젯 트리가 빌드된 후 상태를 초기화하여 에러를 방지합니다.
    Future(() {
      ref.read(passwordProvider.notifier).resetState();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // 비밀번호 확인 상태 변화를 감지하고 UI에 피드백을 주는 리스너
  void _listenPasswordState(PasswordState? previous, PasswordState next) {
    final wasLoading = previous?.isLoading ?? false;

    // 로딩 시작
    if (next.isLoading && !wasLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    } else if (!next.isLoading && wasLoading) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
    }

    // 에러 발생
    if (next.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.errorMessage!)),
      );
      ref.read(passwordProvider.notifier).resetState(); // 에러 상태 초기화
    }
    // 비밀번호 확인 성공
    else if (next.isPasswordChecked) {
      context.go('/home/profile/edit/password'); // 비밀번호 변경 화면으로 이동
    }
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
        await ref.read(profileProvider.notifier).getProfile();
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

    final currentProfileState = ref.read(profileProvider);
    final currentProfileImageUrl = currentProfileState.profile?.profileImageUrl;

    final isUploading = currentProfileState.isLoading &&
        currentProfileState.tempImageBytes != null;

    if (isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 업로드 중입니다. 잠시만 기다려주세요.')),
      );
      return; // 업로드 중이면 저장 막기
    }

    final bool isUsernameChanged = newUsername != _initialUsername;
    final bool isImageChanged =
        currentProfileImageUrl != _initialProfileImageUrl;

    if (!isUsernameChanged && !isImageChanged) {
      showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
          title: '프로필 변경사항 없음',
          content: '변경사항이 없습니다.\n수정을 취소할까요?',
          onConfirm: () {
            Navigator.of(context).pop();
            context.go('/home/profile');
          },
        ),
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
    showDialog(
      context: context,
      builder: (context) => const PasswordCheckDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 비밀번호 프로바이더의 상태 변화를 감지 (화면 이동, 다이얼로그 등 부수효과 처리)
    ref.listen<PasswordState>(passwordProvider, _listenPasswordState);

    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;
    final imageUrlPath = profile?.profileImageUrl;

    final Uint8List? tempBytes = profileState.tempImageBytes;

    ImageProvider? profileImageProvider;

    if (tempBytes != null && tempBytes.isNotEmpty) {
      profileImageProvider = MemoryImage(tempBytes);
    } else if (imageUrlPath != null && imageUrlPath.isNotEmpty) {
      profileImageProvider = NetworkImage(imageBaseUrl + imageUrlPath);
    } else {
      profileImageProvider = null;
    }

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
                      backgroundImage: profileImageProvider,
                      child: profileImageProvider == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                    if (profileState.isLoading)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(
                              24), // CircleAvatar 크기에 맞게 조절
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 20, color: Colors.white),
                      )
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
