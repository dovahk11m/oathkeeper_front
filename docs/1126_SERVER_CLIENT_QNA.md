# 클라이언트-서버 확인 요청 및 답변 기록 (2025-11-26)

- 목적: 최근 서버 변경사항에 대해 클라이언트가 요청/확인한 내역과 서버 답변을 정리

---

## 1. 서버 전달 사항 (클라 → 서버)
1) AI 동작 시나리오용 테스트 API 추가 요청: `POST /api/plans/{planId}/participants/{participantId}/test/force-movement-status` (movement-status 강제변경). 자세한 사용법은 `docs/LIVE_MAP_API.md`의 “6. 테스트용 API”.
2) 문서 최신화 요청: 그룹/메트릭스 API 문서의 지라 사항 반영, 응답 필드(`reason` 등) 정리.

---

## 2. 클라이언트 확인 요청 목록 (진행/대기)
1) 응답 스키마 최종 확인: Group/Plan 목록·메트릭스 응답이 문서대로(items, currentPage, reason 등) 확정됐는지. 최근 스키마 불일치/500 이슈 확인 필요.
2) LiveMap WebSocket 확인: `/ws-livemap`, `/topic/plans/{planId}/live`, `/events`가 각 환경에서 정상 열려 있고 JWT 헤더가 필요한지 그대로인지 확인.
3) 위치 업로드 API 확인: `POST /api/track/tracks/bulk` CORS/인증 정책 점검 요청.
4) 테스트용 API 활성화 환경: movement-status/force-stationary/force-arrived가 어느 환경(local 등)에서 활성화돼 있는지 안내 요청.
5) WS 경로/프로토콜 통일 요청: 채팅/라이브맵 WS 엔드포인트·토픽을 환경별로 일관되게 맞춰달라. JWT 헤더가 프록시/게이트웨이 구간에서 유지되는지 확인 부탁.

---

## 3. 서버 답변 (2025-11-26)
- 응답 스키마: 그룹 목록 등 페이지 응답은 `items`, `currentPage` 등 PageResponseDTO 구조로 반환. 메트릭스 응답의 data 필드명은 `reason`으로 확정. 현재 문서와 코드가 일치.
- LiveMap WebSocket: 엔드포인트 `/ws-stomp`(SockJS) / `/ws`(pure) 사용, 모든 환경에서 동일. 토픽은 `/topic/plans/{planId}/live`, `/events`. JWT 필수.
- 위치 업로드: `POST /api/track/tracks/bulk` CORS/인증 문제 없음. JWT 필요.
- 테스트용 강제 API: `@Profile("local")`에서만 활성. 운영(prod)에서는 404.

---

## 4. 추가 질문/요청
- WS 경로/프로토콜 통일: 채팅/라이브맵 WS 엔드포인트/토픽을 환경별로 일관되게 확정해 주시면 .env로 바로 적용 가능. JWT 헤더가 프록시/게이트웨이 구간에서 유지되는지 재확인 요청.
- 응답 스키마 변경 발생 시 문서 버전과 함께 공지 요청.

## 5. 추가 답변 (2025-11-26)

추가로 주신 질문/요청에 대해 답변드립니다.

-   **WS 경로/프로토콜 통일:**
    -   **엔드포인트:** 채팅, 라이브맵 등 모든 WebSocket 기능은 **`/ws-stomp`** (SockJS 지원) 또는 **`/ws`** (순수 WebSocket)라는 단일 엔드포인트를 사용합니다. 이는 모든 환경(`local`, `prod` 등)에서 동일하며, 클라이언트에서는 이 경로를 `.env` 등으로 관리하시면 됩니다.
    -   **토픽:** 메시지를 보내고 받는 상세 토픽(예: `/topic/chats/{chatRoomId}`, `/topic/plans/{planId}/live`)은 각 기능의 요구사항에 따라 달라지지만, 모든 토픽의 최상위 경로는 `/topic` (구독)과 `/app` (발행)으로 통일되어 있습니다.
    -   **JWT 헤더 유지:** 현재 서버 아키텍처는 별도의 프록시나 API 게이트웨이를 사용하지 않고, 클라이언트와 서버가 직접 통신하는 구조입니다. 따라서 STOMP 연결 시 헤더에 담긴 JWT 토큰은 **중간에 소실될 우려 없이 서버의 인증 인터셉터(`StompInterceptor`)에 안전하게 전달**됩니다.

-   **응답 스키마 변경 공지:**
    -   네, 알겠습니다. 앞으로 API 응답 스키마에 변경이 있을 경우, **문서에 버전(예: 최종 수정 일자)을 명시하고 변경 내역을 명확하게 기재하여 공지**하도록 하겠습니다.
