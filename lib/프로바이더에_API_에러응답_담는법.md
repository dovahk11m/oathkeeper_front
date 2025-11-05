# 프로바이더에서 API 에러 응답을 처리하는 법

## 1. 기본 원칙: Provider의 책임

우리 프로젝트의 모든 API 통신은 `Dio`를 사용하며, 서버의 모든 응답은 `ApiResponse`라는 표준 형식을 따릅니다. **각 Provider는 API 호출 시 발생할 수 있는 모든 종류의 에러를 `try-catch` 블록을 통해 직접 처리할 책임**을 가집니다.

> **결론**: Provider는 API 호출 코드를 `try-catch`로 감싸고, `DioException`과 일반 `Exception`을 구분하여 적절한 에러 메시지를 상태에 반영해야 합니다.

---

## 2. `Notifier`에서의 에러 처리 패턴

`Notifier` 내부의 메소드에서 API를 호출하고 **실패**했을 때 상태를 업데이트하는 표준 패턴입니다.

```dart
// 예시: 데이터를 가져오는 메소드
Future<void> fetchData() async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    final response = await _dio.get('/your-api-endpoint');
    final apiResponse = ApiResponse<YourDataModel>.fromJson(
      response.data,
      (json) => YourDataModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.success && apiResponse.data != null) {
      // 성공 시 처리 (자세한 내용은 '일반 응답 처리법' 문서 참고)
      state = state.copyWith(isLoading: false, data: apiResponse.data!);
    } else {
      // ==========================================================
      // 1. API 비즈니스 로직 실패 시 (e.g. 비밀번호 불일치)
      // ApiResponse에 담겨온 서버 메시지로 에러 상태를 업데이트
      // ==========================================================
      state = state.copyWith(isLoading: false, error: apiResponse.message);
    }

  } on DioException catch (e) {
    // ==========================================================
    // 2. 네트워크 또는 서버 에러 시 (e.g. 404, 500)
    // DioException의 응답에 포함된 서버 메시지를 사용
    // ==========================================================
    final errorMessage = e.response?.data?['message'] ?? "서버와 통신 중 오류가 발생했습니다.";
    state = state.copyWith(isLoading: false, error: errorMessage);

  } catch (e) {
    // ==========================================================
    // 3. 그 외 예측 불가능한 모든 에러 처리 (e.g. 파싱 오류)
    // ==========================================================
    state = state.copyWith(isLoading: false, error: "알 수 없는 오류가 발생했습니다.");
  }
}
```

### 에러 처리 핵심 요약:
1.  **API 로직 실패**: `apiResponse.success`가 `false`일 때, `apiResponse.message`를 에러 상태에 저장합니다.
2.  **통신/서버 실패**: `on DioException` 블록에서, `e.response?.data?['message']`를 통해 서버가 보낸 에러 메시지를 추출하여 에러 상태에 저장합니다.
3.  **기타 예외**: `catch (e)` 블록에서 포괄적인 에러 메시지를 사용하여 모든 예외 상황에 대비합니다.

---

## 3. `FutureProvider`에서의 에러 처리 패턴

`FutureProvider`나 값을 즉시 반환해야 하는 메소드에서는 **실패** 시 `Exception`을 발생시켜 UI에서 에러를 인지할 수 있도록 합니다.

```dart
// 예시: FutureProvider 또는 값을 직접 반환해야 하는 메소드
Future<YourDataModel> fetchData() async {
  try {
    final response = await _dio.get('/your-api-endpoint');
    final apiResponse = ApiResponse<YourDataModel>.fromJson(
      response.data,
      (json) => YourDataModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    } else {
      // ==========================================================
      // 실패 시, 메시지를 담아 Exception을 발생시킨다.
      // ==========================================================
      throw Exception(apiResponse.message);
    }
  } on DioException catch (e) {
    final message = e.response?.data?['message'] ?? "데이터를 불러오는 중 오류가 발생했습니다.";
    throw Exception(message);
  } catch (e) {
    // DioException이 아닌 다른 에러는 e.toString()으로 변환될 수 있으므로
    // 더 일반적인 메시지를 사용하거나, 에러 타입을 확인하고 분기합니다.
    throw Exception("알 수 없는 오류가 발생했습니다.");
  }
}
```

> **참고**: API 응답 처리의 전체 코드와 성공 응답 처리에 대한 자세한 내용은 `프로바이더에_API_일반응답_담는법.md` 문서를 확인하세요.
