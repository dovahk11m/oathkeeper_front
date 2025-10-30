# 인증(Authentication) 도메인

이 디렉토리는 사용자 인증과 관련된 모든 상태 관리, 비즈니스 로직, 데이터 모델을 포함합니다.

`Riverpod`를 사용한 상태 관리와 `freezed`를 사용한 불변(immutable) 데이터 클래스 생성을 핵심으로 합니다.

---

## 파일 설명

### `auth_provider.dart`

- **역할**: **창고 관리자 (Notifier) & 비즈니스 로직 담당**
- `AuthNotifier` 클래스가 정의된 핵심 파일입니다.
- 로그인, 로그아웃, 자동 로그인, 토큰 재발급 등 인증과 관련된 모든 비즈니스 로직을 처리합니다.
- `Dio`를 사용하여 서버와 통신하고, `FlutterSecureStorage`를 통해 토큰을 안전하게 관리합니다.
- 최종적으로 UI 상태인 `AuthState`를 업데이트하여 화면의 변경을 유도합니다.
- `authProvider`, `isLoggedInProvider` 등 UI에서 사용할 Provider들을 외부에 제공합니다.

### `auth_state.dart`

- **역할**: **창고 데이터 (State)**
- `AuthNotifier`가 관리하는 UI 상태를 정의하는 데이터 클래스입니다.
- `freezed` 패키지를 사용하여 생성되었습니다.
- `auth` (로그인된 사용자 정보), `isLoading` (로딩 상태), `error` (에러 메시지) 필드를 포함합니다.

### `auth.dart`

- **역할**: **데이터 모델 (DTO - Data Transfer Object)**
- 서버와 통신할 때, API 응답의 `data` 필드를 파싱하기 위한 데이터 모델입니다.
- 로그인 성공 시 받아오는 사용자 정보(`id`, `username`, `email` 등)의 구조를 정의합니다.
- `freezed`와 `json_serializable`을 사용하여 `fromJson`, `toJson`, `copyWith` 등의 메소드가 자동으로 생성됩니다.

### `auth_enum.dart`

- **역할**: **열거형(Enum) 정의**
- 인증 도메인 내에서 사용되는 `Role`, `Status`, `SocialType` 등의 열거형을 정의합니다.

### `*.freezed.dart` 및 `*.g.dart` 파일

- **역할**: **자동 생성 파일**
- `freezed`와 `json_serializable` 라이브러리가 `build_runner`를 통해 자동으로 생성하는 파일들입니다.
- **절대로 직접 수정해서는 안 됩니다.**
- 원본 파일(`auth.dart`, `auth_state.dart`)이 변경된 후에는 항상 아래 명령어를 실행하여 이 파일들을 다시 생성하거나 업데이트해야 합니다.
  ```shell
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
