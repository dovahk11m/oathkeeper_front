import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oath_client/domain/members/profile/profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    Profile? profile,
    @Default(false) bool isLoading,
    String? error,
  }) = _ProfileState;
}
