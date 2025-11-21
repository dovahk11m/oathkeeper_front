# [원본] AI 서버 개발자 인수인계 문서

- **작성:** 2025-11-17
- **수정:** 2025-11-20
- **출처:** 전임 AI 담당자로부터 직접 인계받은 원본 문서입니다.

---

## 0. 프로젝트 한줄 요약

**Oathkeeper Metrics/LLM 서비스**

약속(plan)의 이동 기록(거리, 이동시간, 지각/대기시간)을 받아서
1. 점수 계산
2. 플랜별 통계 집계
3. 사람 눈에 읽기 좋은 한글 요약 텍스트를 생성

해서 Flutter 클라이언트(하단 시트)와 Spring 서버에서 바로 사용할 수 있게 해 주는 파이썬 FastAPI 마이크로서비스.

## 1. 전체 아키텍처 & 데이터 흐름

### 1-1. 큰 그림 (Flutter ↔ Spring ↔ Python ↔ Ollama)

1.  **실시간 지도(Flutter → Spring)**
    -   Flutter LiveMapPage에서 주기적으로 위치를 읽고 STOMP WebSocket으로 Spring 서버에 전송.
    -   Spring 쪽 tracking 도메인이 각 멤버의 위치 이벤트를 DB에 저장하고,
    -   약속이 종료되면 각 멤버별로
        -   이동 거리 `distance_km`
        -   이동 시간 `travel_minutes`
        -   약속 기준 지각 시간 `late_minutes`
        -   상대방을 기다린 시간 `wait_minutes`
        같은 집계된 메트릭을 만든다.

2.  **메트릭 분석 (Spring → Python FastAPI)**
    -   Spring 서버가 Python 서비스의 `POST http://<PYTHON_HOST>:8001/metrics/analyze` 엔드포인트로 `MetricsPayload` JSON을 보낸다.
    -   Python 서비스는 이걸 plan별 로그 파일(jsonl) 로 저장하면서 간단한 점수를 계산해 다시 Spring/Flutter에 돌려준다.

3.  **요약 텍스트 생성 (Flutter → Python FastAPI)**
    -   약속 상세 화면 / 하단 시트에서 Flutter가 `GET/POST http://<PYTHON_HOST>:8001/metrics/report/{planId}/text` 로 요청.
    -   Python 서비스는 `metrics.jsonl`을 읽어 통계(summary) 를 만든 뒤,
        -   규칙 기반 문장(mode="rules")
        -   규칙+랜덤 변주(mode="prompt")
        -   로컬 LLM(Ollama) 호출(mode="llm")
        중 선택해서 한국어 요약 텍스트를 돌려준다.
    -   Flutter는 이 텍스트를 카드/하단 시트에 그대로 렌더링.

4.  **LLM 백엔드 (Python → Ollama)**
    -   `OLLAMA_URL`(기본 `http://localhost:11434`) 로 `POST /api/generate` 호출.
    -   모델 이름은 `OLLAMA_MODEL` (기본 `llama3.1`) 환경변수로 설정.
    -   도메인에 맞지 않는 단어(운동/달리기/레이스 등)가 섞이면 `_sanitize_tone()` 에서 다시 치환.

## 2. 디렉터리 구조 & 역할

### 2-1. 최상위 구조 (app 폴더)

-   `main.py` – FastAPI 앱 생성 / 라우터 등록 / uvicorn 실행 스크립트
-   `models.py` – 외부에서 들어오는/나가는 데이터 정의 (Pydantic)
-   `storage.py` – plan별 파일 저장/읽기 유틸 (jsonl, summary.json)
-   `routers/` – HTTP 엔드포인트 모음 (metrics, report, llm)
-   `services/` – 비즈니스 로직 (요약 집계, LLM 호출 등)
-   `data/plan_x/` – 각 플랜별 실제 분석 데이터 저장 위치
    -   `metrics.jsonl` – 이동 기록 로그
    -   `summary.json` – 마지막 저장된 요약 결과
    -   `summary_history/` – 시간별 히스토리 백업

### 2-2. data/plan_4 예시

-   **`metrics.jsonl`**
    -   한 줄당 하나의 `MetricsPayload` 레코드(JSON).
    -   예: `{ "plan_id": 4, "member_id": 1, "distance_km": 3.2, "travel_minutes": 20, ... }`
