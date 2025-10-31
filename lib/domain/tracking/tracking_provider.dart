import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:oath_client/domain/members/member.dart'; // tokenInterceptorProvider
import 'tracking_repository.dart';
import 'package:oath_client/common/token_interceptor.dart';



final dioWithAuthProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(ref.read(tokenInterceptorProvider)); // 기존 토큰 인터셉터 재사용
  return dio;
});

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepository(ref.read(dioWithAuthProvider));
});
