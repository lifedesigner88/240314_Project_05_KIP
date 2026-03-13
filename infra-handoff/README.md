# Infra Handoff

이 폴더는 인프라 레이어가 그대로 가져가서 쓸 배포용 compose와 더미데이터 SQL 묶음이다.  
환경변수는 더 이상 이 폴더 안에 따로 두지 않고, 루트 [`.env.example`](../.env.example) 한 파일만 기준으로 사용한다.

## 필수 파일

1. 런타임 compose
- [compose.yaml](./compose.yaml)
- `mariadb`, `minio`, `backend`, `frontend` 실행 기준 파일
- GHCR 이미지 `pull + up -d` 전용 배포용 compose

2. 단일 환경변수 파일
- [../.env.example](../.env.example)
- compose 이미지/포트 값과 backend/frontend 런타임 값을 함께 관리
- 이 파일을 그대로 수정해도 되고, 다른 파일명으로 복사했다면 `--env-file`로 넘기면 됨

3. 면접용 확장 더미데이터
- [seed-rich.sql](./seed-rich.sql)
- `backend` 기본 시드 완료 후 `db-seed` one-shot service가 자동 주입하는 idempotent SQL
- `seed-rich v1` 흔적이 이미 있으면 `db-seed`는 자동으로 skip

## 권장 사용 순서

1. 레포 루트에서 실행
2. 환경값 검토 또는 수정
- [`.env.example`](../.env.example)
3. 컨테이너 기동

```bash
docker compose -f infra-handoff/compose.yaml --env-file .env.example up -d
```

4. 상태 확인

```bash
docker compose -f infra-handoff/compose.yaml ps
```

- `backend`가 `Up`, `db-seed`가 `Exited (0)`, `frontend`가 `Up`이면 정상

## 배포 전달용 환경변수

단일 기준 파일은 루트 [`.env.example`](../.env.example) 이다.

```env
COMPOSE_PROJECT_NAME=kip-demo
MARIADB_IMAGE=mariadb:11.4
MINIO_IMAGE=minio/minio:latest
MINIO_MC_IMAGE=minio/mc:latest
DB_SEED_IMAGE=mariadb:11.4
BACKEND_IMAGE=ghcr.io/lifedesigner88/kip-demo-backend:demo
FRONTEND_IMAGE=ghcr.io/lifedesigner88/kip-demo-frontend:demo
FRONTEND_HOST_PORT=3000
FRONTEND_CONTAINER_PORT=3000
BACKEND_HOST_PORT=8080
BACKEND_CONTAINER_PORT=8080
MINIO_API_HOST_PORT=9000
MINIO_CONSOLE_HOST_PORT=9001
SPRING_PROFILES_ACTIVE=demo
DB_HOST=mariadb
DB_PORT=3306
DB_NAME=kip
DB_USERNAME=kip
DB_PASSWORD=demo-password
MARIADB_DATABASE=kip
MARIADB_USER=kip
MARIADB_PASSWORD=demo-password
MARIADB_ROOT_PASSWORD=demo-root-password
JWT_SECRET_KEY=demo-jwt-secret-key-for-interview-only
JWT_EXPIRATION_MINUTES=720
JWT_ISSUER=kip-demo
FEATURE_PUSH_ENABLED=false
FEATURE_SEARCH_ENABLED=false
SPRING_JPA_SHOW_SQL=false
SPRING_JPA_PROPERTIES_HIBERNATE_FORMAT_SQL=false
AWS_REGION=ap-northeast-2
STORAGE_BUCKET=kip-demo
STORAGE_ENDPOINT=http://minio:9000
STORAGE_PUBLIC_BASE_URL=http://localhost:9000
STORAGE_ACCESS_KEY=minioadmin
STORAGE_SECRET_KEY=minioadmin
STORAGE_PATH_STYLE_ACCESS=true
STORAGE_AUTO_CREATE_BUCKET=true
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000,https://vue-spring.huposit.kr,https://huposit.kr,https://www.huposit.kr
JAVA_TOOL_OPTIONS=-Xms256m -Xmx512m
NUXT_PUBLIC_API_BASE_URL=http://localhost:8080
NUXT_PUBLIC_PUSH_ENABLED=false
```

- 로컬 기본값은 `localhost` 기준이며, 배포 전에는 아래 3개만 서버 도메인 값으로 바꿔서 전달한다.
- `STORAGE_PUBLIC_BASE_URL=https://vue-spring-s3.huposit.kr`
- `ALLOWED_ORIGINS=https://vue-spring.huposit.kr,https://huposit.kr,https://www.huposit.kr`
- `NUXT_PUBLIC_API_BASE_URL=https://vue-spring.huposit.kr/api`

## 도메인 기준

- 서비스: `https://vue-spring.huposit.kr`
- API: `https://vue-spring.huposit.kr/api`
- 파일: `https://vue-spring-s3.huposit.kr`
- 루트/`www`: Cloudflare에서 `vue-spring.huposit.kr`로 리다이렉트

## 더미데이터만 다시 넣는 경우

```bash
docker compose -f infra-handoff/compose.yaml rm -f db-seed
docker compose -f infra-handoff/compose.yaml --env-file .env.example up db-seed
```

## 인프라에서 보통 안 가져가도 되는 파일

- `이 폴더 밖의 앱 소스 전체`
- `backend` / `frontend` Dockerfile

이미지 pull 기반 배포면 앱 소스와 Dockerfile은 인프라 레이어에 둘 필요가 없다.
