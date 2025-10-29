# API 요청 시 인증 토큰 자동 포함 가이드

이 문서는 다른 페이지에서 API를 호출할 때, 사용자의 로그인 토큰을 어떻게 자동으로 요청에 포함시키는지를 설명합니다.

---

## TL;DR (요약)

**모든 API 요청은 반드시 `dioProvider`를 통해 생성된 `Dio` 객체로 하세요.**

어떤 페이지에서든 `ref.read(dioProvider)`를 사용해 `Dio`를 가져와 요청하면, 토큰은 보이지 않는 곳에서 자동으로 추가됩니다.

### 예시 코드

```dart
// 게시판, 마이페이지 등 어떤 페이지에서든...
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oath_client/common/http_util.dart'; // dioProvider를 위해 import

class MyPage extends ConsumerWidget {
  
  // 버튼 클릭 시 내 정보를 가져오는 예시 메소드
  void fetchMyData(WidgetRef ref) async {
    // 1. dioProvider로부터 Dio 인스턴스를 얻어옵니다.
    final dio = ref.read(dioProvider);

    try {
      // 2. 평소처럼 API를 호출합니다. (토큰 관련 코드는 전혀 필요 없습니다.)
      //    TokenInterceptor가 이 요청을 가로채서 헤더에 토큰을 자동으로 추가해줍니다.
      final response = await dio.get('/member/me'); // 가정: 내 정보를 가져오는 API
      
      print("내 정보 가져오기 성공: ${response.data}");

    } catch (e) {
      // DioException (4xx, 5xx 에러 포함) 또는 기타 에러 처리
      print("API 호출 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => fetchMyData(ref), 
      child: const Text('내 정보 가져오기'),
    );
  }
}
```

---

## 동작 원리 (궁금한 사람들을 위해)

이 편리한 기능은 **`Interceptor`** 라는 `Dio`의 "감시자" 패턴 덕분에 가능합니다.

1.  **`lib/common/http_util.dart`**
    - 우리 앱에서 사용하는 유일한 `Dio` 객체를 생성하는 `dioProvider`가 정의되어 있습니다.
    - 이 Provider는 `Dio`를 생성할 때, `TokenInterceptor`라는 감시자를 붙여줍니다. (`dio.interceptors.add(...)`)

2.  **`lib/common/token_interceptor.dart`**
    - 이 감시자(`TokenInterceptor`)는 `dioProvider`를 통해 나가는 **모든 API 요청**을 자동으로 가로챕니다.
    - 요청을 가로챈 뒤, `authProvider`에게 현재 저장된 토큰이 있는지 물어봅니다.
    - 토큰이 존재하면, 요청 헤더에 `Authorization: Bearer <토큰>` 형식으로 자동으로 추가한 후, 원래 목적지로 요청을 다시 보냅니다.

결론적으로, 다른 개발자들은 **`dioProvider`를 사용한다는 규칙만 지키면**, 인증 로직의 상세한 내용을 전혀 몰라도 안전하게 인증이 필요한 API를 호출할 수 있습니다.
