# Plan API 명세

## 개요

이 문서는 Oath 서비스의 약속(Plan) 관련 API 엔드포인트를 설명합니다. 클라이언트 개발자는 이 문서를 참고하여 약속 생성, 조회, 수정, 참여자 관리 등 다양한 기능을 연동할 수 있습니다.

---

## 인증 (Authentication)

모든 API는 JWT 기반의 Bearer Token 인증을 사용합니다. 요청 헤더에 `Authorization: Bearer <YOUR_JWT_TOKEN>` 형식으로 토큰을 포함해야 합니다.

---

## API 목록

### 1. 플랜 목록 조회

-   **URL**: `/api/plans`
-   **Method**: `GET`
-   **설명**: 본인이 생성하거나 참여한 플랜 목록을 조회합니다.
-   **인증**: 필요
-   **응답**: `CommonResponse<List<PlanResponse.CreatePlan>>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**: `401 Unauthorized` (인증되지 않은 사용자)

### 2. 추천 플랜 목록 조회

-   **URL**: `/api/plans/recommend`
-   **Method**: `GET`
-   **설명**: 사용자에게 추천하는 플랜 목록을 조회합니다.
-   **인증**: 필요
-   **쿼리 파라미터**:
    -   `currentPlanId` (Long): 현재 보고 있는 플랜의 ID (추천 로직에 활용)
    -   `limit` (Long): 조회할 추천 플랜의 최대 개수
-   **응답**: `CommonResponse<List<PlanResponse.CreatePlan>>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**: `401 Unauthorized` (인증되지 않은 사용자)

### 3. 플랜 상세 조회

-   **URL**: `/api/plans/{id}`
-   **Method**: `GET`
-   **설명**: 특정 플랜의 상세 정보를 조회합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `id` (Long): 조회할 플랜의 ID
-   **응답**: `CommonResponse<PlanResponse.CreatePlan>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (접근 권한 없음)
    -   `404 Not Found` (플랜을 찾을 수 없음)

### 4. AI 요약 보고서 제공 API (폴링 방식)

-   **URL**: `/api/plans/{planId}/summary`
-   **Method**: `GET`
-   **설명**: AI가 생성한 약속 요약 보고서를 제공합니다. 요약 생성에 시간이 걸릴 수 있으므로 폴링 방식으로 동작합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): 요약 보고서를 조회할 플랜의 ID
-   **응답**: `CommonResponse<PlanResponse.Summary>`
-   **성공 응답 코드**:
    -   `200 OK`: AI 요약 보고서 조회 성공
    -   `202 Accepted`: AI 요약 보고서 생성 중. 클라이언트는 잠시 후 다시 요청해야 합니다.
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (접근 권한 없음)
    -   `404 Not Found` (플랜을 찾을 수 없음)
    -   `500 Internal Server Error` (AI 요약 생성 실패)

### 5. 플랜 생성

-   **URL**: `/api/plans`
-   **Method**: `POST`
-   **설명**: 새로운 플랜을 생성합니다.
-   **인증**: 필요
-   **요청 본문**: `PlanRequest.CreatePlanRequest`
    ```json
    {
      "creatorMemberId": 1,
      "title": "새로운 약속",
      "planDatetime": "2025-12-25T18:00:00",
      "status": "PLANNING",
      "lateFineAmount": 5000
    }
    ```
-   **응답**: `CommonResponse<PlanResponse.CreatePlan>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `404 Not Found` (멤버를 찾을 수 없음)

### 6. 플랜 수정

-   **URL**: `/api/plans/{id}`
-   **Method**: `PUT`
-   **설명**: 특정 플랜의 정보를 수정합니다. 플랜 생성자만 수정 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `id` (Long): 수정할 플랜의 ID
-   **요청 본문**: `PlanRequest.UpdatePlanRequest`
    ```json
    {
      "title": "수정된 약속 제목",
      "planDatetime": "2025-12-25T19:00:00",
      "status": "CONFIRMED",
      "tags": ["식사", "모임"]
    }
    ```
-   **응답**: `CommonResponse<PlanResponse.CreatePlan>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (플랜 생성자만 수정 가능)
    -   `404 Not Found` (플랜을 찾을 수 없음)

### 7. 플랜 삭제

-   **URL**: `/api/plans/{id}`
-   **Method**: `DELETE`
-   **설명**: 특정 플랜을 삭제합니다. 플랜 생성자만 삭제 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `id` (Long): 삭제할 플랜의 ID
-   **응답**: `CommonResponse<Object>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (플랜 생성자만 삭제 가능)
    -   `404 Not Found` (플랜을 찾을 수 없음)

### 8. 참가자 추가

-   **URL**: `/api/plans/{planId}/participants`
-   **Method**: `POST`
-   **설명**: 플랜에 참가자를 추가합니다. 플랜 생성자만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): 참가자를 추가할 플랜의 ID
-   **요청 본문**: `PlanRequest.ParticipantAddRequest`
    ```json
    {
      "memberId": 2
    }
    ```
-   **응답**: `CommonResponse<ParticipantResponse>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (플랜 생성자만 가능)
    -   `404 Not Found` (플랜 또는 멤버를 찾을 수 없음)

### 9. 참가자 삭제

-   **URL**: `/api/plans/{planId}/participants/{participantId}`
-   **Method**: `DELETE`
-   **설명**: 플랜에서 참가자를 삭제합니다. 플랜 생성자 또는 본인만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): (사용되지 않지만 URL 구조상 포함)
    -   `participantId` (Long): 삭제할 참가자의 ID
-   **응답**: `CommonResponse<Object>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (권한 없음)
    -   `404 Not Found` (참가자를 찾을 수 없음)

