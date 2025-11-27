// ============================================================
// [개발/테스트 전용 파일]
//
// 이 파일은 LiveMapPage를 단독으로 실행하여 테스트하기 위한 파일입니다.
// 프로덕션 빌드 전에 반드시 삭제하거나 test/ 디렉토리로 이동해야 합니다.
//
// 실행 방법:
// flutter run -t lib/view/live_map/test_main.dart
//
// TODO: 개발 완료 후 이 파일을 삭제하거나 test/ 디렉토리로 이동
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'live_map_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 네이버 지도 SDK 초기화 (클라이언트 ID만 필요)
  await FlutterNaverMap().init(
    clientId: "xb8jm8rjaa",
    onAuthFailed: (ex) {
      // 초기화 실패 시 콘솔에 확실히 찍혀야 원인 파악 가능
      debugPrint("NaverMap init failed: $ex");
    },
  );

  // 전역 에러 로깅
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LiveMapPage(planId: 1),
    );
  }
}
