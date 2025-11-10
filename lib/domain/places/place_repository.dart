import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/places/place.dart';

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository(ref.read(dioProvider));
});

class PlaceRepository {
  final Dio _dio;

  PlaceRepository(this._dio);

  /// 장소 이름 자동완성
  Future<List<String>> autocompleteName(String prefix) async {
    try {
      print('[PlaceRepo] 장소 이름 자동완성: $prefix');
      final response = await _dio.get(
        '/places/autocomplete/name',
        queryParameters: {'prefix': prefix},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      print('[PlaceRepo] 장소 이름 자동완성 실패: $e');
      return [];
    }
  }

  /// 태그 이름 자동완성
  Future<List<String>> autocompleteTag(String prefix) async {
    try {
      print('[PlaceRepo] 태그 자동완성: $prefix');
      final response = await _dio.get(
        '/places/autocomplete/tag',
        queryParameters: {'prefix': prefix},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      print('[PlaceRepo] 태그 자동완성 실패: $e');
      return [];
    }
  }

  /// 태그 기반 장소 추천
  Future<List<Place>> recommendByTags({
    int planId = 0,
    required List<String> tags,
  }) async {
    try {
      print('[PlaceRepo] 태그 기반 추천 시작: $tags');
      final response = await _dio.get(
        '/places/recommend',
        queryParameters: {
          'planId': planId,
          'tagNames': tags.join(','),
        },
      );

      print('[PlaceRepo] 응답 상태: ${response.statusCode}');
      print('[PlaceRepo] 응답 데이터: ${response.data}');

      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        print('[PlaceRepo] 파싱할 장소 수: ${data.length}');
        final places = data.map((json) => Place.fromJson(json)).toList();
        print('[PlaceRepo] 파싱 완료: ${places.length}개 장소');
        return places;
      }
      print('[PlaceRepo] success=false');
      return [];
    } catch (e, stack) {
      print('[PlaceRepo] 태그 기반 추천 실패: $e');
      print('[PlaceRepo] 스택: $stack');
      return [];
    }
  }

  /// 장소 이름으로 ID 검색
  Future<int?> searchByName(String placeName) async {
    try {
      print('[PlaceRepo] 장소 이름으로 검색: $placeName');
      final response = await _dio.get(
        '/places/search-by-name',
        queryParameters: {'placeName': placeName},
      );

      if (response.data['success'] == true) {
        return response.data['data'] as int?;
      }
      return null;
    } catch (e) {
      print('[PlaceRepo] 장소 이름 검색 실패: $e');
      return null;
    }
  }
}

