# Infra Handoff

이 폴더는 인프라 레이어가 그대로 가져가서 쓸 배포용 compose와 더미데이터 SQL 묶음이다.  
기본 데모값은 compose와 앱 설정에 이미 들어 있고, 기본 실행에는 별도 env 파일이 필요 없다.

## 필수 파일

1. 런타임 compose
- [compose.yaml](./compose.yaml)
- `kip-mariadb`, `kip-minio`, `kip-backend`, `kip-frontend` 실행 기준 파일
- GHCR 이미지 `pull + up -d` 전용 배포용 compose

2. 면접용 확장 더미데이터
- [seed-rich.sql](./seed-rich.sql)
- `kip-backend` 기본 시드 완료 후 `db-seed` one-shot service가 자동 주입하는 idempotent SQL
- `seed-rich v1` 흔적이 이미 있으면 `db-seed`는 자동으로 skip

## 권장 사용 순서

1. 레포 루트에서 실행
2. 배포 이미지 pull

```bash
docker compose -f infra-handoff/compose.yaml pull
```

3. 컨테이너 기동

```bash
docker compose -f infra-handoff/compose.yaml up -d
```

4. 상태 확인

```bash
docker compose -f infra-handoff/compose.yaml ps
```

- `kip-backend`가 `Up`, `db-seed`가 `Exited (0)`, `kip-frontend`가 `Up`이면 정상
- `kip-backend`, `kip-frontend`는 `pull_policy: always`라서 `pull` 또는 `up` 시 최신 `demo` 태그를 우선 확인한다.

## 배포 전달용 환경변수

- 기본 데모는 env 없이도 동작한다.
- 로컬 기본값은 프론트 `3000` 단일 진입점 기준이며, 데모 고정값은 대부분 compose와 앱 설정에 이미 반영되어 있다.
- 배포 이미지명도 compose와 workflow에 `ghcr.io/lifedesigner88/kip-backend:demo`, `ghcr.io/lifedesigner88/kip-frontend:demo`로 고정했다.

## 도메인 기준

- 서비스: `https://vue-spring.huposit.kr`
- API: `https://vue-spring.huposit.kr/api`
- 파일: `https://vue-spring.huposit.kr/storage`
- 루트/`www`: Cloudflare에서 `vue-spring.huposit.kr`로 리다이렉트

## 더미데이터만 다시 넣는 경우

```bash
docker compose -f infra-handoff/compose.yaml rm -f db-seed
docker compose -f infra-handoff/compose.yaml up db-seed
```

## 인프라에서 보통 안 가져가도 되는 파일

- `이 폴더 밖의 앱 소스 전체`
- `backend` / `frontend` Dockerfile

이미지 pull 기반 배포면 앱 소스와 Dockerfile은 인프라 레이어에 둘 필요가 없다.
