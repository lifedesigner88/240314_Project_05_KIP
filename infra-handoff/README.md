# Infra Handoff

인프라 레이어에서 가져갈 정본 파일은 아래 3개가 기준이다.

## 필수 파일

1. 런타임 compose
- [compose.yaml](/home/sejong/240314_Project_05_KIP/compose.yaml)
- `mariadb`, `minio`, `backend`, `frontend` 실행 기준 파일

2. 서버 환경변수 템플릿
- [.env.server.example](/home/sejong/240314_Project_05_KIP/.env.server.example)
- 인프라에서는 이 파일을 복사해 `.env.server`로 사용
- 실제 비밀값은 인프라 레이어에서만 관리

3. 면접용 확장 더미데이터
- [seed-rich.sql](/home/sejong/240314_Project_05_KIP/seed-rich.sql)
- 초기 DB 위에 추가 주입하는 idempotent SQL

## 권장 사용 순서

1. 이 레포에서 최신 `compose.yaml`을 가져감
2. `.env.server.example`을 기반으로 인프라 레이어에서 `.env.server` 작성
3. 컨테이너 기동
- `docker compose --env-file .env.server up -d`
4. 더미데이터 주입
- `docker exec -i <mariadb-container> mariadb -uUSER -pPASSWORD DB_NAME < seed-rich.sql`

## 자동 주입으로 쓰는 경우

- `seed-rich.sql`을 MariaDB init 경로에 넣어도 됨
- 예시 경로
  - `/docker-entrypoint-initdb.d/20-seed-rich.sql`

## 인프라에서 보통 안 가져가도 되는 파일

- [Dockerfile](/home/sejong/240314_Project_05_KIP/Dockerfile)
- [Dockerfile](/home/sejong/240314_Project_05_KIP/kip-fe/Dockerfile)

이미지 pull 기반 배포면 위 2개는 인프라 레이어에 둘 필요가 없음.
이미지를 인프라에서 직접 빌드할 때만 함께 가져가면 됨.
