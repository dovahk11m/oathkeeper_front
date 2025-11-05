# Auth API Documentation

This document outlines the API specifications for member authentication.

---

## 1. 회원 생성 (Create Member)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/create`
-   **Description**: Creates a new member account. Requires agreement to all mandatory terms.
-   **Request Body**:
    ```json
    {
      "username": "testuser",
      "email": "test@example.com",
      "password": "password123",
      "agreedTermIds": [1, 2, 3, 4, 5]
    }
    ```
-   **Success Response (201 Created)**:
    ```json
    {
        "success": true,
        "data": 1,
        "message": "회원가입 성공"
    }
    ```
-   **Error Response**:
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

## 2. 일반 로그인 (Login)

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
                "defaultAddress": null,
                "role": "USER",
                "status": "ACTIVE"
            }
        },
        "message": "로그인 성공"
    }
    ```
-   **Error Response**:
    -   **400 Bad Request**: If email or password does not match.

---

## 3. 아이디 찾기 (Find ID)

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

## 4. 비밀번호 찾기 (Find Password)

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

## 5. 카카오 로그인 (Kakao Login)

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

## 6. 페이스북 로그인 (Facebook Login)

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
