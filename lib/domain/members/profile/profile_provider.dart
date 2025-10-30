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
    // build 메소드에서는 초기 상태만 반환하고, 데이터 요청은 UI에서 직접 트리거합니다.
    return const ProfileState();
  }

  /// [회원 정보 조회]
  Future<void> getProfile() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(error: "로그인 정보가 없습니다.");
      return;
    }

    // 이미 데이터가 있거나 로딩 중이면 중복 요청 방지
    if (state.profile != null && !state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.get('/member/$memberId');
      final profileData = response.data['data'] as Map<String, dynamic>;
      final profile = Profile.fromJson(profileData);

      state = state.copyWith(profile: profile, isLoading: false);
      print("[ProfileNotifier] 회원 정보 조회 성공: ${profile.username}");
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
    if (memberId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _dio.put(
        '/member/$memberId',
        data: dto.toJson(),
      );
      final profileData = response.data['data'] as Map<String, dynamic>;
      final profile = Profile.fromJson(profileData);

      state = state.copyWith(profile: profile, isLoading: false);
      print("[ProfileNotifier] 회원 정보 수정 성공");

      _updateAuthProvider(profile);
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
      throw Exception('로그인 정보가 없습니다.');
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

      final newImageUrl = response.data['data'] as String;
      print("[ProfileNotifier] 이미지 업로드 성공: $newImageUrl");

      final updatedProfile =
          state.profile?.copyWith(profileImageUrl: newImageUrl);
      state = state.copyWith(profile: updatedProfile, isLoading: false);
      _updateAuthProvider(updatedProfile);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "이미지 업로드에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      throw Exception(errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      throw Exception('알 수 없는 오류로 이미지 업로드에 실패했습니다.');
    }
  }

  /// [프로필 이미지 삭제]
  Future<void> deleteImage() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      throw Exception('로그인 정보가 없습니다');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _dio.delete('/member/profile/delete/$memberId');
      print("[ProfileNotifier] 이미지 삭제 성공");

      final updatedProfile = state.profile?.copyWith(profileImageUrl: null);
      state = state.copyWith(profile: updatedProfile, isLoading: false);
      _updateAuthProvider(updatedProfile);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "이미지 삭제에 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
      throw Exception(errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      throw Exception('알 수 없는 오류로 이미지 삭제에 실패했습니다.');
    }
  }

  /// [회원 탈퇴]
  Future<bool> deleteAccount() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _dio.delete('/member/$memberId');
      print("[ProfileNotifier] 회원 탈퇴 성공");

      await ref.read(authProvider.notifier).logout();
      state = const ProfileState();
      return true;
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
    ref.read(authProvider.notifier).state = ref.read(authProvider).copyWith(
        auth: ref.read(authProvider).auth?.copyWith(
              username: profile.username,
              profileImageUrl: profile.profileImageUrl,
            ));
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
