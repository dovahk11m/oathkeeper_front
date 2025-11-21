# 리뷰(Review) 도메인 API 명세 및 작업 계획

- **작성일:** 2025-11-20

이 문서는 사용자가 완료된 약속에 대해 후기(리뷰)를 작성하고 관리하는 기능의 API 명세와 향후 개발 계획을 정의합니다.

---

## 1. 개요 (Overview)

-   **목표:** 사용자는 완료된 약속(`Plan`)에 대해 별점(rating)과 텍스트 후기(content)를 남길 수 있습니다.
-   **주요 엔티티 관계:**
    -   `Review`는 하나의 `Plan`과 하나의 `Member`에 속합니다.
    -   하나의 `Plan`은 여러 개의 `Review`를 가질 수 있습니다.

---

## 2. API 명세

### 2.1. 후기 작성

-   **Method**: `POST`
-   **URL**: `/api/reviews`
-   **설명**: 특정 약속(`planId`)에 대해 새로운 후기를 작성합니다.
-   **Request Body**: `ReviewRequest.Create`
    ```json
    {
      "planId": 1,
      "rating": 5,
      "content": "정말 유익한 스터디였습니다! 다음에도 참여하고 싶어요."
    }
    ```
-   **Success Response (201 Created)**: `data` 필드에 생성된 후기의 `ID` (Long)가 포함됩니다.

### 2.2. 특정 약속의 모든 후기 조회

-   **Method**: `GET`
-   **URL**: `/api/reviews/plan/{planId}`
-   **설명**: 특정 약속에 달린 모든 후기 목록을 조회합니다.
-   **Path Variable**:
    -   `planId` (Long): 후기를 조회할 약속의 ID
-   **Success Response (200 OK)**: `data` 필드에 `ReviewResponse.DTO` 객체의 배열이 포함됩니다.
    ```json
    [
      {
        "reviewId": 1,
        "memberId": 1,
        "username": "김철수",
        "profileImageUrl": "/path/to/image.jpg",
        "rating": 5,
        "content": "정말 유익한 스터디였습니다! 다음에도 참여하고 싶어요.",
        "createdAt": "2025-11-20T10:00:00"
      }
    ]
    ```

### 2.3. 후기 수정

-   **Method**: `PUT`
-   **URL**: `/api/reviews/{reviewId}`
-   **설명**: 자신이 작성한 후기의 별점과 내용을 수정합니다.
-   **Path Variable**:
    -   `reviewId` (Long): 수정할 후기의 ID
-   **Request Body**: `ReviewRequest.Update`
    ```json
    {
      "rating": 4,
      "content": "조금 아쉬운 점도 있었지만 대체로 만족합니다."
    }
    ```
-   **Success Response (200 OK)**: `data` 필드에 수정된 후기의 `ID` (Long)가 포함됩니다.

### 2.4. 후기 삭제

-   **Method**: `DELETE`
-   **URL**: `/api/reviews/{reviewId}`
-   **설명**: 자신이 작성한 후기를 삭제합니다.
-   **Path Variable**:
    -   `reviewId` (Long): 삭제할 후기의 ID
-   **Success Response (200 OK)**: 성공 메시지를 반환합니다.

---

## 3. 향후 작업 계획 (TODO)

### 3.1. 리뷰 사진 기능 추가

-   **목표:** 사용자가 후기를 작성할 때 여러 장의 사진을 함께 첨부할 수 있도록 합니다.
-   **작업 내용:**
    1.  **엔티티 수정:** `Review.java` 엔티티에 사진 URL 목록을 저장할 필드를 추가합니다.
        ```java
        @ElementCollection
        private List<String> photoUrls = new ArrayList<>();
        ```
    2.  **API 수정:** 후기 작성(`POST /api/reviews`) 및 수정(`PUT /api/reviews/{reviewId}`) API의 `Content-Type`을 `multipart/form-data`로 변경하여, 텍스트 데이터와 함께 이미지 파일들을 받을 수 있도록 수정합니다.
    3.  **서비스 로직 추가:** `ReviewService`에 S3나 로컬 서버에 이미지를 업로드하고, 반환된 URL들을 `photoUrls` 필드에 저장하는 로직을 추가합니다.
    4.  **DTO 수정:** `ReviewResponse.DTO`에 `photoUrls` 필드를 추가하여, 후기 조회 시 첨부된 사진 목록을 함께 반환하도록 합니다.

### 3.2. 리뷰 수정/삭제 권한 검증

-   **목표:** 후기는 작성자 본인만 수정하거나 삭제할 수 있도록 합니다.
-   **작업 내용:**
    -   `ReviewService`의 `updateReview`, `deleteReview` 메서드 초반에, 현재 요청을 보낸 사용자(`@RequestAttribute`의 `memberId`)와 해당 후기의 작성자(`review.getMember().getId()`)가 일치하는지 확인하는 검증 로직을 추가합니다.
    -   일치하지 않을 경우, `Exception403` (Forbidden)을 발생시킵니다.

### 3.3. 입력 데이터 검증 추가

-   **목표:** 유효하지 않은 데이터가 DB에 저장되는 것을 방지합니다.
-   **작업 내용:**
    -   `ReviewRequest` DTO의 필드에 `@NotNull`, `@Size`, `@Min`, `@Max` 등 `jakarta.validation` 어노테이션을 추가합니다.
        -   `rating`: 1 이상 5 이하의 정수여야 함 (`@Min(1) @Max(5)`)
        -   `content`: 비어있지 않아야 하며, 최대 길이를 제한할 수 있음 (`@NotBlank @Size(max=1000)`)
    -   `ReviewController`의 해당 API 메서드에 `@Valid` 어노테이션을 추가하여 검증을 활성화합니다.

### 3.4. 샘플 데이터 추가

-   **목표:** API 구현 후 즉시 테스트할 수 있도록 초기 데이터를 생성합니다.
-   **작업 내용:**
    -   새로운 `DataInitializerXX_Review.java` 파일을 생성합니다.
    -   `run` 메서드 내부에, 완료된 약속(`planId=2` 등)에 대해 여러 사용자가 작성한 몇 개의 `Review` 샘플 데이터를 생성하고 저장하는 코드를 작성합니다.
