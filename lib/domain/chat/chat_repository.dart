import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/chat/chat_message.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.read(dioProvider));
});

/// 채팅 API
class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  /// 메시지 목록 조회
  Future<List<ChatMessage>> getMessages(int chatRoomId) async {
    try {
      final response = await _dio.get('/chat/$chatRoomId/messages');
      final data = response.data['data'] as List;
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 메시지 전송
  Future<ChatMessage> sendMessage({
    required int chatRoomId,
    required String content,
    String messageType = 'TEXT',
  }) async {
    try {
      final response = await _dio.post(
        '/chat/$chatRoomId/messages',
        data: {
          'content': content,
          'messageType': messageType,
        },
      );
      return ChatMessage.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 에러 메시지 파싱
  String _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
          return data['error']?['message'] ?? '알 수 없는 오류가 발생했습니다.';
        }
      }
      return '서버 연결에 실패했습니다.';
    }
    return e.toString();
  }
}

