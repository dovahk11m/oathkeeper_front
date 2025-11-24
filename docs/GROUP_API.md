# Group API 명세서

- **최종 수정 일자:** 2025-11-24

`GroupController`에 구현된 그룹 및 채팅 관련 API의 최신 명세입니다.

---

## 1. 공통 정보

### 1.1. 인증 (Authentication)

- 본 명세서의 모든 API는 **인증이 필요**합니다.
- 요청 시 HTTP 헤더에 `Authorization: Bearer {JWT}` 형식으로 유효한 토큰을 포함해야 합니다.
- 서버는 `@RequestAttribute("userEmail")`을 통해 요청자를 식별합니다.

### 1.2. 표준 응답 형식 (Standard Response Format)

- 모든 API는 아래와 같은 `CommonResponse<T>` 형식으로 데이터를 반환합니다.

```json
{
  "success": true,
  "data": { ... }, // API별로 상이한 데이터 객체
  "message": "요청 처리 결과 메시지"
}
```

---

## 2. 그룹 관리 (Group Management)

### 2.1. 새로운 그룹 생성

- **Method**: `POST`
- **URL**: `/api/groups`
- **설명**: 새로운 그룹을 생성합니다. 요청자는 자동으로 그룹의 멤버가 됩니다.
- **Request Body**:
  ```json
  {
    "groupName": "우리들의 즐거운 스터디"
  }
  ```
- **Success Response (201 Created)**:
  - `data` 필드에는 생성된 그룹의 `ID` (Long)가 포함됩니다.
  ```json
  {
    "success": true,
    "data": 1,
    "message": "그룹이 생성되었습니다."
  }
  ```

### 2.2. 내 그룹 목록 조회

- **Method**: `GET`
- **URL**: `/api/groups`
- **설명**: 현재 로그인한 사용자가 참여하고 있는 모든 그룹의 목록을 페이징하여 조회합니다.
- **Query Parameters (Paging)**:
  - `page` (int, optional, default: 0): 조회할 페이지 번호
  - `size` (int, optional, default: 20): 한 페이지에 보여줄 그룹 수
- **Success Response (200 OK)**:
  - `data` 필드에는 `PageResponseDTO<GroupListResponse>` 객체가 포함됩니다.
  ```json
  {
    "success": true,
    "data": {
      "items": [
        {
          "groupId": 1,
          "groupName": "우리들의 즐거운 스터디",
          "chatRoomId": 1,
          "lastMessage": "네! 기대하고 있겠습니다!",
          "lastMessageSentAt": "2025-11-18T12:30:00",
          "unreadCount": 0
        }
      ],
      "currentPage": 0,
      "totalPages": 1,
      "totalElements": 1,
      "isFirst": true,
      "isLast": true
    },
    "message": "그룹 목록 조회가 완료되었습니다."
  }
  ```

### 2.3. 그룹에서 탈퇴

- **Method**: `DELETE`
- **URL**: `/api/groups/{groupId}/leave`
- **설명**: 특정 그룹에서 탈퇴합니다. 마지막 멤버가 탈퇴하면 그룹과 모든 관련 데이터가 영구적으로 삭제됩니다.
- **Path Variable**:
  - `groupId` (Long): 탈퇴할 그룹의 ID
- **Success Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": null,
    "message": "그룹에서 탈퇴했습니다."
  }
  ```

### 2.4. 그룹 내 약속 목록 조회 (신규)

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/plans`
- **설명**: 특정 그룹에 속한 약속 목록을 페이징하여 조회합니다. 채팅방에서 '요약 보기' 버튼 클릭 시, 이 API를 호출하여 완료된 약속 목록을 사용자에게 보여주는 데 사용됩니다.
- **Path Variable**:
  - `groupId` (Long): 약속 목록을 조회할 그룹의 ID
- **Query Parameters**:
  - `status` (String, optional): 조회할 약속의 상태. (예: `COMPLETED`). 지정하지 않으면 모든 상태의 약속을 조회합니다.
    - 사용 가능한 값: `PLANNING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`
  - `page` (int, optional, default: 0): 조회할 페이지 번호
  - `size` (int, optional, default: 20): 한 페이지에 보여줄 약속 수
  - `sort` (String, optional, default: `planDatetime,DESC`): 정렬 기준
