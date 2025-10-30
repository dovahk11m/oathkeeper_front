import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:oath_client/domain/auth/auth_provider.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(ref);
});

/// WebSocket/STOMP 연결 관리 서비스
class WebSocketService {
  final Ref _ref;
  StompClient? _stompClient;
  bool _isConnected = false;

  WebSocketService(this._ref);

  bool get isConnected => _isConnected;

  /// WebSocket 연결
  Future<void> connect() async {
    if (_isConnected && _stompClient != null) return;

    final token = await _ref.read(authProvider.notifier).getAccessToken();
    if (token == null) {
      throw Exception('토큰이 없습니다');
    }

    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/ws',
        onConnect: (frame) {
          _isConnected = true;
          print('[WebSocket] 연결됨');
        },
        onDisconnect: (frame) {
          _isConnected = false;
          print('[WebSocket] 연결 해제됨');
        },
        onStompError: (frame) {
          print('[WebSocket] STOMP 에러: ${frame.body}');
          _isConnected = false;
        },
        onWebSocketError: (error) {
          print('[WebSocket] 에러: $error');
          _isConnected = false;
        },
        // WebSocket 핸드셰이크 시 Authorization 헤더 전달
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        // STOMP CONNECT 프레임에도 Authorization 헤더 전달
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },
        reconnectDelay: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 20),
        heartbeatOutgoing: const Duration(seconds: 20),
      ),
    );

    _stompClient!.activate();

    // 연결 대기 (최대 5초)
    int attempts = 0;
    while (!_isConnected && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (!_isConnected) {
      print('[WebSocket] 연결 타임아웃');
      _stompClient?.deactivate();
      _stompClient = null;
      throw Exception('WebSocket 연결 실패');
    }
  }

  /// 채팅방 구독
  Future<void> subscribeToChatRoom(int groupId, Function(Map<String, dynamic>) onMessage) async {
    // 연결되지 않았으면 연결 시도
    if (!_isConnected || _stompClient == null) {
      await connect();
    }

    _stompClient!.subscribe(
      destination: '/topic/chat/groups/$groupId',
      callback: (frame) {
        if (frame.body != null) {
          try {
            final message = frame.body!;
            onMessage({'raw': message});
          } catch (e) {
            print('[WebSocket] 메시지 파싱 실패: $e');
          }
        }
      },
    );
  }

  /// 메시지 전송
  void sendMessage(int groupId, String content, {int? planId}) {
    if (!_isConnected || _stompClient == null) {
      throw Exception('WebSocket이 연결되지 않았습니다');
    }

    final body = {
      'content': content,
      if (planId != null) 'planId': planId,
    };

    _stompClient!.send(
      destination: '/app/chat/groups/$groupId/message',
      body: _encodeJson(body),
    );
  }

  /// 연결 해제
  void disconnect() {
    if (_stompClient != null) {
      _stompClient!.deactivate();
      _stompClient = null;
      _isConnected = false;
    }
  }

  String _encodeJson(Map<String, dynamic> data) {
    return '{"content":"${data['content']}"${data['planId'] != null ? ',"planId":${data['planId']}' : ''}}';
  }
}

