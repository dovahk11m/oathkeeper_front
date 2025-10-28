# 로그인 API 명세서 (Login API Specification)

`MemberController`에 구현된 로그인 관련 API의 최신 명세입니다.

---

## **1. 공통 정보 (General Information)**

### **1.1. 인증 헤더 (Authentication Header)**

- 로그인 성공 시 발급받는 JWT(JSON Web Token)는 이후 모든 API 요청 시 HTTP 헤더에 포함해야 합니다.
- **헤더 형식**: `Authorization: Bearer <your_jwt_token>`

### **1.2. JWT (JSON Web Token) 내용**

- 토큰에는 사용자를 식별하기 위한 `sub` (email), 권한 검사를 위한 `role`, 그리고 사용자 식별자인 `memberId`가 포함되어 있습니다.

### **1.3. 표준 응답 형식 (Standard Response Format)**

- 본 명세서에 기술된 로그인 API를 **제외한** 대부분의 API는 아래와 같은 `CommonResponse` 형식으로 데이터를 반환합니다.

```json
{
  "success": true,
  "data": { ... },
  "message": "요청에 성공했습니다."
}
```

---

## **2. 인증 엔드포인트 (Authentication Endpoints)**

### **2.1. 일반 로그인 (Email & Password)**

- **Method**: `POST`
- **URL**: `/api/member/login`
- **Headers**:
    - `Content-Type`: `application/json`
- **Request Body**:

    ```json
    {
      "email": "user@example.com",
      "password": "password123"
    }
    ```

- **Success Response (200 OK)**:
    - *Note: 이 API는 `MemberResponse.Login` DTO를 직접 반환합니다. (`CommonResponse`로 감싸지 않음)*

    ```json
    {
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyQGV4YW1wbGUuY29tIiwicm9sZSI6IlVTRVIiLCJtZW1iZXJJZCI6MSwiZXhwIjoxNzE1ODQzMjAwfQ.xyz...",
      "member": {
        "id": 1,
        "username": "user1",
        "email": "user@example.com",
        "role": "USER",
        "status": "ACTIVE"
      }
    }
    ```

  | 필드명 | 타입 | 설명 |
      | --- | --- | --- |
  | `token` | String | API 인증에 사용할 JWT |
  | `member` | Object | 로그인한 사용자의 상세 정보 객체 |
  | `member.id` | Long | 사용자 고유 식별자 |
  | `member.username` | String | 사용자 이름 |
  | `member.email` | String | 사용자 이메일 |
  | `member.role` | String | 사용자 권한 (`USER`, `ADMIN` 등) |
  | `member.status` | String | 계정 상태 (`ACTIVE`, `INACTIVE` 등) |

- **Error Response**:
    - **4xx**: 이메일이 존재하지 않거나, 비밀번호가 일치하지 않거나, 비활성화된 계정일 경우

---

### **2.2. 소셜 로그인 (Kakao, Facebook)**

클라이언트가 각 소셜 플랫폼 SDK로부터 받은 **인가 코드(Authorization Code)**를 서버로 보내 로그인합니다.

#### **A. 카카오 로그인 (Kakao Login)**

- **Method**: `POST`
- **URL**: `/api/member/kakao/doLogin`
- **Request Body**:
    ```json
    {
      "code": "<kakao_sdk_로부터_받은_인가_코드>"
    }
    ```

#### **B. 페이스북 로그인 (Facebook Login)**

- **Method**: `POST`
- **URL**: `/api/member/facebook/doLogin`
- **Request Body**:
    ```json
    {
      "code": "<facebook_sdk_로부터_받은_인가_코드>"
    }
    ```

- **Success Response (200 OK) for Social Logins**:
    - *Note: 소셜 로그인 API 또한 `MemberResponse.Login` DTO를 직접 반환합니다.*
    - 응답 형식은 **2.1. 일반 로그인**의 성공 응답 형식과 동일합니다.

- **Error Response for Social Logins**:
    - **4xx/5xx**: 인가 코드가 유효하지 않거나, 각 소셜 플랫폼 서버와 통신 중 오류가 발생한 경우
