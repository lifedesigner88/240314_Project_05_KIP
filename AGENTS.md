# Refactor Context

이 파일은 `240314_Project_05_KIP`를 면접용 데모 버전으로 리팩터링할 때 필요한 고정 맥락 정리용 메모.

## 최종 목표

- `AWS Lightsail 4GB` 단일 인스턴스에서 이 프로젝트 하나를 실행.
- 1차 목표는 이 레포 단독으로 `docker compose up -d` 가능 상태 구성.
- 2차 목표는 배포용 이미지를 `GitHub Actions`로 빌드 후 레지스트리에 push하는 구조 구성.
- 서버 배포는 인프라 레이어가 이미지 `pull + up -d` 담당.
- 로컬과 서버 모두 변수명은 최대한 동일, 값만 `.env`로 분리.
- 로컬 기본 실행은 `.env -> .env.local` 기준 `docker compose up -d`.

## PR 운영 규칙

- PR 생성 시 브랜치 push까지만 하지 않음.
- PR 본문에는 변경 목적, 핵심 변경점, 테스트 여부를 함께 정리.
- 사용자가 바로 검토 후 머지할 수 있도록 merge-ready 상태로 올림.
- PR 생성 후 검토 요청 코멘트까지 남김.
- 가능하면 문서 변경, 설정 변경, 코드 변경 범위를 명확히 분리해 올림.

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
- `Firebase` 비활성화.
- `Redis` 비활성화.
- `refresh token` 제거.
- `access token only` 기준 인증 단순화.
- 관리자 계정과 더미 데이터 자동 주입 유지.

## 리팩토링 2단계

### 1단계. 이 레포 단독 compose

- 목표.
  - 레포를 clone 후 `docker compose up -d`로 전체 스택 기동.
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
외부 노출 URL은 `STORAGE_PUBLIC_BASE_URL` 기준으로 분리.

### Redis / Firebase 관계

- Redis는 JWT 저장소가 아니라 FCM 토큰 저장소.
- 관련 파일.
  - `src/main/java/com/FINAL/KIP/common/firebase/FCMTokenDao.java`
  - `src/main/java/com/FINAL/KIP/common/firebase/service/FCMService.java`
  - `src/main/java/com/FINAL/KIP/common/firebase/FCMInitializer.java`
  - `src/main/java/com/FINAL/KIP/common/redis/RedisConfig.java`

데모에서는 `Firebase`, `Redis` 모두 비활성화 대상.

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
  - `.env`
  - `.env.example`
  - `.env.local`
  - `.env.server.example`
- 인프라 레이어.
  - `.env.server`
- 서버 실제 값은 인프라 레이어가 보관.
- 프론트 공개 변수와 백엔드 비밀 변수는 분리 관리.

예시 방향.
- 로컬.
  - `NUXT_PUBLIC_API_BASE_URL=http://localhost:8080`
  - `STORAGE_PUBLIC_BASE_URL=http://localhost:9000`
- 서버.
  - `NUXT_PUBLIC_API_BASE_URL=https://vue-spring.sejongclass.kr/api`
  - `STORAGE_PUBLIC_BASE_URL=https://vue-spring-file.sejongclass.kr`

### CORS

- 현재 허용 도메인이 하드코딩 상태.
- 관련 파일.
  - `src/main/java/com/FINAL/KIP/securities/SecurityConfig.java`

도메인 변경 시 함께 수정 필요.

### JVM 메모리

- 현재 `Dockerfile`에는 JVM 메모리 제한 없음.
- 관련 파일.
  - `Dockerfile`

Lightsail 4GB 기준으로 `JAVA_TOOL_OPTIONS` 기반 메모리 제한 적용.

## 데모 기준 권장 구성

- `frontend`
- `backend`
- `mariadb`
- `minio`
- `dummy data seed`

## 우선 리팩토링 순서

1. 이 레포 단독 `docker compose` 서비스 구조 설계.
2. `S3 -> MinIO` 전환.
3. `Firebase`, `Redis` 비활성화.
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

## 현재 검증 상태

- `docker compose build backend frontend` 통과.
- `docker compose up -d` 통과.
- 확인된 컨테이너.
  - `frontend`
  - `backend`
  - `mariadb`
  - `minio`
- 더미 admin 로그인 응답 확인.
  - `asm-1234 / 1234`

## 현재 작업 브랜치

- 작업 브랜치.
  - `feat/demo-compose-local`
- 원격 push 완료.
- 최근 커밋.
  - `252c04b`
  - `feat: add demo compose runtime`
- 현재 단계에서는 `PR 생성 없이 브랜치 push만` 유지.

## 이번 리팩터링에서 실제 반영된 내용

- 루트 기준 `compose.yaml` 추가.
- 기본 환경 파일 추가.
  - `.env`
  - `.env.local`
  - `.env.example`
  - `.env.server.example`