- **Success Response (200 OK)**:
  - `data` 필드에는 `PageResponseDTO<SimplePlan>` 객체가 포함됩니다.
  ```json
  {
    "success": true,
    "data": {
      "items": [
        {
          "planId": 2,
          "title": "긴급 트러블슈팅 회의",
          "planDatetime": "2025-11-24T18:00:00"
        },
        {
          "planId": 1,
          "title": "주말 코딩 스터디",
          "planDatetime": "2025-11-21T15:00:00"
        }
      ],
      "currentPage": 0,
      "totalPages": 1,
      "totalElements": 2,
      "isFirst": true,
      "isLast": true
    },
    "message": "그룹 내 약속 목록 조회가 완료되었습니다."
  }
  ```

---

## 3. 그룹 멤버 관리 (Group Member Management)

### 3.1. 그룹에 멤버 추가 (초대)

- **Method**: `POST`
- **URL**: `/api/groups/{groupId}/members`
- **설명**: 특정 그룹에 한 명 이상의 새로운 멤버를 이메일로 초대합니다.
- **Path Variable**:
  - `groupId` (Long): 멤버를 추가할 그룹의 ID
- **Request Body**:
  ```json
  {
    "memberEmails": ["new.member1@example.com", "new.member2@example.com"]
  }
  ```
- **Success Response (200 OK)**:
  ```json
  {
    "success": true,
    "data": null,
    "message": "멤버가 그룹에 추가되었습니다."
  }
  ```

### 3.2. 그룹 멤버 목록 조회

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/members`
- **설명**: 특정 그룹에 참여하고 있는 모든 멤버의 목록을 페이징하여 조회합니다.
- **Path Variable**:
  - `groupId` (Long): 멤버 목록을 조회할 그룹의 ID
- **Query Parameters (Paging)**:
  - `page` (int, optional, default: 0): 조회할 페이지 번호
  - `size` (int, optional, default: 20): 한 페이지에 보여줄 멤버 수
- **Success Response (200 OK)**:
  - `data` 필드에는 `PageResponseDTO<GroupMemberResponse>` 객체가 포함됩니다.
  ```json
  {
    "success": true,
    "data": {
      "items": [
        {
          "memberId": 1,
          "username": "김철수",
          "profileImageUrl": "/path/to/image.jpg"
        }
      ],
      "currentPage": 0,
      "totalPages": 1,
      "totalElements": 1,
      "isFirst": true,
      "isLast": true
    },
    "message": "그룹 멤버 목록 조회가 완료되었습니다."
  }
  ```

---

## 4. 채팅 (Chat)

### 4.1. 이전 대화 내용 조회

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/chat/messages`
- **설명**: 특정 그룹(채팅방)의 이전 대화 내용을 페이징하여 조회합니다.
- **Path Variable**:
  - `groupId` (Long): 대화 내용을 조회할 그룹의 ID
- **Query Parameters (Paging)**:
  - `page` (int, optional, default: 0): 조회할 페이지 번호
  - `size` (int, optional, default: 30): 한 페이지에 보여줄 메시지 수
  - `sort` (String, optional, default: `sentAt,DESC`): 정렬 기준
- **Success Response (200 OK)**:
  - `data` 필드에는 `PageResponseDTO<ChatResponse>` 객체가 포함됩니다.
  ```json
  {
    "success": true,
    "data": {
      "items": [
        {
          "chatId": 1,
          "senderId": 1,
          "senderName": "김철수",
          "content": "안녕하세요!",
          "sentAt": "2025-11-18T12:30:00"
        }
      ],
      "currentPage": 0
      // ... (페이징 정보)
    },
    "message": "이전 대화 내용 조회가 완료되었습니다."
  }
  ```

---

## 5. 추가 제안 (클라이언트 구현 가이드 및 서버 개선 계획)

### 5.1. 클라이언트: '과거 약속 요약 보기' 기능 구현 시나리오

하나의 그룹(채팅방)에 여러 약속이 누적될 수 있으므로, 아래 시나리오에 따라 '요약 보기' 기능을 구현하는 것을 권장합니다.

1.  **'요약 보기' 버튼 클릭**: 사용자가 채팅방에서 '요약 보기' 버튼을 누릅니다.
2.  **완료된 약속 목록 요청**: 클라이언트는 새로 추가된 `GET /api/groups/{groupId}/plans?status=COMPLETED` API를 호출하여, 해당 그룹의 **완료된 약속 목록**을 받아옵니다.
3.  **사용자에게 목록 제공**: 클라이언트는 응답받은 약속 목록(`planId`, `title`, `planDatetime`)을 사용자에게 **모달(Modal) 창이나 리스트 형태**로 보여줍니다.
4.  **특정 약속 선택**: 사용자가 목록에서 특정 약속(예: "주말 코딩 스터디")을 선택합니다.
5.  **최종 요약 요청**: 클라이언트는 사용자가 선택한 약속의 `planId`를 사용하여, 기존의 `GET /api/plans/{planId}/summary` API를 **폴링(Polling) 방식**으로 호출하여 최종 요약 내용을 받아와 화면에 표시합니다. (상세 내용은 `METRIC_API.md` 참조)

