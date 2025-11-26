import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tracking_repository.dart';
import 'package:oath_client/common/utils/http_util.dart'; // dioProvider

/// dioProvider를 재사용해 인증/로깅 정책 일관 유지
final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  return TrackingRepository(dio);
});
