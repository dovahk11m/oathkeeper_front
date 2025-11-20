import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/utils/http_util.dart';
import 'package:oath_client/domain/reviews/review.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.read(dioProvider));
});

class ReviewRepository {
  final Dio _dio;

  ReviewRepository(this._dio);

  List<dynamic> _extractReplyList(dynamic replies) {
    if (replies is List) return replies;
    if (replies is Map) {
      if (replies['content'] is List) return replies['content'] as List;
      if (replies['data'] is List) return replies['data'] as List;
      if (replies['items'] is List) return replies['items'] as List;
    }
    return const [];
  }

  Map<String, dynamic> _normalizeReviewResponse(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    // 필수 기본값
    normalized['id'] ??= 0;
    normalized['planId'] ??= json['plan_id'] ?? 0;
    normalized['planTitle'] ??= json['planTitle'] ?? json['plan_title'] ?? '';
    normalized['placeName'] ??= json['placeName'] ?? json['place_name'];
    normalized['latitude'] ??= json['latitude'] ?? json['lat'];
    normalized['longitude'] ??= json['longitude'] ?? json['lng'] ?? json['lon'];
    normalized['authorId'] ??= json['authorId'] ?? json['author_id'] ?? 0;
    normalized['authorName'] ??=
        json['authorName'] ?? json['author_name'] ?? '알 수 없는 작성자';
    normalized['title'] ??= json['title'] ?? ''; // 서버가 null 주는 경우 방지
    normalized['content'] ??= json['content'] ?? '';
    normalized['createdAt'] ??= json['createdAt'] ??
        json['created_at'] ??
        DateTime.now().toIso8601String();
    normalized['updatedAt'] ??=
        json['updatedAt'] ?? json['updated_at'] ?? normalized['createdAt'];
    // replies 배열 정규화 (리스트 혹은 페이지 객체 모두 지원)
    final replyItems = _extractReplyList(json['replies']);
    normalized['replies'] = replyItems
        .map((reply) => _normalizeReplyResponse(
              (reply as Map).cast<String, dynamic>(),
              reviewId: normalized['id'] as int?,
            ))
        .toList();

    normalized['replyCount'] ??= json['replyCount'] ??
        json['reply_count'] ??
        json['replyCnt'] ??
        json['reply_cnt'] ??
        (json['replies'] is Map
            ? (json['replies']['totalElements'] ??
                json['replies']['total'] ??
                replyItems.length)
            : replyItems.length);

    return normalized;
  }

  Map<String, dynamic> _normalizeReplyResponse(
    Map<String, dynamic> json, {
    int? reviewId,
  }) {
    final normalized = Map<String, dynamic>.from(json);

    normalized['id'] ??= json['replyId'] ?? 0;
    normalized['reviewId'] ??=
        json['reviewId'] ?? json['review_id'] ?? reviewId ?? 0;
    normalized['authorId'] ??=
        json['authorId'] ?? json['author_id'] ?? json['writerId'] ?? 0;
    normalized['authorName'] ??=
        json['authorName'] ?? json['author_name'] ?? json['writerName'];
    normalized['content'] ??= json['content'] ?? '';
    normalized['createdAt'] ??= json['createdAt'] ??
        json['created_at'] ??
        DateTime.now().toIso8601String();
    normalized['updatedAt'] ??=
        json['updatedAt'] ?? json['updated_at'] ?? normalized['createdAt'];

    return normalized;
  }

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
            .map((json) => Review.fromJson(
                _normalizeReviewResponse(json as Map<String, dynamic>)))
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
            .map((json) => Review.fromJson(
                _normalizeReviewResponse(json as Map<String, dynamic>)))
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
      final response = await _dio.get('/reviews/$reviewId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 조회 실패');
      }

      final normalized = _normalizeReviewResponse(
          response.data['data'] as Map<String, dynamic>);
      return Review.fromJson(normalized);
    } catch (e) {
      print('[ReviewRepo] 후기 상세 조회 실패: $e');
      rethrow;
    }
  }

  /// 후기 생성
  Future<int> createReview(CreateReviewRequest request) async {
    try {
      final response = await _dio.post(
        '/reviews',
        data: request.toJson(),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '후기 작성 실패');
      }

      return response.data['data']['id'] as int;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      print('[ReviewRepo] 후기 생성 Dio 오류 status=$status body=$data');
      if (status == 400) {
        final msg = _extractErrorMessage(data) ?? '요청이 유효하지 않습니다(400)';
        throw Exception(msg);
      }
      rethrow;
    } catch (e) {
      print('[ReviewRepo] 후기 생성 실패: $e');
      rethrow;
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data['message'] is String) return data['message'];
      if (data['error'] is Map && data['error']['message'] is String) {
        return data['error']['message'];
      }
    }
    return null;
  }

  /// 후기 수정
  Future<void> updateReview(
      int reviewId, String content, double? rating) async {
    try {
      final response = await _dio.put(
        '/reviews/$reviewId',
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
      final response = await _dio.delete('/reviews/$reviewId');

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

      final replyJson = _normalizeReplyResponse(
        response.data['data'] as Map<String, dynamic>,
        reviewId: reviewId,
      );
      return Reply.fromJson(replyJson);
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

      final replyJson = _normalizeReplyResponse(
        response.data['data'] as Map<String, dynamic>,
      );
      return Reply.fromJson(replyJson);
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
