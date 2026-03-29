# TikTok Clone

Flutter를 사용하여 구현한 TikTok 스타일 숏폼 영상 피드 앱입니다.

## 실행 방법

```bash
# 1. 패키지 설치
flutter pub get

# 2. Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 3. 앱 실행
flutter run
```

- Flutter SDK: 3.11.0 이상
- 테스트 환경: iOS Simulator / Android Emulator

## 사용한 패키지

| 패키지 | 버전 | 용도 |
|--------|------|------|
| `video_player` | ^2.9.2 | 비디오 재생 |
| `flutter_riverpod` | ^2.6.1 | 상태 관리 |
| `riverpod_annotation` | ^2.6.1 | Riverpod 코드 생성 어노테이션 |
| `riverpod_generator` | ^2.6.3 | Riverpod 코드 자동 생성 (dev) |
| `build_runner` | ^2.4.14 | 빌드 러너 (dev) |

## 프로젝트 구조

Clean Architecture 기반 feature-first 구조입니다.

```
lib/
├── main.dart                          # 앱 진입점 (ProviderScope, 테마)
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Mock 데이터, 앱 상수
│   ├── theme/
│   │   └── app_theme.dart             # 다크 테마, 색상 정의
│   └── widgets/
│       └── like_animation_overlay.dart # 좋아요 애니메이션 위젯
└── features/
    └── video_feed/
        ├── data/                      # 데이터 레이어
        │   ├── datasources/
        │   │   └── video_local_datasource.dart  # Mock 데이터 소스
        │   ├── models/
        │   │   └── video_model.dart             # 데이터 모델 (JSON 변환)
        │   ├── repositories/
        │   │   └── video_repository_impl.dart   # Repository 구현체
        │   └── providers/
        │       └── video_data_provider.dart      # 데이터 레이어 Provider
        ├── domain/                    # 도메인 레이어
        │   ├── entities/
        │   │   └── video_entity.dart            # 도메인 엔티티
        │   ├── repositories/
        │   │   └── video_repository.dart         # Repository 인터페이스
        │   ├── usecases/
        │   │   └── get_videos_usecase.dart       # UseCase
        │   └── providers/
        │       └── video_domain_provider.dart    # 도메인 레이어 Provider
        └── presentation/             # 프레젠테이션 레이어
            ├── providers/
            │   └── video_feed_provider.dart      # 피드 상태 관리 (AsyncNotifier)
            ├── screens/
            │   └── video_feed_screen.dart        # 메인 피드 화면
            └── widgets/
                ├── video_player_widget.dart      # 비디오 플레이어
                ├── video_overlay_ui.dart         # 오버레이 UI 조합
                ├── action_button.dart            # 액션 버튼 (좋아요/댓글/공유)
                └── video_description.dart        # 유저명/캡션 표시
```

## 구현 기능 목록

### 필수 기능
- **Vertical Video Feed**: PageView 기반 세로 스와이프, 현재 영상 자동 재생, 이전 영상 자동 정지
- **Video Player**: video_player 패키지 활용, 자동 재생/일시정지/루프 재생, 버퍼링 인디케이터
- **Overlay UI**: 오른쪽 액션 버튼 (좋아요/댓글/공유), 하단 유저명/캡션, 하단 그라데이션

### 가산점 기능
- **Like Toggle**: 좋아요 버튼 토글 (하트 아이콘 색상 변경 + 카운트 반영)
- **Double Tap Like**: 더블탭 시 화면 중앙에 하트 애니메이션 표시
- **Infinite Scroll**: 마지막 영상 근처(2개 전)에서 자동으로 추가 데이터 로드
- **상태 관리**: Riverpod (AsyncNotifier + 코드 생성)
- **확장 가능한 프로젝트 구조**: Clean Architecture (Data/Domain/Presentation 3계층)

## Q1. 앱 구조 설계

### 폴더 구조 설계 이유

**Clean Architecture + Feature-First 구조**를 채택했습니다.

