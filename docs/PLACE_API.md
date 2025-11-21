# 장소(Place) 및 태그(Tag) API 명세

- **최종 수정 일자:** 2025-11-18

---

## 1. 개요 (Overview)

이 문서는 사용자가 약속 장소를 정하거나, 약속의 성격을 표현하기 위해 사용되는 '장소(Place)'와 '태그(Tag)' 데이터, 그리고 그 관계를 정의하고 관리하는 API에 대해 설명합니다.

-   **`Place`**: 약속 장소 후보가 되는 모든 장소 정보입니다. (e.g., 이름, 주소, 좌표 등)
-   **`Tag`**: 장소의 특징("맛집", "카페")이나 약속의 목적("스터디", "데이트")을 나타내는 키워드입니다.
-   **관계 엔티티**:
    -   **`PlaceTag`**: 장소와 태그의 N:N 관계를 연결합니다.
    -   **`PlanTag`**: 약속과 태그의 N:N 관계를 연결합니다.

### 1.1. 엔티티 관계 다이어그램 (ERD)

```
[ Plan ] ---< (plan_tag) >--- [ Tag ] ---< (place_tag) >--- [ Place ]
```

-   **Plan ↔ Tag**: N:N 관계. 하나의 약속은 여러 태그를 가질 수 있고, 하나의 태그는 여러 약속에 사용될 수 있습니다.
-   **Place ↔ Tag**: N:N 관계. 하나의 장소는 여러 태그를 가질 수 있고, 하나의 태그는 여러 장소에 사용될 수 있습니다.

---

## 2. 사용자 API (User-Facing API)

일반 사용자가 장소를 검색하고 추천받기 위해 사용하는 API입니다.

### 2.1. 태그로 장소 검색

-   **URL**: `GET /api/places/search-by-tag`
-   **설명**: 특정 태그를 가진 장소들의 ID 목록을 반환합니다.
-   **쿼리 파라미터**: `tagName` (String, required)
-   **성공 응답 (200 OK)**: `data` 필드에 장소 ID의 배열(e.g., `[1, 5, 12]`)을 포함합니다.

### 2.2. 태그 기반 장소 추천

-   **URL**: `GET /api/places/recommend`
-   **설명**: 여러 태그를 기반으로 약속의 참여자 수만큼 장소를 추천합니다.
-   **쿼리 파라미터**: `planId` (Long, required), `tagNames` (List<String>, required)
-   **성공 응답 (200 OK)**: `data` 필드에 추천된 장소 정보(`PlaceResponse`)의 배열을 포함합니다.

### 2.3. 이름으로 장소 ID 검색

-   **URL**: `GET /api/places/search-by-name`
-   **설명**: 장소의 정확한 이름으로 장소 ID를 검색합니다.
-   **쿼리 파라미터**: `placeName` (String, required)
-   **성공 응답 (200 OK)**: `data` 필드에 장소 ID (Long)를 포함합니다.

### 2.4. 장소 이름 자동 완성

-   **URL**: `GET /api/places/autocomplete/name`
-   **설명**: 입력된 접두사로 시작하는 장소 이름 목록을 반환합니다. (최대 10개)
-   **쿼리 파라미터**: `prefix` (String, required)
-   **성공 응답 (200 OK)**: `data` 필드에 장소 이름의 배열(e.g., `["부산역", "부산대학교"]`)을 포함합니다.

### 2.5. 태그 이름 자동 완성

-   **URL**: `GET /api/places/autocomplete/tag`
-   **설명**: 입력된 접두사로 시작하는 태그 이름 목록을 반환합니다. (최대 10개)
-   **쿼리 파라미터**: `prefix` (String, required)
-   **성공 응답 (200 OK)**: `data` 필드에 태그 이름의 배열(e.g., `["횟집", "회사 근처"]`)을 포함합니다.

---

## 3. 관리자 API (Admin API)

관리자가 장소, 태그 및 관계 데이터를 직접 생성, 수정, 삭제하기 위해 사용하는 API입니다.

### 3.1. 장소(Place) 관리

-   **Controller**: `PlaceAdminController`
-   **Base URL**: `/admin/places`

| Method | URL | 설명 | Request Body |
| --- | --- | --- | --- |
| `POST` | `/` | 새로운 장소를 생성합니다. | `PlaceRequestDto` |
| `PUT` | `/{placeId}` | 기존 장소의 정보를 수정합니다. | `PlaceRequestDto` |
| `DELETE` | `/{placeId}` | 특정 장소를 삭제합니다. | (없음) |

### 3.2. 태그(Tag) 관리

-   **Controller**: `TagAdminController`
-   **Base URL**: `/admin/tags`

| Method | URL | 설명 | Request Body |
| --- | --- | --- | --- |
| `POST` | `/` | 새로운 태그를 생성합니다. | `TagRequestDto` |
| `PUT` | `/{tagId}` | 기존 태그의 이름을 수정합니다. | `TagRequestDto` |
| `DELETE` | `/{tagId}` | 특정 태그를 삭제합니다. | (없음) |

### 3.3. 장소-태그 연결 관리

-   **Controller**: `PlaceTagAdminController`
-   **Base URL**: `/admin/place-tags`

| Method | URL | 설명 | Request Body |
| --- | --- | --- | --- |
| `POST` | `/` | 특정 장소에 태그를 연결합니다. | `PlaceTagRequestDto` |
| `DELETE` | `/` | 특정 장소와 태그의 연결을 해제합니다. | `PlaceTagRequestDto` |

---

## 4. 약속-태그 연결 (참고)

-   **설명**: 약속에 태그를 연결하는 기능은 별도의 관리자 API 없이, **약속 수정 API** 내에서 함께 처리됩니다.
-   **관련 API**: `PUT /api/plans/{planId}`
-   **동작**: 약속 수정 시 `tags` 필드에 태그 이름 배열(e.g., `["스터디", "카페"]`)을 포함하여 요청하면, `PlanFacade`가 기존 연결은 삭제하고 새로운 연결을 생성합니다.