### 10. 참가자 상태 변경

-   **URL**: `/api/plans/participants/{participantId}/status`
-   **Method**: `PUT`
-   **설명**: 참가자의 플랜 참여 상태(수락/거절 등)를 변경합니다. 본인만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `participantId` (Long): 상태를 변경할 참가자의 ID
-   **요청 본문**: `PlanRequest.ParticipantStatusRequest`
    ```json
    {
      "status": "ACCEPTED"
    }
    ```
-   **응답**: `CommonResponse<ParticipantResponse>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `400 Bad Request` (상태 값이 올바르지 않음)
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (권한 없음)
    -   `404 Not Found` (참가자를 찾을 수 없음)

### 11. 참가자 목록 조회

-   **URL**: `/api/plans/{planId}/participants`
-   **Method**: `GET`
-   **설명**: 특정 플랜의 참가자 목록을 조회합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): 참가자 목록을 조회할 플랜의 ID
-   **응답**: `CommonResponse<List<ParticipantResponse>>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (접근 권한 없음)
    -   `404 Not Found` (플랜을 찾을 수 없음)

### 12. 출발 시간 기록

-   **URL**: `/api/plans/participants/{participantId}/departure`
-   **Method**: `POST`
-   **설명**: 참가자가 약속 장소를 향해 출발한 시간을 기록합니다. 본인만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `participantId` (Long): 출발 시간을 기록할 참가자의 ID
-   **요청 본문**: `PlanRequest.TimeRecordRequest`
    ```json
    {
      "time": "2025-12-25T17:30:00"
    }
    ```
-   **응답**: `CommonResponse<ParticipantResponse>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (권한 없음)
    -   `404 Not Found` (참가자를 찾을 수 없음)

### 13. 도착 시간 기록

-   **URL**: `/api/plans/participants/{participantId}/arrival`
-   **Method**: `POST`
-   **설명**: 참가자가 약속 장소에 도착한 시간을 기록합니다. 본인만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `participantId` (Long): 도착 시간을 기록할 참가자의 ID
-   **요청 본문**: `PlanRequest.TimeRecordRequest`
    ```json
    {
      "time": "2025-12-25T18:00:00"
    }
    ```
-   **응답**: `CommonResponse<ParticipantResponse>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `400 Bad Request` (플랜의 약속 시간이 설정되어 있지 않음)
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (권한 없음)
    -   `404 Not Found` (참가자를 찾을 수 없음)

### 14. 예상 출발 시간 제안

-   **URL**: `/api/plans/participants/{participantId}/suggest-departure`
-   **Method**: `POST`
-   **설명**: 참가자의 예상 출발 시간을 제안합니다. 본인만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `participantId` (Long): 예상 출발 시간을 제안할 참가자의 ID
-   **요청 본문**: `PlanRequest.SuggestDepartureRequest`
    ```json
    {
      "expectedTravelTimeMinutes": 30
    }
    ```
-   **응답**: `CommonResponse<ParticipantResponse>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `400 Bad Request` (플랜의 약속 시간이 설정되어 있지 않음)
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (권한 없음)
    -   `404 Not Found` (참가자를 찾을 수 없음)

### 15. 지각 벌금 조회

-   **URL**: `/api/plans/participants/{participantId}/late-fine`
-   **Method**: `GET`
-   **설명**: 참가자의 지각 벌금을 조회합니다. 본인 또는 플랜 생성자만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `participantId` (Long): 지각 벌금을 조회할 참가자의 ID
-   **응답**: `CommonResponse<Long>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (권한 없음)
    -   `404 Not Found` (참가자를 찾을 수 없음)

### 16. 장소 확정

-   **URL**: `/api/plans/{planId}/confirm-place`
-   **Method**: `POST`
-   **설명**: 플랜의 약속 장소를 확정합니다. 플랜 생성자만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): 장소를 확정할 플랜의 ID
-   **요청 본문**: `PlanRequest.ConfirmPlaceRequest`
    ```json
    {
      "placeName": "부산시청",
      "latitude": 35.1796,
      "longitude": 129.0756
    }
    ```
-   **응답**: `CommonResponse<PlanResponse.CreatePlan>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (플랜 생성자만 가능)
    -   `404 Not Found` (플랜을 찾을 수 없음)

### 17. 플랜 최종 확정

-   **URL**: `/api/plans/{planId}/confirm`
-   **Method**: `POST`
-   **설명**: 플랜을 최종 확정 상태로 변경합니다. 플랜 생성자만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): 최종 확정할 플랜의 ID
-   **응답**: `CommonResponse<Plan>`
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `400 Bad Request` (이미 확정되거나 완료된 약속, 장소가 확정되지 않음, 참여자가 없음)
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `403 Forbidden` (플랜 생성자만 가능)
    -   `404 Not Found` (플랜을 찾을 수 없음)

### 18. 약속 완료 (생성자만 수동 완료 가능)

-   **URL**: `/api/plans/{planId}/complete`
-   **Method**: `POST`
-   **설명**: 플랜을 수동으로 완료 상태로 변경합니다. 플랜 생성자만 가능합니다.
-   **인증**: 필요
-   **경로 변수**:
    -   `planId` (Long): 완료할 플랜의 ID
-   **응답**: `CommonResponse<PlanResponse.CreatePlan>`
-   **성공 응답 코드**: `200 OK`
