import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/members/member.dart';

import 'profile.dart';
import 'profile_state.dart';
import 'profile_update_dto.dart';

// =======================================================================
// 1. 창고 관리자 (Notifier)
// =======================================================================

class ProfileNotifier extends Notifier<ProfileState> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  ProfileState build() {
    return const ProfileState();
  }

  /// [회원 정보 조회]
  Future<void> getProfile() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(error: "로그인 정보가 없습니다.");
      return;
    }

    if (state.profile != null && !state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.get('/member/$memberId');
      if (response.statusCode == 200 && response.data['success']) {
        final profileData = response.data['data'] as Map<String, dynamic>;
        final profile = Profile.fromJson(profileData);
        state = state.copyWith(isLoading: false, profile: profile);
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '프로필 조회에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
    }
  }

  /// [회원 정보 수정]
  Future<void> updateProfile(ProfileUpdateDto dto) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(error: "로그인 정보가 없습니다.");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.put(
        '/member/$memberId',
        data: dto.toJson(),
      );
      if (response.statusCode == 200 && response.data['success']) {
        final profileData = response.data['data'] as Map<String, dynamic>;
        final profile = Profile.fromJson(profileData);

        state = state.copyWith(isLoading: false, profile: profile);
        _updateAuthProvider(profile);
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '프로필 수정에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
    }
  }

  /// [프로필 이미지 업로드]
  Future<void> uploadImage(String imagePath) async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(error: '로그인 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final file = File(imagePath);
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _dio.post(
        '/member/profile/upload/$memberId',
        data: formData,
      );

      if (response.statusCode == 200 && response.data['success']) {
        final newImageUrl = response.data['data'] as String;
        final updatedProfile =
            state.profile?.copyWith(profileImageUrl: newImageUrl);

        state = state.copyWith(isLoading: false, profile: updatedProfile);
        _updateAuthProvider(updatedProfile);
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '이미지 업로드에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
    }
  }

  /// [프로필 이미지 삭제]
  Future<void> deleteImage() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(error: '로그인 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.delete('/member/profile/delete/$memberId');

      if (response.statusCode == 200 && response.data['success']) {
        final updatedProfile = state.profile?.copyWith(profileImageUrl: null);
        state = state.copyWith(isLoading: false, profile: updatedProfile);
        _updateAuthProvider(updatedProfile);
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '이미지 삭제에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
    }
  }

  /// [회원 탈퇴]
  Future<bool> deleteAccount() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.delete('/member/$memberId');

      if (response.statusCode == 200 && response.data['success']) {
        await ref.read(authProvider.notifier).logout();
        state = const ProfileState();
        return true;
      } else {
        final errorMessage =
            response.data?['error']?['message'] ?? '회원 탈퇴에 실패했습니다.';
        state = state.copyWith(isLoading: false, error: errorMessage);
        return false;
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
      return false;
    }
  }

  void _updateAuthProvider(Profile? profile) {
    if (profile == null) return;
    final authState = ref.read(authProvider);
    if (authState.auth != null) {
      ref.read(authProvider.notifier).state = authState.copyWith(
            auth: authState.auth!.copyWith(
                  username: profile.username,
                  profileImageUrl: profile.profileImageUrl,
                ),          );
    }
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