### 5.2. 서버: 향후 개선 계획

#### 5.2.1. 그룹 누적 데이터 API (Python팀과 협업 필요)

- **목표**: 특정 그룹의 모든 약속 데이터를 종합하여 그룹 전체의 누적 통계를 제공하는 API를 구현합니다.
- **예상 API**: `GET /api/groups/{groupId}/metrics/summary`
- **현재 상태**: Python AI 서버에 신규 API 개발을 요청했으며, 개발이 완료되면 Spring 서버에서도 관련 로직을 구현할 예정입니다.

#### 5.2.2. 채팅방 목록 API 응답 개선 (서버 단독 진행 가능)

- **목표**: `GET /api/groups` API의 응답에 각 그룹(채팅방)과 관련된 최신 약속 정보를 추가하여 사용자 경험을 향상시킵니다.
- **개선 방안**: `GroupListResponse` DTO에 `latestPlanTitle`, `latestPlanDatetime`과 같은 필드를 추가하는 것을 고려 중입니다.
- **기대 효과**: 클라이언트가 채팅방 목록을 표시할 때, "샘플 그룹"이라는 이름 옆에 "최근 약속: 긴급 트러블슈팅 회의"와 같은 부가 정보를 함께 보여줄 수 있습니다.

---

## 6. 클라이언트 측 API 구현 요청

> [!IMPORTANT] > **서버 개발팀에 구현 요청 필요**
>
> 아래 API는 클라이언트 기능 구현을 위해 **반드시 필요**합니다.
> 현재 클라이언트 코드는 이미 작성되어 있으며, 서버 API 구현이 완료되면 즉시 동작 가능합니다.

### 6.1. 그룹 내 약속 목록 조회 API (필수)

**API 명세:** 섹션 2.4 참조 - `GET /api/groups/{groupId}/plans`

**구현 요청 사항:**

- **엔드포인트**: `GET /api/groups/{groupId}/plans`
- **Path Variable**:
  - `groupId` (Long): 약속 목록을 조회할 그룹의 ID
- **Query Parameters**:
  - `status` (String, optional): 조회할 약속의 상태
    - 사용 가능한 값: `PLANNING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`
    - 지정하지 않으면 모든 상태의 약속 조회
  - `page` (int, optional, default: 0): 페이지 번호
  - `size` (int, optional, default: 20): 페이지 크기
  - `sort` (String, optional, default: `planDatetime,DESC`): 정렬 기준

**응답 형식:**

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "planId": 2,
        "title": "긴급 트러블슈팅 회의",
        "planDatetime": "2025-11-24T18:00:00"
      },
      {
        "planId": 1,
        "title": "주말 코딩 스터디",
        "planDatetime": "2025-11-21T15:00:00"
      }
    ],
    "currentPage": 0,
    "totalPages": 1,
    "totalElements": 2,
    "isFirst": true,
    "isLast": true
  },
  "message": "그룹 내 약속 목록 조회가 완료되었습니다."
}
```

**DTO 정의 (참고):**

```java
// SimplePlan DTO
public class SimplePlan {
    private Long planId;
    private String title;
    private LocalDateTime planDatetime;
    // getters, setters, constructors
}

// PageResponseDTO는 기존 공통 DTO 사용
```

**비즈니스 로직:**

1.  `groupId`로 해당 그룹에 속한 모든 약속 조회
2.  `status` 파라미터가 있으면 해당 상태의 약속만 필터링
3.  `planDatetime` 기준 내림차순 정렬 (최신 약속이 먼저)
4.  페이징 처리하여 반환

**사용 시나리오:**

- 채팅방에서 '요약 보기' 버튼 클릭 시
- 클라이언트는 `status=COMPLETED`로 요청하여 완료된 약속 목록 표시
- 사용자가 약속 선택 시 해당 약속의 AI 요약 조회

**우선순위**: 🔴 **높음** (클라이언트 기능 동작에 필수)

**예상 작업량**: 중간 (기존 Plan 엔티티 활용, 페이징 로직 재사용 가능)

**관련 클라이언트 파일:**

- `lib/domain/groups/group_repository.dart` - API 호출 코드 구현 완료
- `lib/domain/plans/simple_plan.dart` - DTO 정의 완료
- `lib/view/metrics/metrics_summary_sheet.dart` - UI 구현 완료
