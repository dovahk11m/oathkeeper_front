import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/chat/chat_message.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.read(dioProvider));
});

/// 채팅 API (REST - 이전 메시지 조회만)
class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  /// 이전 메시지 목록 조회 (REST API)
  Future<List<ChatMessage>> getMessages(int groupId) async {
    try {
      final response = await _dio.get('/groups/$groupId/chat/messages');
      final dataObject = response.data['data'] as Map<String, dynamic>?;
      if (dataObject == null) {
        throw Exception("응답에 'data' 필드가 없습니다.");
      }

      final contentList = dataObject['content'] as List?;
      if (contentList == null) {
        return []; // 빈 리스트 반환
      }

      return contentList
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList();
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

