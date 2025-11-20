# 후기(Review) 및 댓글(Reply) API 명세

## 공통
- Base URL: `/api`
- 인증: Bearer JWT (헤더 `Authorization: Bearer <token>`)
- Content-Type: `application/json`
- 시간 포맷: ISO 8601 LocalDateTime 문자열 (예: `2025-11-13T12:34:56`)
- 페이지네이션: query `page`(0 기반, 기본 0), `size`(기본 20)
- 에러 코드: 400(검증 실패), 401(인증 실패), 403(권한 없음), 404(리소스 없음), 500(서버 오류)

## 약속(Plan) 완료 관련
**후기는 약속이 완료된 후에만 작성 가능합니다.**

### 약속 완료 조건
1. **수동 완료**: 약속 생성자가 `POST /api/plans/{planId}/complete` 호출
2. **자동 완료**: 모든 참가자(ACCEPTED 상태)가 도착 완료 시 자동으로 상태가 COMPLETED로 변경

### 완료된 약속 확인
- Plan의 `status` 필드가 `COMPLETED`
- Plan의 `completedAt` 필드에 완료 시간 기록

### 약속 완료 API
**POST** `/api/plans/{planId}/complete`

- **설명**: 약속을 수동으로 완료 처리합니다. (인증 필요, 생성자만 가능)
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "강남역 모임",
    "status": "COMPLETED",
    "completedAt": "2025-11-13T15:00:00",
    ...
  },
  "message": "약속이 완료되었습니다."
}
```
- **에러**:
  - 400: "이미 완료된 약속입니다."
  - 403: "플랜 생성자만 수정/삭제할 수 있습니다."

---

## 후기(Review) API

### 1. 후기 작성
**POST** `/api/reviews`

- **설명**: 약속에 대한 후기를 작성합니다. (인증 필요, **약속 완료 후에만 가능**)
- **요청 Body**:
```json
{
  "planId": 1,
  "title": "즐거운 만남이었어요!",
  "content": "오랜만에 만나서 즐거웠습니다."
}
```
- **필드 검증**:
  - `planId`: Long, required
  - `title`: String, required, max 100자
  - `content`: String, required, max 500자
- **권한/검증**:
  - 약속이 완료된 상태(COMPLETED)인지 확인
  - 해당 약속에 이미 후기를 작성했는지 확인 (중복 방지)
- **응답 (201 Created)**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "즐거운 만남이었어요!",
    "content": "오랜만에 만나서 즐거웠습니다.",
    "planId": 1,
    "planTitle": "강남역 모임",
    "authorName": "홍길동",
    "authorId": 5,
    "createdAt": "2025-11-13T12:34:56",
    "updatedAt": null,
    "replies": []
  },
  "message": "후기가 작성되었습니다."
}
```
- **에러**:
  - 400: "약속이 종료된 후에만 후기를 작성할 수 있습니다."
  - 400: "이미 해당 약속에 대한 후기를 작성하셨습니다."

---

### 2. 후기 상세 조회
**GET** `/api/reviews/{reviewId}`

- **설명**: 후기 상세 내용 및 댓글을 조회합니다.
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "즐거운 만남이었어요!",
    "content": "오랜만에 만나서 즐거웠습니다.",
    "planId": 1,
    "planTitle": "강남역 모임",
    "authorName": "홍길동",
    "authorId": 5,
    "createdAt": "2025-11-13T12:34:56",
    "updatedAt": null,
    "replies": [
      {
        "id": 1,
        "content": "저도 즐거웠어요!",
        "authorName": "김철수",
        "authorId": 3,
        "createdAt": "2025-11-13T13:00:00",
        "updatedAt": null
      }
    ]
  }
}
```

---

### 3. 약속별 후기 목록 조회
**GET** `/api/reviews/plan/{planId}`

- **설명**: 특정 약속에 대한 모든 후기를 조회합니다.
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "즐거운 만남이었어요!",
      "content": "오랜만에 만나서 즐거웠습니다.",
      "planId": 1,
      "planTitle": "강남역 모임",
      "authorName": "홍길동",
      "authorId": 5,
      "createdAt": "2025-11-13T12:34:56",
      "updatedAt": null,
      "replies": []
    }
  ]
}
```

---

### 4. 내가 작성한 후기 목록 조회
**GET** `/api/reviews/my?page=0&size=20`

- **설명**: 로그인한 사용자가 작성한 모든 후기를 페이지네이션으로 조회합니다. (인증 필요)
- **Query Parameters**:
  - `page`: int (기본 0)
  - `size`: int (기본 20)
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": {
    "content": [...],
    "pageable": {...},
    "totalElements": 50,
    "totalPages": 3,
    "number": 0,
    "size": 20
  }
}
```

---

### 5. 후기 수정
**PUT** `/api/reviews/{reviewId}`

- **설명**: 작성한 후기를 수정합니다. (인증 필요, 작성자만 가능)
- **요청 Body**:
```json
{
  "title": "수정된 제목",
  "content": "수정된 내용입니다."
}
```
- **필드 검증**:
  - `title`: String, optional, max 100자
  - `content`: String, optional, max 500자
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": { ... },
  "message": "후기가 수정되었습니다."
}
```
- **에러**:
  - 403: "작성자만 수정/삭제할 수 있습니다."

---

### 6. 후기 삭제
**DELETE** `/api/reviews/{reviewId}`

- **설명**: 작성한 후기를 삭제합니다. (인증 필요, 작성자만 가능)
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": null,
  "message": "후기가 삭제되었습니다."
}
```

---

## 댓글(Reply) API

### 1. 댓글 작성
**POST** `/api/replies/review/{reviewId}`

- **설명**: 후기에 댓글을 작성합니다. (인증 필요)
- **요청 Body**:
```json
{
  "content": "저도 즐거웠어요!"
}
```
- **필드 검증**:
  - `content`: String, required, max 500자
- **응답 (201 Created)**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "content": "저도 즐거웠어요!",
    "authorName": "김철수",
    "authorId": 3,
    "createdAt": "2025-11-13T13:00:00",
    "updatedAt": null
  },
  "message": "댓글이 작성되었습니다."
}
```

---

### 2. 댓글 수정
**PUT** `/api/replies/{replyId}`

- **설명**: 작성한 댓글을 수정합니다. (인증 필요, 작성자만 가능)
- **요청 Body**:
```json
{
  "content": "수정된 댓글 내용입니다."
}
```
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": { ... },
  "message": "댓글이 수정되었습니다."
}
```

---

### 3. 댓글 삭제
**DELETE** `/api/replies/{replyId}`

- **설명**: 작성한 댓글을 삭제합니다. (인증 필요, 작성자만 가능)
- **응답 (200 OK)**:
```json
{
  "success": true,
  "data": null,
  "message": "댓글이 삭제되었습니다."
}
```

---

## 공통 응답 구조

### 성공 응답
```json
{
  "success": true,
  "data": { ... },
  "message": "성공 메시지"
}
```

### 에러 응답
```json
{
  "success": false,
  "timestamp": "2025-11-13T12:34:56",
  "status": 400,
  "error": "Bad Request",
  "message": "약속이 종료된 후에만 후기를 작성할 수 있습니다."
}
```

---

## Flutter 개발자 체크리스트
- [x] 모든 필드명은 camelCase
- [x] 페이지네이션은 0 기반
- [x] 후기 작성 전 약속 완료 여부 확인 필요
- [x] JWT 토큰을 헤더에 `Authorization: Bearer <token>` 형식으로 포함
- [x] LocalDateTime 문자열 파싱 필요 (ISO 8601)

