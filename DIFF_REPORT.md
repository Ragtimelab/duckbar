# DuckBar 포크 비교 분석 보고서

> 원본: `rofeels/duckbar` (upstream/main)
> 포크: `ragtimelab/duckbar` (HEAD)
> 분석일: 2026-03-19

---

## 요약

- **변경 파일**: 9개
- **라인**: +385 / -95 (순증가 +290)
- **커밋**: 5개

---

## 커밋 히스토리

```
2b29f57 feat: 글로벌 핫키(F19) 및 설정 UI 추가
2d20db2 fix: Carbon API(HotKey)로 교체 및 한글 IME 키 표시 수정
0edb5ea refactor: finishRecording 중복 .function 플래그 제거
6e5f086 refactor: 코드 품질 근본 개선 5건
37bacd9 fix: 차트 토글 NSPopover 리사이즈 수정 및 README 포크 반영
```

---

## 1. 새 기능

### 글로벌 핫키

- F19(기본) 또는 사용자 지정 키로 팝오버 토글
- Carbon API 기반 HotKey 라이브러리 사용
- 설정에서 키 입력으로 핫키 변경 (Barbee 스타일 레코더)
- UCKeyTranslate 기반 키 이름 표시, 한글 IME 환경 대응

---

## 2. 버그 수정

### 글로벌 핫키 미작동

- **원인**: `NSEvent.addGlobalMonitorForEvents`가 F키를 안정적으로 캡처 못함
- **해결**: Carbon `RegisterEventHotKey` (HotKey 라이브러리)로 교체

### 한글 IME에서 키 이름 "Key XX" 표시

- **원인**: `TISCopyCurrentKeyboardInputSource()`가 한글 IME에서 레이아웃 데이터 미제공
- **해결**: `TISCopyCurrentASCIICapableKeyboardLayoutInputSource()`로 교체

### Fn 플래그 불일치

- **원인**: F키 녹음 시 `.function` 플래그가 저장되어 매칭 실패
- **해결**: `setupHotkey()`에서 `.subtracting(.function)` 적용

### 차트 토글 시 위/아래 UI 모두 이동

- **원인**: SwiftUI `withAnimation`이 NSPopover 프레임 리사이즈와 충돌
- **해결**: `withAnimation` 제거, `frame(height:) + clipped()` 방식으로 전환

---

## 3. 코드 품질 개선

### Notification 이름 타입 안전화

- 7개 이름을 `Notification.Name` static 상수로 정의
- 3개 파일, 18회 교체
- 오타 시 silent failure → 컴파일 타임 검증

### 로컬라이제이션 SSOT

- `L.lang == .korean ? "..." : "..."` 인라인 패턴 14회 제거
- `L` enum에 중앙화

### SegmentButton 재사용 컴포넌트

- Language / PopoverSize / RefreshInterval 선택 UI 3벌 중복 → 제네릭 `SegmentButton<T>` 통합

### 이미지 캐싱

- `makeDuckFeetImage()` 0.35초마다 재생성 → `ImageCacheKey` 기반 캐시
- 최대 ~7종, 다크모드 전환 시 클리어

### Dead code 제거

- `resizePopover()` 빈 메서드 + observer + notification post 3건

---

## 4. 인프라 변경

- **Package.swift**: HotKey 0.2.1 의존성 추가
- **build.sh**: `uname -m` 기반 아키텍처 자동 감지 (arm64/x86_64)
- **README.md**: Intel 지원 명시, git clone URL 포크로 변경, HotKey 의존성 추가

---

## 5. 의존성

| 패키지 | 버전 | 상태 | 용도 |
|--------|------|------|------|
| Sparkle | 2.9.0 | 유지 | 자동 업데이트 |
| HotKey | 0.2.1 | 신규 | 글로벌 핫키 |

---

## 6. 원본 병합 가능성

**평가: 매우 높음** — upstream/main은 HEAD의 선조이므로 fast-forward 가능.

```bash
git fetch upstream
git merge upstream/main
```

### 파일별 충돌 위험도

| 파일 | 위험도 |
|------|--------|
| AppDelegate.swift | 낮음 |
| SettingsView.swift | 낮음 |
| Localization.swift | 매우 낮음 |
| AppSettings.swift | 중간 |
| StatusMenuView.swift | 낮음 |
| build.sh | 낮음 |

### 주의 사항

- AppDelegate 메뉴 항목/리사이징 로직 변경 시 충돌 가능
- Package.swift Sparkle 버전 업그레이드 시 resolve 재실행 필요
- 원본이 자체 핫키 기능을 추가하면 중복 발생 가능

---

## 7. 최종 평가

| 항목 | 평가 |
|------|------|
| 코드 품질 | 개선됨 |
| 아키텍처 | 진화됨 |
| 병합 가능성 | 매우 높음 |
| 유지보수성 | 향상됨 |
| 리스크 | 낮음 |
