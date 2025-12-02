# Spring Boot `-parameters` 플래그 이슈: VS Code vs IntelliJ IDEA

**날짜**: 2025-11-28
**카테고리**: Spring Boot, Java, Troubleshooting
**태그**: #SpringBoot #Java #IntelliJ #VSCode #Gradle

---

## 🔴 문제 상황

Flutter 클라이언트에서 Spring Boot 서버 API를 호출했을 때, 특정 API에서 500 에러가 발생했다.

### 에러 메시지

```
java.lang.IllegalArgumentException: Name for argument of type [java.lang.Long] not specified,
and parameter name information not available via reflection.
Ensure that the compiler uses the '-parameters' flag.
```

### 영향받는 API

- `GET /api/member/{memberId}` - 500 에러
- `GET /api/groups/{groupId}/chat/messages` - 500 에러
- 기타 `@PathVariable` 또는 `@RequestParam`을 사용하는 모든 API

---

## 🔍 원인 분석

### Java 컴파일러 `-parameters` 플래그

Java 컴파일러는 기본적으로 **메서드 파라미터 이름 정보를 바이트코드에 포함하지 않는다**.

Spring Framework는 리플렉션을 통해 파라미터 이름을 읽어야 하는데, 이 정보가 없으면 다음과 같은 코드에서 에러가 발생한다:

```java
// 파라미터 이름을 명시하지 않은 경우
@GetMapping("/api/member/{memberId}")
public ResponseEntity<?> getMember(Long memberId) {
    // IllegalArgumentException 발생!
}
```

### 왜 IntelliJ에서는 되고 VS Code에서는 안 될까?

#### ✅ IntelliJ IDEA

- **자동 설정**: IntelliJ는 Spring Boot 프로젝트를 인식하면 자동으로 `-parameters` 플래그를 추가
- **IDE 통합**: Gradle 설정을 IDE가 보완하여 실행
- **Spring Boot 최적화**: Spring Boot에 특화된 기능 제공

#### ❌ VS Code

- **순수 Gradle 실행**: `build.gradle`에 명시된 설정만 사용
- **IDE 최적화 없음**: Spring Boot 전용 자동 설정이 없음
- **명시적 설정 필요**: 모든 설정을 `build.gradle`에 직접 작성해야 함

---

## ✅ 해결 방법

### 방법 1: Gradle에 `-parameters` 플래그 추가 (권장)

`build.gradle` 또는 `build.gradle.kts`에 다음을 추가:

```gradle
tasks.withType(JavaCompile) {
    options.compilerArgs << '-parameters'
}
```

또는 Kotlin DSL:

```kotlin
tasks.withType<JavaCompile> {
    options.compilerArgs.add("-parameters")
}
```

**장점**:

- 모든 IDE/환경에서 동일하게 동작
- 팀원 간 일관성 보장
- CI/CD 환경에서도 정상 동작

**단점**:

- 바이트코드 크기가 약간 증가 (무시할 수준)

### 방법 2: 어노테이션에 명시적으로 이름 지정

```java
// Before (에러 발생)
@GetMapping("/api/member/{memberId}")
public ResponseEntity<?> getMember(Long memberId) { ... }

// After (정상 동작)
@GetMapping("/api/member/{memberId}")
public ResponseEntity<?> getMember(@PathVariable("memberId") Long memberId) { ... }
```

**장점**:

- Gradle 설정 변경 불필요
- 코드만으로 명확한 의도 표현

**단점**:

- 모든 파라미터에 일일이 작성해야 함
- 코드가 장황해짐
- 실수 가능성 증가

---

## 📊 비교표

| 항목                    | IntelliJ IDEA | VS Code            | Gradle CLI     |
| ----------------------- | ------------- | ------------------ | -------------- |
| `-parameters` 자동 추가 | ✅            | ❌                 | ❌             |
| Spring Boot 최적화      | ✅            | ⚠️ (플러그인 필요) | ❌             |
| 명시적 설정 필요        | ❌            | ✅                 | ✅             |
| 팀 협업 일관성          | ⚠️ (IDE 의존) | ✅ (설정 공유)     | ✅ (설정 공유) |

---

## 💡 베스트 프랙티스

### 1. Gradle 설정에 `-parameters` 추가 (필수)

```gradle
tasks.withType(JavaCompile) {
    options.compilerArgs << '-parameters'
}
```

이렇게 하면 **모든 환경에서 일관되게 동작**한다.

### 2. 중요한 파라미터는 명시적으로 이름 지정

