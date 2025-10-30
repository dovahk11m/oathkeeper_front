import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/members/auth/auth_provider.dart';

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
    // ProfileNotifier가 생성될 때 자동으로 프로필 정보를 로드합니다.
    // 로그인 상태일 때만 로드를 시도합니다.
    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (isLoggedIn) {
      getProfile();
    }
    return const ProfileState();
  }

  /// [회원 정보 조회]
  Future<void> getProfile() async {
    final memberId = ref.read(authProvider).auth?.id;
    if (memberId == null) {
      state = state.copyWith(error: "로그인 정보가 없습니다.");
      return;
    }

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

      // AuthProvider의 상태도 함께 업데이트하여 앱 전반에 반영합니다.
      ref.read(authProvider.notifier).state = ref.read(authProvider).copyWith(
          auth: ref.read(authProvider).auth?.copyWith(
                username: profile.username,
                profileImageUrl: profile.profileImageUrl,
              ));
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? "프로필 수정에 실패했습니다.";
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
      await _dio.delete('/member/$memberId');
      print("[ProfileNotifier] 회원 탈퇴 성공");

      // 탈퇴 성공 시 AuthProvider를 통해 로그아웃 처리
      await ref.read(authProvider.notifier).logout();
      state = const ProfileState(); // 프로필 상태 초기화
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
}

// =======================================================================
// 2. 창고 (Provider)
// =======================================================================

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
