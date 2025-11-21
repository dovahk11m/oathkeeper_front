# 회원 및 약관 API 명세서

- **최종 수정 일자:** 2025-11-20

이 문서는 회원 가입, 인증, 프로필 관리, 약관 조회를 포함한 모든 회원 관련 API 명세를 종합적으로 제공합니다.

---

## 0. 약관 (Terms)

회원가입을 진행하기 전에, 클라이언트는 반드시 약관 목록을 사용자에게 제시하고 동의를 받아야 합니다.

### 0.1. 전체 약관 목록 조회

- **Method**: `GET`
- **URL**: `/api/terms`
- **설명**: 회원가입 화면에 표시할 모든 약관의 목록을 조회합니다. 클라이언트는 `isRequired` 필드를 확인하여 필수 동의 항목을 처리해야 합니다.
- **Success Response (200 OK)**: `data` 필드에 약관 객체의 배열이 포함됩니다.
  ```json
  [
    {
      "id": 1,
      "title": "서비스 이용약관",
      "content": "서비스 이용약관 내용입니다...",
      "isRequired": true
    },
    {
      "id": 2,
      "title": "개인정보 처리방침",
      "content": "개인정보 처리방침 내용입니다...",
      "isRequired": true
    },
    {
      "id": 5,
      "title": "마케팅 정보 수신 동의 (선택)",
      "content": "마케팅 정보 수신 동의 내용입니다...",
      "isRequired": false
    }
  ]
  ```

### 0.2. 약관 상세 조회

- **Method**: `GET`
- **URL**: `/api/terms/{termId}`
- **설명**: 특정 약관의 전체 내용을 조회합니다. (예: 사용자가 '자세히 보기'를 클릭했을 때)
- **Success Response (200 OK)**: `data` 필드에 단일 약관 객체가 포함됩니다.
- **Error**: 404 Not Found (해당 ID의 약관이 없을 경우)

---

## 1. 인증 (Authentication)

### 1.1. 회원가입

- **Method**: `POST`
- **URL**: `/api/member/create`
- **설명**: 사용자가 동의한 약관 ID 목록을 포함하여 새로운 회원 계정을 생성하고, 인증 이메일을 발송합니다.
- **Request Body**: `MemberCreateDto`
  ```json
  {
    "username": "테스트유저",
    "email": "test@example.com",
    "password": "password123",
    "agreedTermIds": [1, 2, 5]
  }
  ```
- **Success Response (201 Created)**: `data` 필드에 생성된 `memberId`가 포함됩니다.
- **Error**: 409 Conflict (이미 사용 중인 이메일), 400 Bad Request (필수 약관 미동의)

### 1.2. 이메일 인증

- **Method**: `GET`
- **URL**: `/api/member/verify`
- **설명**: 이메일 링크의 토큰을 사용하여 계정을 `ACTIVE` 상태로 활성화합니다.
- **Query Parameters**: `token` (String, required)
- **Success Response (200 OK)**: 인증 완료 안내 HTML 페이지를 반환합니다.
- **Error**: 404 Not Found (유효하지 않은 토큰), 400 Bad Request (만료된 토큰)

### 1.3. 일반 로그인

- **Method**: `POST`
- **URL**: `/api/member/login`
- **설명**: 이메일과 비밀번호로 로그인하고 JWT를 발급받습니다.
- **Request Body**: `MemberLoginDto`
  ```json
  {
    "email": "user1@test.com",
    "password": "1234"
  }
  ```
- **Success Response (200 OK)**: `data` 필드에 `MemberResponse.Login` 객체가 포함됩니다.
  ```json
  {
    "token": "jwt.token.string",
    "member": {
      "id": 1,
      "username": "김철수",
      "email": "user1@test.com",
      "role": "USER",
      "status": "ACTIVE",
      "profileImageUrl": null,
      "socialType": "LOCAL",
      "isPremium": false
    }
  }
  ```
- **Error (401 Unauthorized)**: 이메일/비밀번호 불일치, 미인증, 휴면, 정지 계정

### 1.4. 로그아웃

- **Method**: `POST`
- **URL**: `/api/member/logout`
- **설명**: 현재 JWT 토큰을 블랙리스트에 추가하여 세션을 무효화합니다.
- **Headers**: `Authorization: Bearer {jwtToken}`
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.

---

## 2. 소셜 로그인 (Social Login)

### 2.1. 카카오 로그인

- **Method**: `POST`
- **URL**: `/api/member/kakao/token`
- **설명**: 모바일 SDK에서 발급받은 카카오 액세스 토큰으로 로그인 또는 회원가입을 처리합니다.
- **Request Body**: `AccessTokenDto`
  ```json
  {
    "access_token": "kakao_access_token_from_client_sdk"
  }
  ```
