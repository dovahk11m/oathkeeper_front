# 프로바이더에서 API 성공 응답을 처리하는 법

## 1. 기본 원칙: Provider의 책임

우리 프로젝트의 모든 API 통신은 `Dio`를 사용하며, 서버의 모든 응답은 `ApiResponse`라는 표준 형식을 따릅니다. **각 Provider는 서버로부터 받은 순수 JSON 응답을 `ApiResponse<T>` 객체로 직접 파싱할 책임**을 가집니다.

- **타입-안전 파싱**: `ApiResponse.fromJson`의 두 번째 인자로 파싱 함수를 직접 전달하여, `data` 필드를 원하는 타입(e.g., `List<Term>`)으로 안전하게 변환합니다.

> **결론**: Provider는 API를 호출한 후, `ApiResponse.fromJson<T>()`을 사용하여 응답을 명시적으로 파싱해야 합니다. 이는 타입 안정성을 보장하는 핵심적인 과정입니다.

---

## 2. `Notifier`에서의 성공 처리 패턴

`Notifier` 내부의 메소드에서 API를 호출하고 **성공**했을 때 상태를 업데이트하는 표준 패턴입니다.

```dart
// 예시: 데이터를 가져오는 메소드
Future<void> fetchData() async {
  // ... (로딩 상태 시작)

  try {
    final response = await _dio.get('/your-api-endpoint');

    // ====================================================
    // 1. 타입을 명시하여 ApiResponse.fromJson 직접 호출
    // ====================================================
    final apiResponse = ApiResponse<YourDataModel>.fromJson(
      response.data, // Dio의 순수 JSON 응답
      (json) => YourDataModel.fromJson(json as Map<String, dynamic>),
    );

    if (apiResponse.success && apiResponse.data != null) {
      // ====================================================
      // 2. 타입-안전하게 변환된 데이터를 상태에 업데이트
      // ====================================================
      state = state.copyWith(isLoading: false, data: apiResponse.data!);
    } else {
      // 실패 시 에러 처리 (자세한 내용은 '에러 응답 처리법' 문서 참고)
      state = state.copyWith(isLoading: false, error: apiResponse.message);
    }
  } catch (e) {
    // 예외 처리 (자세한 내용은 '에러 응답 처리법' 문서 참고)
    // ...
  }
}
```

### 핵심 요약:
1.  `dio`로 API를 호출하고, 응답(`response.data`)을 `ApiResponse.fromJson`으로 직접 파싱합니다.
2.  이때, `ApiResponse<YourDataModel>`처럼 **명확한 타입을 지정**하고, `data` 필드를 파싱하는 함수를 전달합니다.
3.  `apiResponse.success`가 `true`이고 `apiResponse.data`가 `null`이 아님을 확인한 후, 타입-안전한 `data`를 상태에 업데이트합니다.

---

## 3. `FutureProvider`에서의 성공 처리 패턴

`FutureProvider`나 값을 즉시 반환해야 하는 메소드에서도 동일한 방식으로 **성공** 시 데이터를 파싱하여 반환합니다.

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
      // ====================================================
      // 성공 시: 타입-안전한 데이터를 즉시 반환
      // ====================================================
      return apiResponse.data!;
    } else {
      // 실패 시 예외 발생 (자세한 내용은 '에러 응답 처리법' 문서 참고)
      throw Exception(apiResponse.message);
    }
  } catch (e) {
    // 예외 처리 (자세한 내용은 '에러 응답 처리법' 문서 참고)
    throw Exception("데이터를 불러오는 중 오류가 발생했습니다.");
  }
}
```
> **참고**: API 응답 처리의 전체 코드와 에러 핸들링에 대한 자세한 내용은 `프로바이더에_API_에러응답_담는법.md` 문서를 확인하세요.