-   **`summary.json`**
    -   `compute_summary()`로 집계된 전체 요약(전체/멤버별/하이라이트 포함).
-   **`summary_history/20251030T1538.json`**
    -   요약 저장 시점별 스냅샷 (시간별 버전 관리).

이 폴더 구조는 `storage.ensure_plan_dir(plan_id)`에서 자동으로 생성/보장한다.

## 3. 주요 모델 (models.py)

### 3-1. MetricsPayload – Spring → Python 입력 스키마

```python
class MetricsPayload(BaseModel):
    plan_id: int
    member_id: int
    distance_km: float = 0.0
    travel_minutes: int = 0
    late_minutes: Optional[int] = None
    wait_minutes: Optional[int] = None
    created_at: Optional[datetime] = None
```

-   `plan_id` / `member_id`: 어떤 약속/어떤 멤버 기록인지 식별.
-   `distance_km`: km 단위 이동 거리.
-   `travel_minutes`: 출발~도착까지 걸린 시간(분).
-   `late_minutes`: 약속 시간 기준 지각(분). 없으면 0으로 처리.
-   `wait_minutes`: 상대를 기다린 시간(분). 없으면 0으로 처리.
-   `created_at`: 기록 생성 시간 (없으면 Python에서 현재 시각 UTC로 채움).

### 3-2. MemberSummary, OverallSummary, ReportResponse – 집계 결과 스키마

-   `MemberSummary`
    -   멤버별 전체 거리/시간/지각/대기/점수·기록수·최초/최종 시간 등.
-   `OverallSummary`
    -   플랜 전체 기준: 전체 기록 수, 총 거리, 평균 거리, 총 이동 시간, 평균 이동 시간, 평균 점수 등.
-   `ReportResponse`
    -   API 응답 포맷. `summary_text` 필드에 최종 한글 요약이 들어갈 수 있는 구조.

현재 구현된 report 엔드포인트는 이 스키마를 직접 쓰기보다, 딕셔너리 형태로 summary를 리턴하고 있음. (추후 고도화 시 이 모델로 감싸면 됨.)

## 4. 저장소 계층 (storage.py)

### 4-1. 기본 설정

`DATA_ROOT = os.getenv("DATA_ROOT", os.path.join(os.getcwd(), "data"))`

-   환경변수 `DATA_ROOT`로 데이터 루트 위치 지정 (없으면 현재 경로의 `data/` 사용).

### 4-2. Plan별 경로 / 파일명

-   `_plan_dir(plan_id)` → `data/plan_{plan_id}`
-   `_metrics_path(plan_id)` → `data/plan_{plan_id}/metrics.jsonl`
-   `ensure_plan_dir(plan_id)` → 폴더 없으면 생성 후 경로 리턴.

### 4-3. 메트릭 기록 저장

```python
def append_metrics_line(plan_id: int, rec: Dict[str, Any]) -> None:
    ensure_plan_dir(plan_id)
    if not rec.get("created_at"):
        rec["created_at"] = datetime.now(timezone.utc)
    path = _metrics_path(plan_id)
    with open(path, "a", encoding="utf-8") as f:
        f.write(json.dumps(rec, ensure_ascii=False, default=_default_serializer) + "\n")
```

-   `POST /metrics/analyze` 에 들어온 JSON을 그대로 한 줄씩 추가.
-   `created_at` 이 없으면 서버에서 UTC 기준으로 추가.

### 4-4. 메트릭 읽기

```python
def iter_metrics(plan_id: int) -> Iterator[Dict[str, Any]]:
    path = _metrics_path(plan_id)
    if not os.path.exists(path):
        return
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            ...
            yield json.loads(s)
```

-   plan별 모든 기록을 제너레이터로 반환.
-   잘못된 라인은 `try/except`로 무시해서 서비스가 죽지 않도록 설계.

## 5. 서비스 계층 – report_service.py

### 5-1. 요약 집계 compute_summary(plan_id)

1.  **raw 데이터 읽기**
    -   `records = list(iter_metrics(plan_id) or [])`
    -   `total_records = len(records)`
