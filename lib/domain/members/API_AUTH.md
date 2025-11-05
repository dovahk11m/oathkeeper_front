# Auth API Documentation

This document outlines the API specifications for member authentication.

---

## 1. 회원 생성 (Create Member)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/create`
-   **Description**: Creates a new member account with an `INACTIVE` status and sends a verification email.
-   **Request Body**:
    ```json
    {
      "username": "testuser",
      "email": "test@example.com",
      "password": "password123",
      "agreedTermIds": [1, 2, 3, 4]
    }
    ```
-   **Success Response (201 Created)**:
    ```json
    {
        "success": true,
        "data": 1,
        "message": "회원가입 성공. 이메일 인증을 완료해주세요."
    }
    ```
-   **Error Responses**:
    -   **409 Conflict**: If the email already exists.
        ```json
        {
            "success": false,
            "data": null,
            "message": "이미 사용 중인 이메일입니다."
        }
        ```
    -   **400 Bad Request**: If a mandatory term has not been agreed to.
        ```json
        {
            "success": false,
            "data": null,
            "message": "[필수 약관 제목] 약관에 동의해야 합니다."
        }
        ```

---

## 2. 이메일 인증 (Verify Email)

-   **HTTP Method**: `GET`
-   **URL**: `/api/member/verify`
-   **Description**: Verifies a member's email using the token sent during registration. Activates the member's account.
-   **Query Parameters**:
    -   `token` (String): The verification token from the email link.
-   **Success Response (200 OK)**:
    ```json
    {
        "success": true,
        "data": null,
        "message": "이메일 인증이 성공적으로 완료되었습니다."
    }
    ```
-   **Error Responses**:
    -   **404 Not Found**: If the token is invalid.
        ```json
        {
            "success": false,
            "data": null,
            "message": "유효하지 않은 인증 토큰입니다."
        }
        ```
    -   **400 Bad Request**: If the token has expired.
        ```json
        {
            "success": false,
            "data": null,
            "message": "인증 토큰이 만료되었습니다. 다시 가입해주세요."
        }
        ```

---

## 3. 일반 로그인 (Login)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/login`
-   **Description**: Logs in a member with email and password.
-   **Request Body**:
    ```json
    {
      "email": "test@example.com",
      "password": "password123"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
        "success": true,
        "data": {
            "token": "jwt.token.string",
            "member": {
                "id": 1,
                "username": "testuser",
                "email": "test@example.com",
                "profileImageUrl": null,
                "role": "USER",
                "status": "ACTIVE"
            }
        },
        "message": "로그인 성공"
    }
    ```
-   **Error Responses (400 Bad Request)**:
    -   If email or password does not match:
        ```json
        {
            "success": false,
            "data": null,
            "message": "email이 존재하지 않습니다." 
        }
        ```
        ```json
        {
            "success": false,
            "data": null,
            "message": "password가 일치하지 않습니다."
        }
        ```
    -   If the account is not verified:
        ```json
        {
            "success": false,
            "data": null,
            "message": "이메일 인증이 완료되지 않은 계정입니다. 이메일을 확인해주세요."
        }
        ```

---

## 4. 아이디 찾기 (Find ID)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/find-id`
-   **Description**: Finds a member's username using their email.
-   **Request Body**:
    ```json
    {
      "email": "test@example.com"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": "testuser",
      "message": "아이디 찾기 성공"
    }
    ```
-   **Error Response (404 Not Found)**:
    ```json
    {
      "success": false,
      "data": null,
      "message": "일치하는 회원이 없습니다."
    }
    ```

---

## 5. 비밀번호 찾기 (Find Password)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/find-password`
-   **Description**: Sends a temporary password to the member's email.
-   **Request Body**:
    ```json
    {
      "email": "test@example.com"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "비밀번호 찾기용 메일 보내기 성공"
    }
    ```
-   **Error Response (404 Not Found)**:
    ```json
    {
      "success": false,
      "data": null,
      "message": "일치하는 회원이 없습니다."
    }
    ```

---

## 6. 카카오 로그인 (Kakao Login)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/kakao/doLogin`
-   **Description**: Logs in or signs up a member using a Kakao authorization code.
-   **Request Body**:
    ```json
    {
      "code": "kakao_authorization_code"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
        "success": true,
        "data": {
            "token": "jwt.token.string",
            "member": {
                "id": 2,
                "username": "kakao_nickname",
                "email": "kakao_email@example.com",
                "socialType": "KAKAO",
                "role": "USER",
                "status": "ACTIVE"
            }
        },
        "message": "카카오 로그인 성공"
    }
    ```
-   **Error Response**:
    -   If the Kakao authorization code is invalid.

---

## 7. 페이스북 로그인 (Facebook Login)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/facebook/doLogin`
-   **Description**: Logs in or signs up a member using a Facebook authorization code.
-   **Request Body**:
    ```json
    {
      "code": "facebook_authorization_code"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
        "success": true,
        "data": {
            "token": "jwt.token.string",
            "member": {
                "id": 3,
                "username": "facebook_name",
                "email": "facebook_email@example.com",
                "socialType": "FACEBOOK",
                "role": "USER",
                "status": "ACTIVE"
            }
        },
        "message": "페이스북 로그인 성공"
    }
    ```
-   **Error Response**:
    -   If the Facebook authorization code is invalid.
