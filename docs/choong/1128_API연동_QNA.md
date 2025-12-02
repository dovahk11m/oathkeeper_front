# 1128 API 연동 QnA

**작성일**: 2025-11-28
**작성자**: 클라이언트팀
**목적**: 기능 테스트 중 발견된 서버 API 이슈 확인 요청

---

## 🔴 긴급 이슈

### 1. Java 컴파일 `-parameters` 플래그 누락

**증상**:

```
java.lang.IllegalArgumentException: Name for argument of type [java.lang.Long] not specified,
and parameter name information not available via reflection.
Ensure that the compiler uses the '-parameters' flag.
```

**영향받는 API**:

- `GET /api/member/{memberId}` - 500 에러
- `GET /api/groups/{groupId}/chat/messages` - 500 에러
- 기타 PathVariable 사용하는 모든 API

**요청사항**:

1. Gradle 설정에 `-parameters` 플래그 추가 필요
   ```gradle
   tasks.withType(JavaCompile) {
       options.compilerArgs << '-parameters'
   }
   ```
2. 또는 모든 `@PathVariable`, `@RequestParam`에 명시적으로 이름 지정

   ```java
   // Before
   public ResponseEntity<?> getMember(Long memberId) { ... }

   // After
   public ResponseEntity<?> getMember(@PathVariable("memberId") Long memberId) { ... }
   ```

**우선순위**: 🔴 높음 (대부분의 API가 동작하지 않음)

---

## ⚠️ 중요 이슈

### 2. 채팅 메시지 조회 API 500 에러

**API**: `GET /api/groups/{groupId}/chat/messages`

**클라이언트 요청**:

```
GET http://10.0.2.2:8080/api/groups/1/chat/messages
Authorization: Bearer {token}
```

**서버 응답**:

```json
{
  "success": false,
  "data": null,
  "message": "시스템 오류가 발생했습니다. 관리자에게 문의해주세요."
}
```

**Status Code**: 500

**질문**:

1. 이 API의 정확한 에러 원인은 무엇인가요? (서버 로그 스택 트레이스 필요)
2. `-parameters` 플래그 문제와 관련이 있나요?
3. 정상 동작을 위해 필요한 조치는 무엇인가요?

**우선순위**: 🟡 중간 (채팅 기능 사용 불가)

---

### 3. 채팅 읽음 처리 API 404 에러

**API**: `POST /api/groups/{groupId}/chat/read`

**클라이언트 요청**:

```
POST http://10.0.2.2:8080/api/groups/1/chat/read
Authorization: Bearer {token}
```

**서버 응답**:

```json
{
  "timestamp": "2025-11-28T05:32:14.760+00:00",
  "status": 404,
  "error": "Not Found",
  "trace": "org.springframework.web.servlet.resource.NoResourceFoundException: No static resource api/groups/1/chat/read..."
}
```

**Status Code**: 404

**질문**:

1. 이 API가 구현되어 있나요?
2. 경로가 맞나요? 다른 경로를 사용해야 하나요?
3. 구현 예정이라면 언제쯤 가능한가요?

**우선순위**: 🟡 중간 (읽음 처리 기능 사용 불가)

---

## 📊 정상 동작 확인

### 4. 그룹 목록 조회 API ✅

**API**: `GET /api/groups`

**서버 응답**: 200 OK

```json
{
  "success": true,
  "data": {
    "content": [
      {
        "groupId": 1,
        "groupName": "샘플 그룹",
        "chatRoomId": 1,
        "lastMessage": "네! 기대하고 있겠습니다!",
        "lastMessageSentAt": "2025-11-20T14:30:02.383451",
        "unreadCount": 0
      }
    ],
    "page": 0,
    "size": 20,
    "totalPage": 1,
    "totalElements": 1,
    "last": true
  },
  "message": "그룹 목록 조회가 완료되었습니다."
}
```

**상태**: ✅ 정상 동작

---

## 🔍 추가 확인 필요

### 5. 실시간 지도 API 테스트 예정

다음 API들의 동작 여부를 테스트할 예정입니다:

**위치 업로드**:

- `POST /api/track/tracks/bulk`
- Request Body: `TrackBatchRequest`

**WebSocket**:

- 연결: `/ws-stomp` (SockJS) 또는 `/ws`
- 구독: `/topic/plans/{planId}/live`
- 구독: `/topic/plans/{planId}/events`

**테스트 API** (local 프로파일):

- `POST /api/test/force-movement`
- `POST /api/test/force-stationary`
- `POST /api/test/force-arrived`

**질문**:

1. 위 API들이 현재 정상 동작하나요?
2. 테스트 API는 local 프로파일에서 활성화되어 있나요?
3. WebSocket 연결 시 JWT 인증이 제대로 동작하나요?

---

## 📝 테스트 환경

- **클라이언트**: Flutter 3.35.6, Dart 3.9.2
- **서버 URL**: `http://10.0.2.2:8080` (Android 에뮬레이터)
- **인증**: JWT Bearer Token
- **테스트 계정**: user1@test.com

---

## 🙏 요청사항 요약

1. **긴급**: `-parameters` 플래그 추가 또는 어노테이션 명시적 이름 지정
2. **중요**: 채팅 메시지 조회 500 에러 원인 파악 및 수정
3. **중요**: 채팅 읽음 처리 API 구현 여부 확인
4. **확인**: 실시간 지도 관련 API 동작 여부 확인

**회신 요청**: 가능한 빠른 시일 내에 답변 부탁드립니다. 🙏
