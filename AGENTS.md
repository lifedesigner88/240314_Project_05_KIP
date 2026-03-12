# Refactor Context

이 파일은 `240314_Project_05_KIP`를 면접용 데모 버전으로 리팩터링할 때 필요한 고정 맥락 정리용 메모.

## 최종 목표

- `AWS Lightsail 4GB` 단일 인스턴스에서 이 프로젝트 하나를 실행.
- 1차 목표는 이 레포 단독으로 `docker compose up -d` 가능 상태 구성.
- 2차 목표는 배포용 이미지를 `GitHub Actions`로 빌드 후 레지스트리에 push하는 구조 구성.
- 서버 배포는 인프라 레이어가 이미지 `pull + up -d` 담당.
- 로컬과 서버 모두 변수명은 최대한 동일, 값만 `.env`로 분리.

## 확정된 방향

- 서비스 도메인.
  - `vue-spring.sejongclass.kr`
- 파일 도메인.
  - `vue-spring-file.sejongclass.kr`
- 프론트도 Docker 컨테이너에 포함.
- 파일 저장소는 `MinIO`.
- 이 레포 단독 compose에는 `Caddy`를 포함하지 않음.
- `Caddy`는 단일 인스턴스에서 여러 데모를 라우팅하는 인프라 레이어 책임.
- 배포용 이미지는 고정된 이미지 명칭으로 관리하는 방향.
- 권장 레지스트리는 `GHCR`.
- `demo-platform-infra` 스캐폴드는 사용자 요청으로 제거함.
- `AWS snapshot` 작업은 현재 범위에서 제외.

## 데모용 단순화 목표

- `OpenSearch` 제거.
- `Firebase` 제거.
- `Redis` 제거.
- `refresh token` 제거.
- `access token only` 기준 인증 단순화.
- 관리자 계정과 더미 데이터 자동 주입 유지.

## 리팩토링 2단계

### 1단계. 이 레포 단독 compose

- 목표.
  - 레포를 clone 후 `docker compose --env-file .env.local up -d`로 전체 스택 기동.
- 포함 대상.
  - `frontend`
  - `backend`
  - `mariadb`
  - `minio`
  - `dummy data seed`
- 제외 대상.
  - `Caddy`
  - 인프라 전용 라우팅 설정

### 2단계. 이미지 기반 서버 배포

- 목표.
  - `GitHub Actions`가 배포용 이미지만 빌드해서 레지스트리에 push.
  - `Lightsail`에서는 인프라 레이어가 해당 이미지를 `pull + up -d`.
- 책임 분리.
  - 이 레포.
    - Dockerfile
    - 앱 코드
    - `.env.example`
    - 이미지 빌드 workflow
  - 인프라 레이어.
    - `.env.server`
    - compose 실행
    - 이미지 pull
    - 컨테이너 재기동

## 현재 코드 기준 주요 포인트

### S3 직접 의존

- 첨부파일.
  - `src/main/java/com/FINAL/KIP/attachedfile/service/AttachedFileService.java`
- 에디터 이미지.
  - `src/main/java/com/FINAL/KIP/document/service/DocumentService.java`
- 프로필 이미지.
  - `src/main/java/com/FINAL/KIP/user/service/UserService.java`
- 공통 설정.
  - `src/main/java/com/FINAL/KIP/common/s3/S3Config.java`

현재 구조는 `fileUrl`을 직접 저장하고 URL을 그대로 반환하는 방식.
데모 기준 최소 수정 방향은 `S3 -> MinIO` 호환 방식 유지.

### Redis / Firebase 관계

- Redis는 JWT 저장소가 아니라 FCM 토큰 저장소.
- 관련 파일.
  - `src/main/java/com/FINAL/KIP/common/firebase/FCMTokenDao.java`
  - `src/main/java/com/FINAL/KIP/common/firebase/service/FCMService.java`
  - `src/main/java/com/FINAL/KIP/common/firebase/FCMInitializer.java`
  - `src/main/java/com/FINAL/KIP/common/redis/RedisConfig.java`

데모에서는 `Firebase`, `Redis` 모두 제거 대상.

### refresh token 상태

- 백엔드는 refresh token을 발급하고 DB에 저장.
- 프론트는 사실상 refresh token을 사용하지 않음.
- 현재 재발급 흐름은 데모 기준 유지 가치가 낮음.
- 제거 대상 파일.
  - `src/main/java/com/FINAL/KIP/securities/JwtTokenProvider.java`
  - `src/main/java/com/FINAL/KIP/securities/JwtAuthFilter.java`
  - `src/main/java/com/FINAL/KIP/securities/refresh/UserRefreshToken.java`
  - `src/main/java/com/FINAL/KIP/securities/refresh/UserRefreshTokenRepository.java`
  - `src/main/java/com/FINAL/KIP/user/service/UserService.java`
  - `kip-fe/stores/User.js`

### 프론트 / 환경변수

- 프론트는 `Nuxt` 기반.
- 관련 파일.
  - `kip-fe/nuxt.config.ts`
  - `kip-fe/package.json`
  - `kip-fe/stores/User.js`

도메인과 API 주소는 `.env.local`, `.env.server` 기준으로 분리하는 방향 우선.

## 환경변수 원칙

- 변수명은 최대한 동일하게 유지.
- 값만 로컬과 서버에서 다르게 설정.
- 이 레포.
  - `.env.example`
  - `.env.local`
- 인프라 레이어.
  - `.env.server`
- 서버 실제 값은 인프라 레이어가 보관.
- 프론트 공개 변수와 백엔드 비밀 변수는 분리 관리.

예시 방향.
- 로컬.
  - `PUBLIC_API_BASE_URL=http://localhost:8080`
  - `PUBLIC_FILE_BASE_URL=http://localhost:9000`
- 서버.
  - `PUBLIC_API_BASE_URL=https://vue-spring.sejongclass.kr/api`
  - `PUBLIC_FILE_BASE_URL=https://vue-spring-file.sejongclass.kr`

### CORS

- 현재 허용 도메인이 하드코딩 상태.
- 관련 파일.
  - `src/main/java/com/FINAL/KIP/securities/SecurityConfig.java`

도메인 변경 시 함께 수정 필요.

### JVM 메모리

- 현재 `Dockerfile`에는 JVM 메모리 제한 없음.
- 관련 파일.
  - `Dockerfile`

Lightsail 4GB 기준으로 `JAVA_TOOL_OPTIONS` 기반 메모리 제한 적용 검토 필요.

## 데모 기준 권장 구성

- `frontend`
- `backend`
- `mariadb`
- `minio`
- `dummy data seed`

## 우선 리팩토링 순서

1. 이 레포 단독 `docker compose` 서비스 구조 설계.
2. `S3 -> MinIO` 전환.
3. `Firebase`, `Redis` 제거.
4. `refresh token` 제거.
5. `CORS`, 도메인, 환경변수 정리.
6. 더미 데이터와 관리자 계정 자동 주입 확인.
7. `GitHub Actions -> 이미지 빌드 -> GHCR push` workflow 정리.
8. 인프라 레이어 기준 `pull + up -d` 배포 흐름 정리.

## 유지할 시나리오

1. 관리자 로그인
2. 사용자 생성
3. 그룹 생성 및 사용자 배치
4. 문서 작성 및 수정
5. 권한 요청 및 승인
6. 북마크 및 검색