2.  **멤버별 집계 준비**
    -   `per_member: Dict[int, Dict[str, Any]] = {}`
    -   `total_dist = 0.0`, `total_minutes = 0`, `total_late = 0`, `total_wait = 0`
3.  **각 레코드 순회하면서 합산**
    -   `_safe_int` / `_safe_float` 로 타입 안전하게 캐스팅 후 합산.
    -   member_id별로 `distance_km`, `travel_minutes`, `late_minutes`, `wait_minutes`, `records` 카운트 증가.
    -   전체 `total_*` 값도 같이 증가.
4.  **멤버 정렬**
    -   `members.sort(key=lambda m: (m["distance_km"], m["travel_minutes"]), reverse=True)`
    -   먼 거리 + 오래 이동한 사람이 리스트 상단에 오도록 정렬.
5.  **평균 계산**
    -   `avg_dist = round(total_dist / total_records, 2) if total_records else 0.0`
    -   `avg_minutes = round(total_minutes / total_records, 2) if total_records else 0.0`
6.  **하이라이트 계산 _make_highlights(members)**
    -   가장 멀리 이동한 사람, 가장 오래 이동한 사람, 평균 지각/대기시간이 가장 높은 사람 식별.
    -   각 멤버의 id + 값(`distance_km`, `travel_minutes`, `late_minutes`, `wait_minutes`) 반환.
7.  **최종 summary 구조**
    ```json
    return {
        "plan_id": plan_id,
        "generated_at": _now_iso(),
        "overall": {...},
        "members": members,
        "highlights": {...}
    }
    ```

### 5-2. 요약 저장 save_summary(plan_id, summary)

-   `summary.json` – 최신 상태 덮어쓰기.
-   `summary_history/yyyymmddTHHMMSS.json` – 히스토리용 별도 파일 생성.
-   Flutter / Spring에서 “이전 요약이 어떻게 바뀌었는지” 추적하고 싶으면 이 폴더를 보면 됨.

### 5-3. 요약 텍스트 생성 summary_to_text(...)

```python
def summary_to_text(summary: Dict[str, Any],
                    mode: str = "rules",
                    style: str = "",
                    notes: str = "",
                    seed: Optional[int] = None,
                    name_map: Optional[Dict[int, str]] = None) -> str:
```

-   **공통 이름 매핑:** `name_map`(id→이름)이 들어오면 `_get_name()`을 통해 `회원#1` 대신 실제 이름 사용.
-   **(1) mode = "rules" – 가장 단순/안전한 기본 요약**
    -   `_rules_text(summary, name_fn)` 호출.
    -   구조:
        -   첫 문장: `약속 #4의 요약입니다. 총 21건의 기록이 있으며, 최근에 종료된 약속 기준으로 정리했습니다.`
        -   두 번째: 전체 이동 거리/시간.
        -   세 번째: 상위 3명의 거리/시간 소개.
        -   마지막: `"다음 약속도 시간 여유를 두고 이동하면 더 편하게 만날 수 있어요."`
-   **(2) mode = "prompt" – LLM 없이 더 자연스러운 변주**
    -   `_rules_insights_lines()` 로 인사이트 문장 리스트 생성.
    -   이동시간이 제일 긴 사람 vs 짧은 사람 비교.
    -   평균 대비 거리는 가까운데 시간이 오래 걸리는 ‘역설 케이스’.
    -   평균 지각시간 비교.
    -   `style` / `notes` 값에 따라 말투·정렬 방식을 살짝 바꾼 후 랜덤한 `opener/closer`(격려 문장)을 붙여서 여러 줄짜리 요약 생성.
-   **(3) mode = "llm" – Ollama LLM 이용**
    -   `_llm_text_with_ollama(...)` 호출.
    -   프롬프트 내용:
        -   3~5문장, 한국어.
        -   도메인 톤: 약속/이동/도착 관점으로만.
        -   금지어: 운동, 달리다, 완주, 레이스 등 (러닝 앱같은 말투 방지).
        -   시작 문장 예시, 마지막은 짧은 격려.
    -   응답 받은 뒤 `_sanitize_tone()`으로 마지막 보정.