- **Feature-First**: 기능별로 폴더를 분리하여 기능 단위의 독립성을 확보했습니다. 현재는 `video_feed` 하나의 feature만 존재하지만, 향후 `user_profile`, `comments`, `discover` 등의 feature를 동일한 패턴으로 추가할 수 있습니다.
- **3-Layer Architecture**: 각 feature 내부를 `data` / `domain` / `presentation` 으로 분리하여 관심사를 명확히 구분했습니다.
  - `domain`: 순수 비즈니스 로직 (엔티티, UseCase, Repository 인터페이스)으로 외부 의존성이 없습니다.
  - `data`: API/로컬 데이터소스, JSON 직렬화, Repository 구현체를 담당합니다.
  - `presentation`: UI 위젯, 화면, 상태 관리 Provider를 포함합니다.
- **core**: feature 간 공유되는 상수, 테마, 공통 위젯을 배치했습니다.

### 상태 관리 방식 선택 이유

**Riverpod (AsyncNotifier + 코드 생성)** 을 선택한 이유:

1. **컴파일 타임 안전성**: Provider와 달리 런타임 에러 없이 타입 안전한 의존성 주입이 가능합니다.
2. **AsyncNotifier**: 비디오 목록의 비동기 로딩, 페이지네이션, 좋아요 상태를 하나의 Notifier에서 일관되게 관리할 수 있습니다. `AsyncValue`의 `when()` 패턴으로 loading/data/error 상태를 선언적으로 처리합니다.
3. **코드 생성**: `@riverpod` 어노테이션으로 보일러플레이트를 최소화하면서도 `keepAlive`, `autoDispose` 등 세밀한 생명주기 제어가 가능합니다.
4. **3-Layer Provider 체인**: DataSource → Repository → UseCase → Notifier 순으로 Provider를 연결하여 각 레이어의 의존성을 명시적으로 관리합니다.

### Video Player Lifecycle 처리 방식

**슬라이딩 윈도우 (Window Size: 3)** 방식으로 VideoPlayerController를 관리합니다.

```
[이전 페이지] [현재 페이지] [다음 페이지]
  pause()      play()      initialized (대기)
```

- 현재 보고 있는 페이지의 ±1 범위만 `VideoPlayerController`를 유지합니다 (최대 3개).
- 페이지 변경 시:
  1. 윈도우 밖의 컨트롤러는 `dispose()` 하여 메모리를 해제합니다.
  2. 윈도우 안에 새로 진입한 인덱스의 컨트롤러를 `initialize()` + `setLooping(true)` 합니다.
  3. 현재 페이지 컨트롤러만 `play()`, 나머지는 `pause()` 상태를 유지합니다.
- 이 방식으로 메모리 사용을 최소화하면서도 인접 비디오의 빠른 전환을 보장합니다.

## Q2. 확장성 설계

이 앱을 실제 TikTok 규모 서비스로 확장한다면 다음 영역을 개선해야 합니다.

### Video Preload 전략

- **현재**: 인접 1개씩 (총 3개) 프리로드. Mock 데이터 사용으로 네트워크 부하 없음.
- **개선 방향**:
  - 프리로드 윈도우를 사용자 스크롤 속도에 따라 동적으로 조절 (느리면 ±1, 빠르면 ±2~3)
  - 비디오 해상도를 적응적으로 선택 (네트워크 상태에 따라 360p → 720p → 1080p)
  - 첫 몇 초분의 데이터만 미리 버퍼링하여 초기 로딩 시간 최소화
  - CDN 기반 캐싱과 로컬 디스크 캐시 병행

### 네트워크 처리

- **현재**: Mock 데이터소스로 500ms 딜레이만 시뮬레이션.
- **개선 방향**:
  - `Dio` 기반 HTTP 클라이언트로 전환, 인터셉터를 통한 토큰 관리/에러 핸들링
  - 네트워크 연결 상태 모니터링 (`connectivity_plus`)으로 오프라인 대응
  - 실패 시 지수 백오프 재시도 (exponential backoff)
  - 페이지네이션을 cursor 기반으로 전환 (offset 기반은 데이터 변동 시 중복/누락 발생)

### 상태 관리 구조

