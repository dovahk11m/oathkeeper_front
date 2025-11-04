# Terms API Documentation

This document outlines the API specifications for handling terms and conditions.

---

## 1. Get Full List of Terms

This API retrieves the list of all terms and conditions to be displayed on the sign-up page. The client can use this list to render the terms and use the `isRequired` flag to enforce checks on mandatory terms.

-   **HTTP Method**: `GET`
-   **URL**: `/api/terms`
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": [
        {
          "id": 1,
          "title": "Terms of Service",
          "content": "This is the content for the terms of service...",
          "isRequired": true
        },
        {
          "id": 2,
          "title": "Privacy Policy",
          "content": "This is the content for the privacy policy...",
          "isRequired": true
        },
        {
          "id": 5,
          "title": "Marketing Consent (Optional)",
          "content": "You can receive information about various events, benefits, and advertisements via SMS, email, etc.",
          "isRequired": false
        }
      ],
      "message": "Successfully retrieved the list of terms"
    }
    ```

---

## 2. Get Term Details

This API retrieves the full content of a specific term, typically used when a user clicks a "view details" link for a term.

-   **HTTP Method**: `GET`
-   **URL**: `/api/terms/{termId}`
-   **Path Variables**:
    -   `termId` (Long): The ID of the term to retrieve.
-   **Success Response (200 OK)**:
    ```json
    {
      "success": true,
      "data": {
        "id": 1,
        "title": "Terms of Service",
        "content": "This is the content for the terms of service...",
        "isRequired": true
      },
      "message": "Successfully retrieved term details"
    }
    ```
-   **Error Response (404 Not Found)**:
    ```json
    {
        "success": false,
        "error": {
            "message": "The requested term was not found. ID: {termId}",
            "status": 404
        }
    }
    ```

---

## Sign-up Process Integration

1.  The client calls **`GET /api/terms`** to get the full list of terms and displays them on the screen.
2.  The user checks the terms they agree to, including all mandatory ones.
3.  The client collects the **`id`** of all the terms the user agreed to (e.g., `[1, 2, 3, 5]`)
4.  When sending the sign-up request, the client includes the collected list of term IDs in the `agreedTermIds` field.

-   **API**: `POST /api/member/create`
-   **Request Body**:
    ```json
    {
      "username": "John Doe",
      "email": "john.doe@example.com",
      "password": "password123",
      "agreedTermIds": [1, 2, 3, 4, 5]
    }
    ```

The server will then automatically validate if all required terms have been agreed to. If not, it will return a 400 Bad Request error with a message like "You must agree to the [Term Title] terms."