- 백엔드 Dockerfile 정리.
- 프론트 Dockerfile 추가.
- `MinIO` 호환 업로드 경로 반영.
- `Firebase`, `Redis` 비활성화용 no-op service 추가.
- `OpenSearch` 없이 동작 가능한 검색 fallback 반영.
- `refresh token` 제거 후 `access token only` 구조로 단순화.
- `Nuxt` 런타임 환경변수 기반 API 주소 사용으로 정리.
- README와 이 문서 기준도 현재 코드 상태에 맞게 갱신.
- `InitialDataLoader`에 면접용 더미데이터 시드 추가.
  - 공개 문서 3개
  - 그룹 트리 6개
  - 데모 사용자 8명
  - 그룹별 문서, 버전 이력, 권한 요청 샘플 포함

## 현재 로컬 기본값

- `.env.local`은 현재 원격 확인용 주소 기준.
  - `NUXT_PUBLIC_API_BASE_URL=http://100.122.220.121:8080`
  - `ALLOWED_ORIGINS=http://100.122.220.121:3000`
  - `STORAGE_PUBLIC_BASE_URL=http://100.122.220.121:9000`
- 로컬 PC에서 다시 사용할 때는 `localhost` 기준으로 되돌려야 함.

## 더미데이터 계정 메모

- 관리자.
  - `asm-1234 / 1234`
  - 이름: `소마멘토`
- 일반 데모 계정.
  - `asm-0001 / 1234`
  - `asm-0002 / 1234`
  - `asm-0003 / 1234`
  - `asm-0004 / 1234`
  - `asm-0005 / 1234`
  - `asm-0006 / 1234`
  - `asm-0007 / 1234`
- 주요 시드 구조.
  - 루트 그룹: `AI SW 마에스트로`
  - 하위 그룹: `공통 운영`, `제품 개발`, `백엔드`, `프론트엔드`, `AI 실험실`
  - 공개 문서 3개
  - 그룹 문서 다수
  - 승인 요청 1개, 대기 요청 1개

## 더미데이터 아이디 규칙

- 프론트 사용자 생성 폼 기준 아이디 정규식.
  - `^asm-\\d{4}$`
- 더미데이터 계정도 모두 이 규칙에 맞춰 유지.

## 현재 풀어야 할 핵심 이슈

### 1. Docker 데몬 충돌

- 현재 서버에는 Docker 데몬이 2개 존재.
  - system docker
    - `/usr/bin/dockerd`
  - snap docker
    - `snap.docker.dockerd`
- 이 때문에 다음 증상이 반복됨.
  - `docker ps` 연결 실패
  - `Cannot connect to the Docker daemon at unix:///var/run/docker.sock`
  - 컨테이너 stop 시 `permission denied`
- 브랜치 문제가 아니라 서버 Docker 런타임 충돌 문제로 판단.

### 2. 재부팅 후 우선 확인할 순서

- 목표.
  - `system docker`만 정상 사용 가능한 상태로 정리
- 재부팅 후 사용자에게 안내할 우선 명령.
  - `sudo snap stop docker`
  - `sudo snap disable docker`
  - `sudo systemctl enable --now docker`
  - `sudo systemctl restart docker`
  - `docker ps`
  - `ps -ef | grep -E 'dockerd|containerd'`
- 가능하면 `dockerd`는 `/usr/bin/dockerd` 한 개만 남는 상태가 바람직.
- 중요한 기존 snap docker 데이터가 있는지 확정 전까지 `snap remove docker`는 보류.

### 3. compose 재기동 확인

- Docker 데몬 정상화 후 재확인 명령.
  - `docker compose down --remove-orphans`
  - `docker compose up -d --build`
- 기대 결과.
  - `frontend`
  - `backend`
  - `mariadb`
  - `minio`
  - `minio-init`
  - 모두 정상 기동

## 다음 리팩터링 우선순위

1. Docker 데몬 충돌 해소.
2. `docker compose up -d` 재검증.
3. 브라우저 접속 주소와 API/CORS 값 재검증.
4. `.env.local`과 서버용 값 분리 정리 여부 판단.
5. `GitHub Actions -> GHCR 이미지 빌드/푸시` 구성 시작.

## SQL 시드 프롬프트 메모

- 추가 더미데이터용 SQL 생성 프롬프트 파일.
  - `SQL_SEED_PROMPT.md`
- 목적.
  - 현재 기본 앱 시드를 기준으로 인프라에서 직접 주입 가능한 `idempotent MariaDB SQL` 생성

## 주의할 점

- 사용자는 `sudo`가 필요한 명령을 직접 실행하는 방식을 선호.
- PR은 사용자가 요청할 때만 생성.
- 현재는 `push만` 유지하는 브랜치 운영 선호.
