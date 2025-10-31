# Profile API Documentation

This document outlines the API specifications for member profile management.

---

## 1. 회원 정보 조회 (Get Member Info)

-   **HTTP Method**: `GET`
-   **URL**: `/api/member/{memberId}`
-   **Description**: Retrieves the information of a specific member.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": {
        "id": 1,
        "username": "testuser",
        "email": "test@example.com",
        "profileImageUrl": "/path/to/image.jpg",
        "defaultAddress": "Seoul, Korea"
      },
      "message": "회원 조회 성공"
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

## 2. 회원 정보 수정 (Update Member Info)

-   **HTTP Method**: `PUT`
-   **URL**: `/api/member/{memberId}`
-   **Description**: Updates a member's information (username, profile image URL, default address).
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Request Body**:
    ```json
    {
      "username": "new_username",
      "profileImageUrl": "/new/path/to/image.jpg",
      "defaultAddress": "Busan, Korea"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": {
        "id": 1,
        "username": "new_username",
        "email": "test@example.com",
        "profileImageUrl": "/new/path/to/image.jpg",
        "defaultAddress": "Busan, Korea"
      },
      "message": "회원정보 수정 성공"
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

## 3. 비밀번호 수정 (Update Password)

-   **HTTP Method**: `PATCH`
-   **URL**: `/api/member/{memberId}/password`
-   **Description**: Updates a member's password.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Request Body**:
    ```json
    {
      "currentPassword": "current_password",
      "newPassword": "new_secure_password"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "비밀번호 수정 성공"
    }
    ```
-   **Error Response**:
    -   **400 Bad Request**: If the current password does not match.
        ```json
        {
          "success": false,
          "data": null,
          "message": "현재 비밀번호가 일치하지 않습니다."
        }
        ```
    -   **404 Not Found**: If the member does not exist.
        ```json
        {
          "success": false,
          "data": null,
          "message": "일치하는 회원이 없습니다."
        }
        ```

---

## 4. 회원 탈퇴 (Delete Member)

-   **HTTP Method**: `DELETE`
-   **URL**: `/api/member/{memberId}`
-   **Description**: Deactivates a member's account.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "회원 탈퇴 성공"
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

## 5. 프로필 이미지 업로드 (Upload Profile Image)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/profile/upload/{memberId}`
-   **Description**: Uploads a profile image for the member. The request should be a `multipart/form-data`.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
    -   `Content-Type`: `multipart/form-data`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Form Data**:
    -   `image` (File): The image file to upload.
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": "/path/to/uploaded_image.jpg",
      "message": "성공"
    }
    ```
-   **Error Response**:
    -   **404 Not Found**: If the member does not exist.
    -   **500 Internal Server Error**: If the file upload fails.

---

## 6. 프로필 이미지 삭제 (Delete Profile Image)

-   **HTTP Method**: `DELETE`
-   **URL**: `/api/member/profile/delete/{memberId}`
-   **Description**: Deletes the profile image of a member.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Success Response (200 OK)**:
    -   No content in the response body.
-   **Error Response (404 Not Found)**:
    -   If the member does not exist.

---

## 7. 로그아웃 (Logout)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/logout`
-   **Description**: Logs the user out by invalidating the JWT token.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "로그아웃 성공"
    }
    ```
-   **Error Response (400 Bad Request)**:
    ```json
    {
      "success": false,
      "data": null,
      "message": "유효하지 않은 토큰입니다."
    }
    ```

---

## 8. 비밀번호 확인 (Check Password)

-   **HTTP Method**: `POST`
-   **URL**: `/api/member/{memberId}/check-password`
-   **Description**: Verifies the member's current password before performing sensitive actions.
-   **Headers**:
    -   `Authorization`: `Bearer {jwtToken}`
-   **Path Variables**:
    -   `memberId` (Long): The unique ID of the member.
-   **Request Body**:
    ```json
    {
      "password": "current_password"
    }
    ```
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": null,
      "message": "비밀번호 확인 성공"
    }
    ```
-   **Error Response**:
    -   **401 Unauthorized**: If the password does not match.
        ```json
        {
          "success": false,
          "error": {
            "message": "비밀번호가 일치하지 않습니다.",
            "status": 401
          }
        }
        ```
    -   **404 Not Found**: If the member does not exist.
        ```json
        {
          "success": false,
          "data": null,
          "message": "일치하는 회원이 없습니다."
        }
        ```