-   **인수인계 팁:**
    -   운동/달리기 같은 말이 나오면 `_sanitize_tone`에 치환 규칙 추가하면 됨.
    -   스타일을 더 세밀히 바꾸고 싶으면 `_llm_text_with_ollama`의 프롬프트 문구를 조정하면 됨.

## 6. 라우터 계층 – API 명세

### 6-1. /metrics 라우터 (routers/metrics.py)

1.  **`POST /metrics/analyze` – 한 건의 이동 기록 등록 + 점수 계산**
    -   **요청 바디:** `MetricsPayload`
        ```json
        {
          "plan_id": 4,
          "member_id": 1,
          "distance_km": 3.2,
          "travel_minutes": 18,
          "late_minutes": 2,
          "wait_minutes": 0
        }
        ```
    -   **처리 로직:**
        1.  `plan_id` 유효성 체크 (0 이하이면 404).
        2.  `append_metrics_line()`으로 `metrics.jsonl`에 추가.
        3.  `score = 100 - late_minutes - 0.5 * wait_minutes` 계산.
    -   **응답 예:**
        ```json
        {
          "success": true,
          "data": {
            "plan_id": 4,
            "member_id": 1,
            "score": 98.0,
            "summary": "3.20km 이동, 18분 소요"
          }
        }
        ```

2.  **`_assert_plan_state(plan_id)` – 404 / 409 에러 정의**
    -   plan 디렉토리가 없으면 → `404 PLAN_NOT_FOUND`.
    -   metrics 기록이 1건도 없으면 → `409 NOT_READY`.
    -   → Flutter `MetricsSummarySheet`에서 `_notReadyYet`로 분기 처리했던 부분이 여기랑 연결됨.

3.  **`GET /metrics/report/{planId}/text` – 기본 규칙 기반 요약 텍스트**
    -   summary 계산 후, `summary_to_text(summary, mode="rules")` 결과만 반환.

4.  **`POST /metrics/report/{planId}/text` – 모드/스타일 지정 요약 텍스트**
    -   **요청 바디 예:**
        ```json
        {
          "mode": "llm",
          "style": "조금 친근한 말투, 너무 가볍지는 않게",
          "notes": "지각이 많은 사람 강조, 응원 톤",
          "name_map": { "1": "수월", "2": "세리" }
        }
        ```
    -   `compute_summary()` → `summary_to_text(mode, style, notes, name_map)` 호출 후 `{"success": true, "data": "<텍스트>"}` 형식으로 응답.
    -   Flutter `MetricsTextPage`, `MetricsSummarySheet` 에서 여기로 바로 붙어있다고 보면 됨.

### 6-2. /report 라우터 (routers/report.py)

-   이쪽은 조금 더 리포트/관리자용 느낌의 API.
-   `TextOptions` 모델: `mode`, `style`, `notes`, `seed`, `name_map` 필드 정의.
-   `_assert_ready_or_409` – 기록이 0이면 `409 NOT_READY`.

1.  **`GET /metrics/report/{planId}`**
    -   summary 계산 + `save_summary()` 호출까지 수행.
    -   **응답:** `{ summary, saved: { summary_path, history_path } }` 구조.

2.  **`GET /metrics/report/{planId}/text`**
    -   `rules` 모드 텍스트 바로 리턴. (metrics 라우터와 동일 역할)

3.  **`POST /metrics/report/{planId}/text` – 타입 안정적인 버전**
    -   `TextOptions`로 요청 받음.
    -   `opts.name_map`(key는 string) → 내부적으로 int 키로 변환 후 `summary_to_text`에 넘김.
    -   **응답:** `{ "data": { "plan_id": ..., "mode": ..., "text": "..." } }`

-   **인수인계 포인트:**
    -   Flutter용은 `/metrics/report/...` 계열을,
    -   **관리자/툴링용은 `/report/...` 계열을 쓰는 식**으로 역할을 나눌 수 있음.

### 6-3. /llm 라우터 (routers/llm.py)

-   완전 일반적인 LLM 호출용 유틸.
-   **`POST /metrics/llm/generate`**
    ```json
    {
      "system": "항상 한국어로만 답하세요.",
      "prompt": "이동 기록 요약 프롬프트..."
    }
    ```
-   내부에서 `services.llm_client.generate_ko()` 호출 → Ollama에 POST.
-   실패 시 502 에러로 감싸서 반환.

