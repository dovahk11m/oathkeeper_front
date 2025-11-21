# 에러 처리 명세

## 1. 개요

- 모든 API의 에러 응답은 아래와 같은 `CommonResponse` 형식으로 통일됩니다.
- HTTP 상태 코드는 에러의 종류에 따라 달라집니다.

## 2. 에러 응답 형식

```json
{
  "success": false,
  "data": null,
  "message": "에러 메시지"
}
```

- **success**: 항상 `false` 입니다.
- **data**: 항상 `null` 입니다.
- **message**: 에러에 대한 상세 메시지가 포함됩니다.

## 3. HTTP 상태 코드 및 예외 종류

| HTTP 상태 코드 | 예외 클래스         | 설명                                                                 |
| :------------- | :------------------ | :------------------------------------------------------------------- |
| 400            | `Exception400`      | 잘못된 요청 (Bad Request) - 요청 파라미터가 잘못되었거나 형식이 맞지 않을 경우 발생합니다. |
| 401            | `Exception401`      | 인증 실패 (Unauthorized) - 인증되지 않은 사용자의 요청일 경우 발생합니다.         |
| 403            | `Exception403`      | 인가 실패 (Forbidden) - 해당 리소스에 접근할 권한이 없는 경우 발생합니다.       |
| 404            | `Exception404`      | 리소스 없음 (Not Found) - 요청한 리소스가 존재하지 않을 경우 발생합니다.         |
| 409            | `Exception409`      | 충돌 (Conflict) - 리소스의 현재 상태와 충돌하는 요청일 경우 발생합니다. (예: 중복된 데이터) |
| 500            | `Exception500`      | 서버 내부 오류 (Internal Server Error) - 서버 로직 처리 중 에러가 발생한 경우입니다. |
| 500            | `RuntimeException`  | 예상치 못한 런타임 에러 발생 시 "시스템 오류가 발생했습니다. 관리자에게 문의해주세요." 메시지를 반환합니다. |

## 4. 예시

### 400 Bad Request 예시

**요청**
```
GET /api/some-resource?invalid_param=true
```

**응답 (HTTP Status: 400)**
```json
{
  "success": false,
  "data": null,
  "message": "잘못된 파라미터입니다."
}
```

### 404 Not Found 예시

**요청**
```
GET /api/non-existent-resource/123
```

**응답 (HTTP Status: 404)**
```json
{
  "success": false,
  "data": null,
  "message": "ID 123에 해당하는 리소스를 찾을 수 없습니다."
}
```
