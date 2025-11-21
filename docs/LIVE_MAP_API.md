# 실시간 지도 API 명세

## 개요

이 문서는 Oath 서비스의 실시간 지도 기능과 관련된 API 및 WebSocket 명세를 설명합니다. 클라이언트는 이 문서를 참고하여 자신의 위치 정보를 서버로 전송하고, 다른 참가자들의 실시간 위치 정보를 수신하여 지도에 표시할 수 있습니다.

---

## 1. 위치 정보 전송 API

클라이언트는 주기적으로 자신의 위치 정보를 서버로 전송해야 합니다.

-   **URL**: `/api/track/tracks/bulk`
-   **Method**: `POST`
-   **설명**: 여러 개의 위치 좌표를 한 번에 서버로 전송합니다.
-   **인증**: 필요 (JWT Bearer Token)
-   **요청 본문**: `TrackBatchReq` (JSON)

    ```json
    {
      "participantId": 123, // 위치 정보를 전송하는 참가자의 ID
      "points": [
        {
          "lat": 35.123456,    // 위도
          "lng": 129.789012,   // 경도
          "ts": "2025-11-21T14:30:00", // 위치 정보 생성 시간 (ISO 8601 형식)
          "speedMps": 1.5,     // 속도 (미터/초)
          "accuracyM": 5.0,    // 정확도 (미터)
          "source": "GPS",     // 위치 정보 출처 (예: GPS, NETWORK)
          "isMock": false      // 모의 위치 정보 여부
        },
        {
          "lat": 35.123457,
          "lng": 129.789013,
          "ts": "2025-11-21T14:30:05",
          "speedMps": 1.2,
          "accuracyM": 4.5,
          "source": "GPS",
          "isMock": false
        }
      ]
    }
    ```

-   **응답**: `CommonResponse<SimpleRes>`
    ```json
    {
      "success": true,
      "data": {
        "value": 2 // 저장된 위치 정보 포인트 개수
      },
      "message": "성공"
    }
    ```
-   **성공 응답 코드**: `200 OK`
-   **오류 응답 코드**:
    -   `401 Unauthorized` (인증되지 않은 사용자)
    -   `400 Bad Request` (요청 본문 형식 오류 등)
    -   `500 Internal Server Error` (서버 내부 오류)

---

## 2. 실시간 위치 정보 수신 (WebSocket)

클라이언트는 WebSocket을 통해 다른 참가자들의 실시간 위치 정보를 구독할 수 있습니다.

-   **WebSocket 엔드포인트**: `/ws-livemap`
-   **WebSocket 프로토콜**: STOMP (Simple Text Oriented Messaging Protocol)
-   **구독 토픽 (Topic)**: `/topic/plans/{planId}/live`
    -   클라이언트는 특정 `planId`에 해당하는 토픽을 구독하여 해당 약속에 참여한 다른 사용자들의 위치 업데이트를 실시간으로 수신합니다.
    -   예시: `/topic/plans/1/live` (ID가 1인 약속의 실시간 위치 정보 구독)

-   **전송 데이터 형식**: `LiveLocationDto` (JSON)
    -   서버는 위치 정보가 업데이트될 때마다 이 형식으로 메시지를 발행합니다.

    ```json
    {
      "memberId": 1,         // 위치를 전송한 멤버의 ID
      "username": "김철수",    // 멤버의 사용자 이름
      "profileImageUrl": "http://example.com/profile/1.jpg", // 멤버의 프로필 이미지 URL
      "lat": 35.123456,      // 현재 위도
      "lng": 129.789012,     // 현재 경도
      "lastLiveTs": "2025-11-21T14:30:00" // 마지막 위치 업데이트 시간 (ISO 8601 형식)
    }
    ```

---

## 3. 클라이언트 연동 체크리스트 (성빈님과 논의 필요)

이 문서를 바탕으로 클라이언트 개발자(성빈님)와 다음 사항들을 논의하고 확인해야 합니다.

1.  **필요 라이브러리 확인**: `pubspec.yaml`에 `stomp_dart_client`, `flutter_naver_map`, `geolocator` 등 필요한 라이브러리가 모두 준비되어 있는지 확인합니다.
2.  **위치 전송 기능 구현**: 클라이언트가 주기적으로 자신의 위치(GPS)를 서버의 `/api/track/tracks/bulk` API로 전송하는 기능이 구현되어 있는지 확인합니다.
3.  **WebSocket 구독 기능 구현**: 클라이언트가 특정 약속의 `/topic/plans/{planId}/live` 토픽을 구독하는 기능이 구현되어 있는지 확인합니다.
4.  **통합 테스트 및 디버깅**:
    -   두 명의 사용자가 같은 약속에 참여한 상황을 가정하고 테스트를 진행합니다.
    -   **사용자 A**가 위치를 변경하면, **사용자 B**의 지도 화면에 있는 사용자 A의 마커가 실시간으로 움직이는지 확인합니다.
    -   만약 동작하지 않는다면, 서버 로그와 클라이언트 로그를 함께 보며 어느 단계(위치 전송, 서버 처리, WebSocket 메시지 수신, 지도 UI 업데이트)에서 문제가 발생하는지 디버깅합니다.