## 7. 앱 구동 및 환경 설정

1.  **필수 환경 변수**
    -   `DATA_ROOT` (선택): 데이터 저장 디렉토리 (기본 `./data`).
    -   `OLLAMA_URL` (선택): Ollama 서버 주소, 기본 `http://localhost:11434`.
    -   `OLLAMA_MODEL` (선택): 사용할 모델 이름, 기본 `"llama3.1"`.

2.  **로컬 실행**
    ```sh
    cd oathkeeper_python
    set DATA_ROOT=C:\java_1205\oathkeeper_python\data # 윈도라면 선택
    uvicorn app.main:app --host 0.0.0.0 --port 8001 --reload
    ```
    -   또는 `python -m app.main` 형태로 실행 (`main.py`에 `uvicorn.run` 포함).

3.  **Spring / Flutter에서 접근하는 주소**
    -   Spring: `http://python-host:8001/metrics/...`
    -   Flutter 에뮬: `http://10.0.2.2:8001/metrics/...` (이미 `aiDioProvider`에서 이렇게 사용).

## 8. 실시간 지도에서 여기까지의 “한 장 요약” (발표용 키워드)

발표용으로 쓰라고 하면, 아래 정도 흐름으로 한 장 구성하면 된다:

1.  **실시간 위치 수집 (Flutter)**
    -   `geolocator`로 현재 위치 → Naver Map에 마커 표시.
    -   STOMP WebSocket으로 `/topic/plan/{planId}` 방에 위치 이벤트 전송.
2.  **서버에서 이동 경로 분석 (Spring)**
    -   위치 이벤트를 DB에 적재.
    -   약속 종료 시:
        -   각 멤버의 전체 이동 거리, 이동 시간 계산
        -   약속 시각 기준 지각/대기 시간 산출
        -   → `MetricsPayload` 형태로 Python 서비스에 전달.
3.  **Python Metrics 서비스 (FastAPI)**
    -   `POST /metrics/analyze`: 기록을 `jsonl`로 저장, 지각/대기 기반 점수 계산.
    -   `GET/POST /metrics/report/{planId}/text`:
        -   `metrics.jsonl` → `compute_summary()`로 집계
        -   `summary_to_text()`로 약속 요약 텍스트 생성 (규칙/LLM 선택)
4.  **Flutter 요약 UI**
    -   하단 시트 `MetricsSummarySheet` / `MetricsTextPage`에서 `planId`와 멤버 이름 map을 넘겨 텍스트 받아서 카드 UI로 렌더링.
    -   404 → “현재 활성 약속 없음”, 409 → “아직 집계 중” UI로 분기.

**키워드로 정리하면:**

> “실시간 위치 이벤트 → Spring 이동/지각 분석 → Python 메트릭 집계·요약 → Flutter 요약 카드 UI”

## 9. 인수인계 포인트

1.  **데이터 구조**
    -   `MetricsPayload`의 필드 의미를 정확히 알아야 Spring 단에서 값을 제대로 계산해서 보낸다.
2.  **오류 코드 계약**
    -   `404 PLAN_NOT_FOUND`, `409 NOT_READY` 의미를 Flutter/Spring에서 이미 사용 중이므로 마음대로 바꾸지 말 것.
3.  **파일 기반 저장의 장단점**
    -   **장점:** DB 없이도 빠르게 개발/테스트 가능.
    -   **단점:** 동시성, 파일 잠금, 백업 등이 필요하다면 추후 DB로 마이그레이션 검토.
4.  **LLM 의존도**
    -   운영 환경에서 Ollama가 내려가면 `mode="llm"` 요청은 실패하므로,
    -   클라이언트에서는 기본 모드를 `rules` 또는 `prompt`로 두고, LLM은 옵션 기능으로 두는 게 안정적.
5.  **이상한 텍스트 나올 때 디버깅 순서**
    -   summary 값이 이상한지 → `GET /metrics/report/{planId}`로 raw summary 확인.
    -   summary가 정상인데 말투만 이상 → `summary_to_text()` & `_llm_text_with_ollama()` 프롬프트/치환 규칙 확인.
    -   “운동/달리기” 같은 단어 → `_sanitize_tone`에 추가.
