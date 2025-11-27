# Live Map 위젯 분리 작업 가이드

## 생성된 위젯 파일

### 1. `widgets/online_pill.dart`

접속자 수를 표시하는 위젯입니다.

**사용법:**

```dart
OnlinePill(count: _lastSeen.length)
```

### 2. `widgets/status_chip.dart`

상태를 표시하는 칩 위젯입니다. (PR 리뷰 반영: `withOpacity` 사용)

**사용법:**

```dart
StatusChip(
  icon: Icons.visibility,
  label: '공유 중',
  color: Colors.green,
)
```

### 3. `widgets/map_control_panel.dart`

지도 하단 컨트롤 패널 위젯입니다.

**사용법:**

```dart
MapControlPanel(
  shareMyLocation: _shareMyLocation,
  onlineCount: _lastSeen.length,
  mapController: _map,
  onShareChanged: _setShare,
)
```

## live_map_page.dart 수정 방법

### 1. import 추가

파일 상단에 다음 import를 추가하세요:

```dart
import 'widgets/online_pill.dart';
import 'widgets/map_control_panel.dart';
```

### 2. \_onlinePill() 메서드 제거 및 교체

기존 코드 (약 184-197번째 줄):

```dart
Widget _onlinePill() {
  final count = _lastSeen.length;
  return Material(
    // ... 생략
  );
}
```

사용 위치 (약 150번째 줄):

```dart
Positioned(top: 12, left: 12, child: _onlinePill()),
```

**변경 후:**

```dart
Positioned(top: 12, left: 12, child: OnlinePill(count: _lastSeen.length)),
```

### 3. \_bottomPanel() 메서드 제거 및 교체

기존 코드 (약 199-247번째 줄):

```dart
Widget _bottomPanel() {
  return Material(
    // ... 생략
  );
}
```

사용 위치 (약 153번째 줄):

```dart
Positioned(left: 12, right: 12, bottom: 12, child: _bottomPanel()),
```

**변경 후:**

```dart
Positioned(
  left: 12,
  right: 12,
  bottom: 12,
  child: MapControlPanel(
    shareMyLocation: _shareMyLocation,
    onlineCount: _lastSeen.length,
    mapController: _map,
    onShareChanged: _setShare,
  ),
),
```

### 4. \_statusChip() 메서드 제거

`_statusChip` 메서드는 이제 `StatusChip` 위젯으로 대체되었으므로 삭제하세요.
(약 249-263번째 줄)

## 추가 작업: PR 리뷰 반영

`status_chip.dart`에서 이미 `withOpacity`를 사용하도록 수정했습니다.
만약 `live_map_page.dart`에 아직 `withValues`가 남아있다면 `withOpacity`로 수정하세요.

## 예상 효과

- **코드 라인 수 감소**: 약 100줄 이상 감소
- **가독성 향상**: UI 위젯과 비즈니스 로직 분리
- **재사용성**: 다른 곳에서도 위젯 재사용 가능
- **테스트 용이성**: 위젯 단위 테스트 작성 가능
