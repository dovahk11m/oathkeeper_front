import 'dart:io';

/// Platform별 기본 URL 제공
///
/// 안드로이드 에뮬레이터는 localhost 대신 10.0.2.2를 사용해야 호스트 PC에 접속 가능
/// iOS 시뮬레이터 및 데스크톱은 localhost 사용
class PlatformDefaults {
  /// 안드로이드 에뮬레이터는 10.0.2.2, 나머지는 localhost
  static String get localhost {
    if (Platform.isAndroid) {
      return '10.0.2.2';
    }
    return 'localhost';
  }

  /// HTTP API 기본 URL (Spring Boot)
  static String get httpApi => 'http://$localhost:8080/api';

  /// 이미지 서버 기본 URL
  static String get httpImage => 'http://$localhost:8080';

  /// WebSocket 기본 URL (채팅)
  static String get wsChat => 'ws://$localhost:8080/ws';

  /// WebSocket 기본 URL (라이브맵 - STOMP)
  static String get wsLiveMap => 'ws://$localhost:8080/ws-stomp';

  /// AI 서버 기본 URL (FastAPI - 실제 네트워크 IP)
  static const String aiBase = 'http://192.168.0.3:8001';
}
