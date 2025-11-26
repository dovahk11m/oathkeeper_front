# Group API 명세서

- **최종 수정 일자:** 2025-11-25

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

### 2.3. 그룹에서 탈퇴

- **Method**: `DELETE`
- **URL**: `/api/groups/{groupId}/leave`
- **설명**: 특정 그룹에서 탈퇴합니다. 마지막 멤버가 탈퇴하면 그룹과 모든 관련 데이터가 영구적으로 삭제됩니다.
- **Path Variable**:
    - `groupId` (Long): 탈퇴할 그룹의 ID
- **Success Response (200 OK)**

### 2.4. 그룹 내 약속 목록 조회

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/plans`
- **설명**: 특정 그룹에 속한 약속 목록을 페이징하여 조회합니다.
- **Path Variable**:
    - `groupId` (Long): 약속 목록을 조회할 그룹의 ID
- **Query Parameters**:
    - `status` (String, optional): 조회할 약속의 상태. (예: `COMPLETED`).
    - `page`, `size`, `sort`
- **Success Response (200 OK)**:
    - `data` 필드에는 `PageResponseDTO<SimplePlan>` 객체가 포함됩니다.

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
- **Success Response (200 OK)**

### 3.2. 그룹 멤버 목록 조회

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/members`
- **설명**: 특정 그룹에 참여하고 있는 모든 멤버의 목록을 페이징하여 조회합니다.
- **Path Variable**:
    - `groupId` (Long): 멤버 목록을 조회할 그룹의 ID
- **Query Parameters (Paging)**
- **Success Response (200 OK)**:
    - `data` 필드에는 `PageResponseDTO<GroupMemberResponse>` 객체가 포함됩니다.

---

## 4. 채팅 (Chat)

### 4.1. 이전 대화 내용 조회

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/chat/messages`
- **설명**: 특정 그룹(채팅방)의 이전 대화 내용을 페이징하여 조회합니다.
- **Path Variable**:
    - `groupId` (Long): 대화 내용을 조회할 그룹의 ID
- **Query Parameters (Paging)**
- **Success Response (200 OK)**:
    - `data` 필드에는 `PageResponseDTO<ChatResponse>` 객체가 포함됩니다.

---

## 5. 그룹 통계 (Group Metrics)

### 5.1. 그룹 누적 통계 및 AI 요약 조회

- **Method**: `GET`
- **URL**: `/api/groups/{groupId}/metrics/summary`
- **설명**: 특정 그룹에 속한 모든 '완료된' 약속들의 데이터를 종합하여, 그룹 전체의 누적 통계 및 AI 자연어 요약을 조회합니다. 이 API는 내부적으로 Python AI 서버와 통신합니다.
- **인증**: 필요
- **Path Variable**:
    - `groupId` (Long): 통계를 조회할 그룹의 ID
- **Success Response (200 OK)**:
    - `data` 필드에는 AI 서버가 반환한 JSON 객체가 그대로 포함됩니다.
  ```json
  {
    "success": true,
    "data": {
      "group_summary": {
        "total_plans_analyzed": 4,
        "total_records": 128,
        "total_distance_km": 258.4,
        "avg_distance_per_plan_km": 64.6,
        "total_late_minutes": 45,
        "avg_late_minutes_per_plan": 11.25
      },
      "text_summary": "분석된 4개의 약속에 따르면, 이 그룹은 약속당 평균 64.6km를 이동했으며, 평균 11.25분의 지각 시간을 기록했습니다. 전반적으로 장거리 이동이 잦고, 약속 시간을 준수하는 데 약간의 어려움이 있는 경향을 보입니다."
    },
    "message": "그룹 통계 조회가 완료되었습니다."
  }
  ```
- **Special Case Response (200 OK - 분석할 약속 없음)**:
    - 그룹 내에 '완료' 상태의 약속이 하나도 없을 경우, `data`에 빈 통계 정보를 반환합니다.
  ```json
  {
    "success": true,
    "data": {
      "message": "통계를 생성할 약속이 없습니다.",
      "group_summary": {}
    },
    "message": "그룹 통계 조회가 완료되었습니다."
  }
  ```
- **Error Response**:
    - `401 Unauthorized`: 인증되지 않은 사용자
    - `403 Forbidden`: 그룹에 속하지 않은 사용자
    - `500 Internal Server Error`: AI 서버 통신 실패 또는 기타 서버 오류

#### 클라이언트 구현 가이드

- **비동기 처리 가능성**: 그룹 요약은 다수의 약속 데이터를 처리하므로, 응답 시간이 길어질 수 있습니다. 향후 폴링(Polling) 방식으로 변경될 수 있으므로, API 호출 시 로딩 인디케이터를 표시하는 것을 권장합니다.
- **오류 처리**: `500` 에러 발생 시, 사용자에게 "일시적인 오류로 그룹 요약을 불러올 수 없습니다." 와 같은 메시지를 표시하고, "다시 시도" 기능을 제공하는 것이 좋습니다.
