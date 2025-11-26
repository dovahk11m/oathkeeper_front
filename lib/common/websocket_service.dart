import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../domain/members/member.dart';

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(ref);
});

/// WebSocket 초기화 상태 관리
final websocketInitProvider = FutureProvider<void>((ref) async {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (!isLoggedIn) return;

  final service = ref.watch(websocketServiceProvider);
  try {
    await service.connect();
  } catch (e) {
    print('[WebSocket Init] 초기 연결 실패: $e');
  }
});

/// WebSocket/STOMP 연결 관리 서비스
class WebSocketService {
  final Ref _ref;
  StompClient? _stompClient;
  bool _isConnected = false;
  final Map<int, dynamic> _subscriptions = {}; // 구독 중복 방지

  String get _wsChatUrl =>
      dotenv.env['WS_CHAT_URL'] ?? 'ws://10.0.2.2:8080/ws';

  WebSocketService(this._ref);

  bool get isConnected => _isConnected;

  /// WebSocket 연결
  Future<void> connect() async {
    if (_isConnected && _stompClient != null) {
      print('[WebSocket] 이미 연결됨');
      return;
    }

    print('[WebSocket] 토큰 가져오는 중');
    final token = await _ref.read(authProvider.notifier).getAccessToken();
    if (token == null) {
      print('[WebSocket] 토큰 없음');
      throw Exception('토큰이 없습니다');
    }

    final wsUrl = _wsChatUrl;
    print('[WebSocket] 연결 시작: $wsUrl');
    _stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (frame) {
          _isConnected = true;
          print('[WebSocket] 연결 성공');
        },
        onDisconnect: (frame) {
          _isConnected = false;
          print('[WebSocket] 연결 해제');
        },
        onStompError: (frame) {
          _isConnected = false;
          print('[WebSocket] STOMP 에러: ${frame.body}');
        },
        onWebSocketError: (error) {
          _isConnected = false;
          print('[WebSocket] WebSocket 에러: $error');
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
      _stompClient?.deactivate();
      _stompClient = null;
      throw Exception('WebSocket 연결 실패');
    }
  }

  /// 채팅방 구독
  Future<void> subscribeToChatRoom(
      int groupId, Function(Map<String, dynamic>) onMessage) async {
    // 연결되지 않았으면 연결 시도
    if (!_isConnected || _stompClient == null) {
      print('[WebSocket] 연결 시도');
      await connect();
    }

    // 이미 구독 중이면 기존 구독 취소 후 재구독
    if (_subscriptions.containsKey(groupId)) {
      print('[WebSocket] 그룹 $groupId 기존 구독 취소 후 재구독');
      final oldSubscription = _subscriptions[groupId];
      if (oldSubscription != null) {
        oldSubscription();
      }
      _subscriptions.remove(groupId);
    }

    print('[WebSocket] 그룹 $groupId 구독 시작');
    final subscription = _stompClient!.subscribe(
      destination: '/topic/chat/groups/$groupId',
      callback: (frame) {
        if (frame.body != null) {
          final message = frame.body!;
          print('[WebSocket] 메시지 수신 그룹 $groupId: $message');
          onMessage({'raw': message});
        }
      },
    );

    _subscriptions[groupId] = subscription;
    print('[WebSocket] 그룹 $groupId 구독 완료');
  }

  /// 채팅방 구독 취소
  void unsubscribeFromChatRoom(int groupId) {
    final subscription = _subscriptions[groupId];
    if (subscription != null) {
      print('[WebSocket] 그룹 $groupId 구독 취소');
      subscription();
      _subscriptions.remove(groupId);
    } else {
      print('[WebSocket] 그룹 $groupId 구독되지 않음');
    }
  }

  /// 개인 알림 구독 (그룹 초대 등)
  Future<void> subscribeToPersonalNotifications(Function(Map<String, dynamic>) onNotification) async {
    if (!_isConnected || _stompClient == null) {
      print('[WebSocket] 연결 시도');
      await connect();
    }

    // 이미 구독 중이면 무시
    if (_subscriptions.containsKey(-1)) {
      print('[WebSocket] 개인 알림 이미 구독됨');
      return;
    }

    print('[WebSocket] 개인 알림 구독 시작');
    final subscription = _stompClient!.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) {
        if (frame.body != null) {
          final message = frame.body!;
          print('[WebSocket] 개인 알림 수신: $message');
          onNotification({'raw': message});
        }
      },
    );

    _subscriptions[-1] = subscription;
    print('[WebSocket] 개인 알림 구독 완료');
  }

  /// 메시지 전송
  void sendMessage(int groupId, String content, {int? planId}) {
    if (!_isConnected || _stompClient == null) {
      print('[WebSocket] 메시지 전송 실패: WebSocket 미연결');
      throw Exception('WebSocket이 연결되지 않았습니다');
    }

    final body = {
      'content': content,
      if (planId != null) 'planId': planId,
    };

    print('[WebSocket] 메시지 전송 그룹 $groupId: $content');
    _stompClient!.send(
      destination: '/app/chat/groups/$groupId/message',
      body: _encodeJson(body),
    );
    print('[WebSocket] 메시지 전송 완료');
  }

  /// 재연결
  Future<void> reconnect() async {
    print('[WebSocket] 재연결 시도');
    disconnect();
    await connect();
    print('[WebSocket] 재연결 완료');
  }

  /// 연결 해제
  void disconnect() {
    print('[WebSocket] 연결 해제');
    _subscriptions.clear();
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
