import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/domain/members/term/term.dart';
import 'package:oath_client/domain/members/term/term_state.dart';

import '../../../common/http_util.dart';

// Notifier (창고 관리자)
class TermNotifier extends Notifier<TermState> {
  late final Dio _dio = ref.read(dioProvider);

  @override
  TermState build() {
    // 초기 상태
    return const TermState();
  }

  // 약관 전체 목록 조회
  Future<void> getTerms() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _dio.get('/api/terms');
      if (response.statusCode == 200 && response.data['success']) {
        final List<dynamic> termList = response.data['data'];
        final terms = termList.map((json) => Term.fromJson(json)).toList();
        state = state.copyWith(isLoading: false, terms: terms);
      } else {
        throw Exception('Failed to load terms');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? "약관 목록을 불러오는데 실패했습니다.";
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // 특정 약관 상세 조회
  Future<Term?> getTermById(int termId) async {
    try {
      final response = await _dio.get('/api/terms/$termId');
      if (response.statusCode == 200 && response.data['success']) {
        return Term.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching term by id: $e');
      return null;
    }
  }
}

// Provider (창고)
final termProvider =
    NotifierProvider<TermNotifier, TermState>(TermNotifier.new);
