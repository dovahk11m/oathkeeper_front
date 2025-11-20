import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/reviews/review.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.read(dioProvider));
});

class ReviewRepository {
  final Dio _dio;

  ReviewRepository(this._dio);

  /// 내가 작성한 후기 목록 조회
  Future<List<Review>> getMyReviews({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/reviews/my',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 조회 실패');
      }

      final data = response.data['data'];
      if (data == null) return [];

      // 페이지네이션 응답 처리
      if (data is Map && data['content'] is List) {
        return (data['content'] as List)
            .map((json) => Review.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('[ReviewRepo] 후기 API 엔드포인트가 존재하지 않습니다 (404). 서버 확인 필요.');
        return [];
      }
      print('[ReviewRepo] 후기 목록 조회 실패: $e');
      rethrow;
    } catch (e) {
      print('[ReviewRepo] 후기 목록 조회 실패: $e');
      rethrow;
    }
  }

  /// 약속별 후기 목록 조회
  Future<List<Review>> getReviewsByPlan(int planId) async {
    try {
      final response = await _dio.get('/reviews/plan/$planId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 조회 실패');
      }

      final data = response.data['data'];
      if (data == null) return [];

      if (data is List) {
        return data
            .map((json) => Review.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('[ReviewRepo] 약속별 후기 조회 실패: $e');
      rethrow;
    }
  }

  /// 후기 상세 조회
  Future<Review> getReview(int reviewId) async {
    try {
      final response = await _dio.get('/v1/reviews/$reviewId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 조회 실패');
      }

      return Review.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      print('[ReviewRepo] 후기 상세 조회 실패: $e');
      rethrow;
    }
  }

  /// 후기 생성
  Future<int> createReview(CreateReviewRequest request) async {
    try {
      final response = await _dio.post(
        '/v1/reviews',
        data: request.toJson(),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 작성 실패');
      }

      return response.data['data']['id'] as int;
    } catch (e) {
      print('[ReviewRepo] 후기 생성 실패: $e');
      rethrow;
    }
  }

  /// 후기 수정
  Future<void> updateReview(
      int reviewId, String content, double? rating) async {
    try {
      final response = await _dio.put(
        '/v1/reviews/$reviewId',
        data: {
          'content': content,
          if (rating != null) 'rating': rating,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 수정 실패');
      }
    } catch (e) {
      print('[ReviewRepo] 후기 수정 실패: $e');
      rethrow;
    }
  }

  /// 후기 삭제
  Future<void> deleteReview(int reviewId) async {
    try {
      final response = await _dio.delete('/v1/reviews/$reviewId');

      if (response.statusCode != 204 && response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 삭제 실패');
      }
    } catch (e) {
      print('[ReviewRepo] 후기 삭제 실패: $e');
      rethrow;
    }
  }

  /// 댓글 생성
  Future<Reply> createReply(int reviewId, String content) async {
    try {
      final response = await _dio.post(
        '/replies/review/$reviewId',
        data: {'content': content},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '댓글 작성 실패');
      }

      return Reply.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      print('[ReviewRepo] 댓글 생성 실패: $e');
      rethrow;
    }
  }

  /// 댓글 수정
  Future<Reply> updateReply(int replyId, String content) async {
    try {
      final response = await _dio.put(
        '/replies/$replyId',
        data: {'content': content},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '댓글 수정 실패');
      }

      return Reply.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      print('[ReviewRepo] 댓글 수정 실패: $e');
      rethrow;
    }
  }

  /// 댓글 삭제
  Future<void> deleteReply(int replyId) async {
    try {
      final response = await _dio.delete('/replies/$replyId');

      if (response.statusCode != 204 && response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '댓글 삭제 실패');
      }
    } catch (e) {
      print('[ReviewRepo] 댓글 삭제 실패: $e');
      rethrow;
    }
  }
}