- **현재**: 단일 `VideoFeedNotifier`가 비디오 목록 + 좋아요 상태를 모두 관리.
- **개선 방향**:
  - 좋아요/북마크 상태를 별도 Provider로 분리하여 관심사 분리
  - 사용자 인증 상태, 프로필, 알림 등 글로벌 상태를 `core/providers`에서 관리
  - 서버 상태 동기화를 위한 낙관적 업데이트(optimistic update) 패턴 적용
  - 로컬 캐시(Hive/Isar)를 활용한 오프라인 지원

### 성능 최적화

- **VideoPlayerController 풀링**: 컨트롤러를 재사용하여 초기화 비용 절감
- **썸네일 미리보기**: 비디오 로딩 전 썸네일 이미지를 먼저 표시
- **위젯 최적화**: `RepaintBoundary`, `const` 위젯 활용으로 불필요한 리빌드 방지
- **메모리 관리**: 비디오 캐시 크기 제한, LRU 정책으로 오래된 캐시 자동 정리
- **프레임 드랍 모니터링**: `SchedulerBinding`으로 jank 감지 및 프리로드 전략 조절

## Q3. 가장 어려웠던 문제

### 문제 상황

**VideoPlayerController의 생명주기 관리와 PageView 스크롤 간의 동기화**가 가장 어려운 문제였습니다.

PageView에서 세로 스와이프로 비디오를 전환할 때, 이전 비디오는 자동으로 정지하고 새 비디오는 자동으로 재생해야 합니다. 동시에 메모리 부족을 방지하기 위해 모든 비디오의 컨트롤러를 한꺼번에 생성할 수 없었습니다.

### 시도한 해결 방법

1. **각 비디오 위젯이 자체 컨트롤러 관리**: `StatefulWidget`의 `initState`/`dispose`에서 컨트롤러를 생성/해제하는 방식. 하지만 PageView가 위젯을 캐시하는 방식에 따라 `dispose` 타이밍이 예측 불가능했고, 화면 밖 비디오가 계속 재생되는 문제가 발생했습니다.

2. **모든 컨트롤러를 상위에서 한꺼번에 관리**: 모든 비디오 URL에 대해 컨트롤러를 미리 생성하는 방식. 무한 스크롤로 비디오가 계속 추가되면 메모리가 지속적으로 증가하는 문제가 있었습니다.

### 최종 해결 방법

**슬라이딩 윈도우 패턴**을 적용했습니다. `VideoFeedScreen`(부모)이 `Map<int, VideoPlayerController>`로 컨트롤러를 관리하되, 항상 현재 페이지 ±1 범위(최대 3개)만 유지합니다.

- `onPageChanged` 콜백에서 윈도우를 업데이트하여 범위 밖 컨트롤러는 `dispose()`, 새로 진입한 인덱스는 `initialize()` 합니다.
- `VideoPlayerWidget`은 `StatelessWidget`으로 순수하게 컨트롤러를 받아 렌더링만 담당하므로, 생명주기 관리의 복잡성을 부모 한 곳에 집중시켰습니다.
- `ValueListenableBuilder`로 컨트롤러 상태 변화(버퍼링, 재생/정지)를 반응적으로 UI에 반영합니다.

이 방식으로 메모리 효율성과 사용자 경험(빠른 전환) 사이의 균형을 달성했습니다.

## AI 사용 내역

### AI 사용 여부
예 - Claude Code (Claude Opus 4.6)를 사용했습니다.

### AI를 사용한 작업 범위
- 프로젝트 구조 설계 방향 논의
- 각 레이어별 코드 스캐폴딩 (엔티티, 모델, 데이터소스, 리포지토리, 프로바이더, 위젯)
- VideoFeedScreen의 비디오 컨트롤러 생명주기 관리 로직 구현
- README 문서 작성

### 본인이 직접 작성한 부분
- Clean Architecture 3계층 구조 설계 결정
- Riverpod 상태 관리 방식 선택 및 Provider 체인 설계
- 비디오 프리로딩 윈도우 크기(±1) 결정
- 더블탭 좋아요 인터랙션 기획
- 코드 리뷰 및 최종 검수