- **Success Response (200 OK)**: 일반 로그인과 동일한 형식의 `MemberResponse.Login` 객체를 반환합니다.

### 2.2. 페이스북 로그인

- **Method**: `POST`
- **URL**: `/api/member/facebook/doLogin`
- **설명**: 모바일 SDK에서 발급받은 페이스북 액세스 토큰으로 로그인 또는 회원가입을 처리합니다.
- **Request Body**: `AccessTokenDto`
  ```json
  {
    "access_token": "facebook_access_token_from_client_sdk"
  }
  ```
- **Success Response (200 OK)**: 일반 로그인과 동일한 형식의 `MemberResponse.Login` 객체를 반환합니다.

---

## 3. 프로필 관리 (Profile Management)

### 3.1. 회원 정보 조회

- **Method**: `GET`
- **URL**: `/api/member/{memberId}`
- **설명**: 특정 회원의 프로필 정보를 조회합니다.
- **Success Response (200 OK)**: `data` 필드에 `MemberResponse.DTO` 객체가 포함됩니다.
  ```json
  {
    "id": 1,
    "username": "김철수",
    "email": "user1@test.com",
    "profileImageUrl": "/path/to/image.jpg"
  }
  ```

### 3.2. 회원 정보 수정

- **Method**: `PUT`
- **URL**: `/api/member/{memberId}`
- **설명**: 회원의 이름, 프로필 이미지, 기본 주소 등을 수정합니다.
- **Request Body**: `MemberRequest.Update`
  ```json
  {
    "username": "김오스",
    "profileImageUrl": "/new/image.jpg",
    "defaultAddress": "부산광역시 해운대구"
  }
  ```
- **Success Response (200 OK)**: `data` 필드에 수정된 `MemberResponse.DTO` 객체가 포함됩니다. (조회 응답과 형식 동일)

### 3.3. 비밀번호 수정

- **Method**: `PATCH`
- **URL**: `/api/member/{memberId}/password`
- **설명**: 현재 비밀번호를 확인한 후, 회원의 비밀번호를 변경합니다.
- **Request Body**: `MemberRequest.PasswordUpdate`
  ```json
  {
    "currentPassword": "1234",
    "newPassword": "new_password_1234"
  }
  ```
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.

### 3.4. 비밀번호 확인

- **Method**: `POST`
- **URL**: `/api/member/{memberId}/check-password`
- **설명**: 민감한 정보 변경 전, 사용자의 현재 비밀번호가 일치하는지 확인합니다.
- **Request Body**: `MemberRequest.CheckPassword`
  ```json
  {
    "password": "1234"
  }
  ```
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.
- **Error (401 Unauthorized)**: "비밀번호가 일치하지 않습니다."

### 3.5. 프로필 이미지 업로드

- **Method**: `POST`
- **URL**: `/api/member/profile/upload/{memberId}`
- **설명**: 회원의 프로필 이미지를 업로드합니다. (`multipart/form-data`)
- **Form Data**: `image` (File)
- **Success Response (200 OK)**: `data` 필드에 업로드된 이미지의 URL (String)이 포함됩니다.

### 3.6. 프로필 이미지 삭제

- **Method**: `DELETE`
- **URL**: `/api/member/profile/delete/{memberId}`
- **설명**: 회원의 프로필 이미지를 삭제합니다.
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.

### 3.7. 회원 탈퇴

- **Method**: `DELETE`
- **URL**: `/api/member/{memberId}`
- **설명**: 회원 계정을 비활성화 상태로 변경합니다.
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.

---

## 4. 계정 복구 (Account Recovery)

### 4.1. 아이디 찾기

- **Method**: `POST`
- **URL**: `/api/member/find-id`
- **Request Body**: `MemberRequest.FindId` (`email` 필드 포함)
- **Success Response (200 OK)**: `data` 필드에 사용자의 아이디(username)가 포함됩니다.

### 4.2. 비밀번호 찾기

- **Method**: `POST`
- **URL**: `/api/member/find-password`
- **설명**: 등록된 이메일로 임시 비밀번호를 발송합니다.
- **Request Body**: `MemberRequest.FindPassword` (`email` 필드 포함)
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.

---

## 5. 관리자 기능 (Admin Functions)

### 5.1. 총 회원 수 조회

- **Method**: `GET`
- **URL**: `/api/member/count-join`
- **설명**: 현재까지 가입된 총 회원 수를 조회합니다. (관리자 전용)
- **Headers**: `Authorization: Bearer {adminJwtToken}`
- **Success Response (200 OK)**: 성공 메시지를 반환합니다.
- **Error (403 Forbidden)**: 관리자 권한이 없는 경우.
