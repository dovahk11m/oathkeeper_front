# Group API 명세서

-   **최종 수정 일자:** 2025-11-18

`GroupController`에 구현된 그룹 및 채팅 관련 API의 최신 명세입니다.

---

## 1. 공통 정보

### 1.1. 인증 (Authentication)

-   본 명세서의 모든 API는 **인증이 필요**합니다.
-   요청 시 HTTP 헤더에 `Authorization: Bearer {JWT}` 형식으로 유효한 토큰을 포함해야 합니다.
-   서버는 `@RequestAttribute("userEmail")`을 통해 요청자를 식별합니다.

### 1.2. 표준 응답 형식 (Standard Response Format)

-   모든 API는 아래와 같은 `CommonResponse<T>` 형식으로 데이터를 반환합니다.

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

-   **Method**: `POST`
-   **URL**: `/api/groups`
-   **설명**: 새로운 그룹을 생성합니다. 요청자는 자동으로 그룹의 멤버가 됩니다.
-   **Request Body**:
    ```json
    {
      "groupName": "우리들의 즐거운 스터디"
    }
    ```
-   **Success Response (201 Created)**:
    -   `data` 필드에는 생성된 그룹의 `ID` (Long)가 포함됩니다.
    ```json
    {
      "success": true,
      "data": 1,
      "message": "그룹이 생성되었습니다."
    }
    ```

### 2.2. 내 그룹 목록 조회

-   **Method**: `GET`
-   **URL**: `/api/groups`
-   **설명**: 현재 로그인한 사용자가 참여하고 있는 모든 그룹의 목록을 페이징하여 조회합니다.
-   **Query Parameters (Paging)**:
    -   `page` (int, optional, default: 0): 조회할 페이지 번호
    -   `size` (int, optional, default: 20): 한 페이지에 보여줄 그룹 수
-   **Success Response (200 OK)**:
    -   `data` 필드에는 `PageResponseDTO<GroupListResponse>` 객체가 포함됩니다.
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

-   **Method**: `DELETE`
-   **URL**: `/api/groups/{groupId}/leave`
-   **설명**: 특정 그룹에서 탈퇴합니다. 마지막 멤버가 탈퇴하면 그룹과 모든 관련 데이터가 영구적으로 삭제됩니다.
-   **Path Variable**:
    -   `groupId` (Long): 탈퇴할 그룹의 ID
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "그룹에서 탈퇴했습니다."
    }
    ```

---

## 3. 그룹 멤버 관리 (Group Member Management)

### 3.1. 그룹에 멤버 추가 (초대)

-   **Method**: `POST`
-   **URL**: `/api/groups/{groupId}/members`
-   **설명**: 특정 그룹에 한 명 이상의 새로운 멤버를 이메일로 초대합니다.
-   **Path Variable**:
    -   `groupId` (Long): 멤버를 추가할 그룹의 ID
-   **Request Body**:
    ```json
    {
      "memberEmails": [
        "new.member1@example.com",
        "new.member2@example.com"
      ]
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "멤버가 그룹에 추가되었습니다."
    }
    ```

### 3.2. 그룹 멤버 목록 조회

-   **Method**: `GET`
-   **URL**: `/api/groups/{groupId}/members`
-   **설명**: 특정 그룹에 참여하고 있는 모든 멤버의 목록을 페이징하여 조회합니다.
-   **Path Variable**:
    -   `groupId` (Long): 멤버 목록을 조회할 그룹의 ID
-   **Query Parameters (Paging)**:
    -   `page` (int, optional, default: 0): 조회할 페이지 번호
    -   `size` (int, optional, default: 20): 한 페이지에 보여줄 멤버 수
-   **Success Response (200 OK)**:
    -   `data` 필드에는 `PageResponseDTO<GroupMemberResponse>` 객체가 포함됩니다.
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

-   **Method**: `GET`
-   **URL**: `/api/groups/{groupId}/chat/messages`
-   **설명**: 특정 그룹(채팅방)의 이전 대화 내용을 페이징하여 조회합니다.
-   **Path Variable**:
    -   `groupId` (Long): 대화 내용을 조회할 그룹의 ID
-   **Query Parameters (Paging)**:
    -   `page` (int, optional, default: 0): 조회할 페이지 번호
    -   `size` (int, optional, default: 30): 한 페이지에 보여줄 메시지 수
    -   `sort` (String, optional, default: `sentAt,DESC`): 정렬 기준
-   **Success Response (200 OK)**:
    -   `data` 필드에는 `PageResponseDTO<ChatResponse>` 객체가 포함됩니다.
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
        "currentPage": 0,
        // ... (페이징 정보)
      },
      "message": "이전 대화 내용 조회가 완료되었습니다."
    }
    ```
