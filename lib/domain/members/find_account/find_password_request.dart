import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_password_request.freezed.dart';
part 'find_password_request.g.dart';

/// 비밀번호 찾기 요청 DTO
@freezed
class FindPasswordRequest with _$FindPasswordRequest {
  const factory FindPasswordRequest({
    required String email,
  }) = _FindPasswordRequest;

  factory FindPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$FindPasswordRequestFromJson(json);
}
