import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/api_response.dart';
import 'package:oath_client/common/http_util.dart';
import 'package:oath_client/domain/members/term/term.dart';

// =======================================================================
// 1. 데이터 조회 전용 Provider (FutureProvider)
// =======================================================================

final termListProvider = FutureProvider<List<Term>>((ref) async {
  final dio = ref.read(dioProvider);
  try {
    final response = await dio.get('/terms');
    // 인터셉터가 없으므로, 여기서 직접 ApiResponse.fromJson을 호출합니다.
    final apiResponse = ApiResponse<List<Term>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Term.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message);
    }
  } on DioException catch (e) {
    final errorMessage = e.response?.data?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
    throw Exception(errorMessage);
  } catch (e) {
    throw Exception("알 수 없는 오류가 발생했습니다.");
  }
});

// =======================================================================
// 2. UI 상태 관리를 위한 데이터 클래스 및 Notifier
// =======================================================================

/// 약관 동의 화면의 UI 상태를 나타내는 데이터 클래스
class TermsAgreementData {
  final Map<int, bool> agreedMap; // 개별 약관 동의 상태
  final bool isAllAgreed; // '전체 동의' 체크박스 상태

  TermsAgreementData({required this.agreedMap, required this.isAllAgreed});

  // 초기 상태를 생성하는 팩토리 생성자
  factory TermsAgreementData.initial() =>
      TermsAgreementData(agreedMap: {}, isAllAgreed: false);

  TermsAgreementData copyWith({
    Map<int, bool>? agreedMap,
    bool? isAllAgreed,
  }) {
    return TermsAgreementData(
      agreedMap: agreedMap ?? this.agreedMap,
      isAllAgreed: isAllAgreed ?? this.isAllAgreed,
    );
  }
}

/// 약관 동의 UI의 상태를 관리하는 StateNotifier.
class TermsAgreementNotifier extends StateNotifier<TermsAgreementData> {
  final Ref _ref;
  List<Term> _currentTerms = [];

  TermsAgreementNotifier(this._ref) : super(TermsAgreementData.initial()) {
    // 데이터가 성공적으로 로드되면 동의 상태를 초기화
    _ref.listen<AsyncValue<List<Term>>>(termListProvider, (previous, next) {
      next.whenData((terms) {
        _currentTerms = terms;
        final newAgreedMap = {for (var term in terms) term.id: false};
        state = TermsAgreementData(agreedMap: newAgreedMap, isAllAgreed: false);
      });
    });
  }

  // 모든 약관이 동의되었는지 확인하여 isAllAgreed 상태를 업데이트
  void _recalculateAllAgreed() {
    if (_currentTerms.isEmpty) {
      state = state.copyWith(isAllAgreed: false);
      return;
    }
    final allAgreed =
        _currentTerms.every((term) => state.agreedMap[term.id] ?? false);
    state = state.copyWith(isAllAgreed: allAgreed);
  }

  // 단일 약관 동의 상태 토글
  void toggleTerm(int termId, bool? newValue) {
    if (newValue == null) return;
    state = state.copyWith(agreedMap: {...state.agreedMap, termId: newValue});
    _recalculateAllAgreed(); // 전체 동의 상태 다시 계산
  }

  // 전체 동의 상태 토글
  void toggleAll(bool? newValue) {
    if (newValue == null || _currentTerms.isEmpty) return;
    final newMap = {for (var term in _currentTerms) term.id: newValue};
    state = TermsAgreementData(agreedMap: newMap, isAllAgreed: newValue);
  }

  // [GETTER] 다음 화면으로 이동 가능한지 (필수 약관 동의 여부)
  bool get isNavigationEnabled {
    if (_currentTerms.isEmpty) return false;
    return _currentTerms
        .where((term) => term.isRequired)
        .every((term) => state.agreedMap[term.id] == true);
  }

  // [GETTER] 동의한 약관 ID 목록
  List<int> get agreedTermIds {
    return state.agreedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}

// =======================================================================
// 3. Provider 정의
// =======================================================================

final termsAgreementProvider =
    StateNotifierProvider<TermsAgreementNotifier, TermsAgreementData>((ref) {
  return TermsAgreementNotifier(ref);
});
