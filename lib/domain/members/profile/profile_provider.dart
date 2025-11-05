import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
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
      final apiResponse = ApiResponse<Profile>.fromJson(
        response.data,
        (json) => Profile.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        state = state.copyWith(isLoading: false, profile: apiResponse.data);
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "프로필 조회에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
      final response = await _dio.put('/member/$memberId', data: dto.toJson());
      final apiResponse = ApiResponse<Profile>.fromJson(
        response.data,
        (json) => Profile.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        state = state.copyWith(isLoading: false, profile: apiResponse.data);
        _updateAuthProvider(apiResponse.data);
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "프로필 수정에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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

      final response =
          await _dio.post('/member/profile/upload/$memberId', data: formData);
      final apiResponse =
          ApiResponse<String>.fromJson(response.data, (json) => json as String);

      if (apiResponse.success && apiResponse.data != null) {
        final updatedProfile =
            state.profile?.copyWith(profileImageUrl: apiResponse.data);
        state = state.copyWith(isLoading: false, profile: updatedProfile);
        _updateAuthProvider(updatedProfile);
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "이미지 업로드에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
      final apiResponse = ApiResponse.fromJson(response.data, null);

      if (apiResponse.success) {
        final updatedProfile = state.profile?.copyWith(profileImageUrl: null);
        state = state.copyWith(isLoading: false, profile: updatedProfile);
        _updateAuthProvider(updatedProfile);
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "이미지 삭제에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// [회원 탈퇴]
  Future<bool> deleteAccount() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.delete('/member/$memberId');
      final apiResponse = ApiResponse.fromJson(response.data, null);

      if (apiResponse.success) {
        await ref.read(authProvider.notifier).logout();
        state = const ProfileState();
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: apiResponse.message);
        return false;
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "회원 탈퇴에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
        ),
      );
    }
  }
}

// =======================================================================
// 2. 창고 (Provider)
// =======================================================================

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