```java
@GetMapping("/api/users/{userId}/posts/{postId}")
public ResponseEntity<?> getPost(
    @PathVariable("userId") Long userId,
    @PathVariable("postId") Long postId
) {
    // 명확하고 안전함
}
```

### 3. CI/CD 파이프라인 검증

```bash
# Gradle로 빌드 테스트
./gradlew clean build

# 파라미터 정보 포함 여부 확인
javap -v build/classes/java/main/com/example/Controller.class | grep -A 5 "MethodParameters"
```

---

## 🎓 교훈

1. **IDE에 의존하지 말 것**: IntelliJ에서 되더라도 Gradle 설정을 명시적으로 작성
2. **팀 협업 고려**: 모든 팀원이 같은 환경을 가정하지 말 것
3. **CI/CD 환경 테스트**: 로컬에서만 테스트하지 말고 실제 배포 환경과 동일하게 검증
4. **에러 메시지 주의 깊게 읽기**: "Ensure that the compiler uses the '-parameters' flag" 힌트를 놓치지 말 것

---

## 🔗 참고 자료

- [Spring Framework Reference - Method Parameters](https://docs.spring.io/spring-framework/reference/core/beans/java/configuration-annotations.html)
- [Java Compiler Options](https://docs.oracle.com/en/java/javase/17/docs/specs/man/javac.html)
- [Gradle Java Plugin](https://docs.gradle.org/current/userguide/java_plugin.html)

---

## 📝 요약

- **문제**: Spring Boot에서 `@PathVariable` 사용 시 500 에러
- **원인**: Java 컴파일러 `-parameters` 플래그 누락
- **해결**: `build.gradle`에 `-parameters` 플래그 추가
- **교훈**: IDE 자동 설정에 의존하지 말고 명시적으로 설정할 것

**한 줄 요약**: IntelliJ에서 되더라도 Gradle 설정을 제대로 하자! 🚀

---

## 🛠️ VS Code 사용자를 위한 설정 가이드

VS Code로 Spring Boot 개발을 하려면 다음 설정이 필요하다.

### 1. 필수 확장 프로그램 설치

```
- Extension Pack for Java (Microsoft)
- Spring Boot Extension Pack (VMware)
- Gradle for Java (Microsoft)
```

VS Code에서 `Ctrl+Shift+X` → 위 확장 프로그램 검색 및 설치

### 2. `build.gradle` 설정 추가

프로젝트 루트의 `build.gradle` 파일에 다음을 추가:

```gradle
tasks.withType(JavaCompile) {
    options.compilerArgs << '-parameters'
    options.encoding = 'UTF-8'
}
```

### 3. Gradle Wrapper 사용

VS Code는 Gradle Wrapper를 통해 빌드하므로, 프로젝트에 Gradle Wrapper가 있는지 확인:

```bash
# Windows
gradlew.bat --version

# macOS/Linux
./gradlew --version
```

없다면 생성:

```bash
gradle wrapper --gradle-version 8.5
```

### 4. VS Code 설정 파일 (`.vscode/settings.json`)

프로젝트 루트에 `.vscode/settings.json` 생성:

```json
{
  "java.configuration.updateBuildConfiguration": "automatic",
  "java.compile.nullAnalysis.mode": "automatic",
  "spring-boot.ls.java.home": "${env:JAVA_HOME}",
  "java.jdt.ls.java.home": "${env:JAVA_HOME}"
}
```

### 5. 환경 변수 설정

**Windows (PowerShell)**:

```powershell
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
```

**macOS/Linux (bash/zsh)**:

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
```

### 6. Gradle 빌드 및 실행

**터미널에서 실행** (권장):

```bash
# Windows
.\gradlew bootRun

# macOS/Linux
./gradlew bootRun
```

**VS Code Run/Debug**:

1. `Ctrl+Shift+D` (Run and Debug)
2. "Spring Boot-Application" 선택
3. F5 또는 "Start Debugging"

### 7. 설정 확인

빌드 후 파라미터 정보가 포함되었는지 확인:

```bash
# 빌드
./gradlew clean build

# 클래스 파일 확인
javap -v build/classes/java/main/com/example/demo/controller/ApiController.class | grep -A 5 "MethodParameters"
```

출력 예시:

```
MethodParameters:
  Name                           Flags
  memberId
```

### 8. 문제 해결

#### 문제: "Could not find or load main class"

**해결**:

```bash
./gradlew clean build --refresh-dependencies
```

#### 문제: Gradle 동기화 실패

**해결**:

1. `Ctrl+Shift+P` → "Java: Clean Java Language Server Workspace"
2. VS Code 재시작
3. `./gradlew clean build`

#### 문제: 여전히 500 에러 발생

**해결**:

1. `build.gradle`에 `-parameters` 추가 확인
2. 서버 재시작 (Hot Reload로는 적용 안 됨)
3. `./gradlew clean bootRun`으로 완전히 재빌드

### 9. VS Code vs IntelliJ 비교

| 기능             | VS Code       | IntelliJ IDEA |
| ---------------- | ------------- | ------------- |
| 초기 설정        | 수동 (복잡)   | 자동 (간편)   |
| 메모리 사용량    | 낮음          | 높음          |
| 가격             | 무료          | Ultimate 유료 |
| Spring Boot 지원 | 플러그인 필요 | 기본 내장     |
| 학습 곡선        | 가파름        | 완만함        |
| 커스터마이징     | 높음          | 중간          |

### 10. 추천 워크플로우

**개발 시**:

```bash
# 1. 코드 수정
# 2. 터미널에서 빌드 및 실행
./gradlew bootRun

# 3. 변경사항 테스트
# 4. 필요시 재시작
```

**디버깅 시**:

1. VS Code의 "Spring Boot Dashboard" 사용
2. 브레이크포인트 설정
3. F5로 디버그 모드 실행

---

## 🎯 결론

- **IntelliJ**: 설정이 간편하지만 IDE 의존적
- **VS Code**: 초기 설정은 복잡하지만 명시적이고 팀 협업에 유리
- **권장**: `build.gradle`에 `-parameters` 추가하여 **모든 환경에서 동일하게 동작**하도록 설정

**VS Code로 Spring Boot 개발하는 것은 충분히 가능하며, 올바른 설정만 하면 IntelliJ만큼 강력하다!** 💪

---

## ⚠️ 실제 테스트 결과 (2025-11-28)

### 테스트 환경

- **서버**: Spring Boot 3.x, Gradle 8.x
- **클라이언트**: Flutter 3.35.6
- **설정**: `build.gradle`에 `-parameters` 플래그 추가 완료

### 테스트 과정

1. **`build.gradle` 수정**:

   ```gradle
   tasks.withType(JavaCompile) {
       options.compilerArgs << '-parameters'
   }
   ```

2. **완전 재빌드 실행**:

   ```bash
   ./gradlew clean build --rerun-tasks
   ./gradlew bootRun
   ```

3. **테스트 결과**:
   - ❌ **VS Code로 실행**: `GET /api/member/1` → 500 에러
   - ❌ **VS Code로 실행**: `GET /api/groups/1/chat/messages` → 500 에러
   - ✅ **IntelliJ로 실행**: 모든 API 정상 동작 (200 OK)

### 발견된 문제

**`-parameters` 플래그를 추가하고 완전히 재빌드했음에도 VS Code 환경에서는 여전히 500 에러가 발생했다.**

에러 메시지:

```
java.lang.IllegalArgumentException: Name for argument of type [java.lang.Long] not specified,
and parameter name information not available via reflection.
```

### 가능한 원인

1. **VS Code Java Extension의 자체 컴파일**: VS Code의 Java Extension이 Gradle 설정을 무시하고 자체 컴파일러 사용
2. **Gradle 통합 문제**: VS Code의 Gradle 통합이 IntelliJ만큼 완전하지 않음
3. **캐시 문제**: `--rerun-tasks`를 사용했음에도 이전 빌드 캐시가 남아있을 가능성

### 최종 권장사항

> **🎯 Spring Boot 개발은 IntelliJ IDEA를 사용하는 것을 강력히 권장한다.**

**이유**:

1. IntelliJ는 Spring Boot에 최적화되어 있어 자동으로 필요한 설정을 처리
2. VS Code는 설정을 올바르게 해도 예상치 못한 문제가 발생할 수 있음
3. 개발 생산성과 안정성 측면에서 IntelliJ가 압도적으로 우수

**대안**:

- **서버**: IntelliJ IDEA로 개발 및 실행
- **클라이언트**: VS Code로 Flutter 개발
- 이렇게 하면 각 도구의 장점을 최대한 활용 가능

### 교훈

**"이론적으로 가능하다"와 "실제로 잘 동작한다"는 다르다.**

VS Code로 Spring Boot를 개발하는 것은 *가능*하지만, 실무에서는 IntelliJ를 사용하는 것이 훨씬 안정적이고 생산적이다. 도구 선택은 단순히 기능 지원 여부가 아니라, **실제 개발 경험과 안정성**을 기준으로 해야 한다.
