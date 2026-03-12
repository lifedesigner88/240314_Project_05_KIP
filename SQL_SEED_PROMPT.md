# Rich Demo SQL Seed Prompt

아래 프롬프트는 현재 KIP 데모 DB에 이미 들어간 기본 시드를 기준으로, `추가 더미데이터만` 넣는 `MariaDB용 idempotent SQL`을 생성하기 위한 용도다.

## 사용 목적

- 인프라 레이어에서 `seed-rich.sql` 같은 파일을 생성하기 위한 프롬프트
- 이미 떠 있는 `MariaDB`에 직접 실행 가능한 SQL 생성
- 현재 앱 시드와 충돌 없이 더 풍부한 데모 데이터를 추가하는 구조

## 프롬프트

```text
당신은 MariaDB 11용 시드 데이터 SQL을 작성하는 시니어 데이터 엔지니어다.

목표:
- 현재 KIP 데모 DB에 이미 주입된 기본 더미데이터를 유지하면서
- 추가 데모 데이터만 넣는 idempotent SQL 스크립트를 작성하라.
- 결과물은 인프라에서 바로 실행 가능한 순수 SQL이어야 한다.
- 설명 문장 없이 SQL만 출력하라.

중요 제약:
1. 대상 DB는 MariaDB다.
2. 기존 데이터는 삭제하거나 수정하지 말고, 추가 데이터만 넣어라.
3. 동일 SQL을 여러 번 실행해도 중복 삽입되지 않도록 작성하라.
4. FK 연결 시 하드코딩된 숫자 ID만 믿지 말고, 가능하면 business key 기반 서브쿼리를 사용하라.
5. `group`는 예약어이므로 테이블명은 반드시 백틱으로 감싸서 `group`으로 사용하라.
6. 신규 사용자의 employee_id는 반드시 정규식 `^k-\\d{10}$`를 만족해야 한다.
7. 신규 사용자 비밀번호는 모두 로그인 가능해야 하며, 평문 `1234`에 해당하는 아래 해시를 그대로 사용하라.
   - `{bcrypt}$2a$10$wLJ8/V6Vn0no02U8hBtjquLjmk9P4JUxvim6.INyXqVbZE5rgYiwa`
8. 문서 데이터는 반드시 version 테이블과 함께 들어가야 한다.
9. 그룹 문서는 각 그룹마다 최상단 문서 1개가 필요하다.
10. 그룹 문서 체인은 up_link_id / down_link_id가 일관되도록 작성하라.
11. 필요하면 `START TRANSACTION;` / `COMMIT;`를 사용하라.
12. 출력은 SQL only. 마크다운 금지.

현재 이미 존재하는 기준 데이터:

[user]
- `k-1234567890` / `소마멘토` / ADMIN
- `k-2403140001` / `김민서 PM`
- `k-2403140002` / `이도윤 Backend`
- `k-2403140003` / `박서윤 Frontend`
- `k-2403140004` / `정하늘 AI`
- `k-2403140005` / `최지훈 QA`
- `k-2403140006` / `장유진 Mentor`
- `k-2403140007` / `한서준 PO`

[group]
- id=1 `AI 소프트웨어 마에스트로 데모`
- id=2 `공통 운영` (super_group_id=1)
- id=3 `제품 개발` (super_group_id=1)
- id=4 `백엔드` (super_group_id=3)
- id=5 `프론트엔드` (super_group_id=3)
- id=6 `AI 실험실` (super_group_id=1)

[document]
- 공개 문서
  - `데모 사용 가이드`
  - `면접 시연 체크리스트`
  - `프로젝트 한 줄 소개`
- 공통 운영
  - `공통 운영 그룹 안내`
  - `주간 운영 보드`
  - `면접 데모 시나리오`
- 제품 개발
  - `제품 개발 그룹 안내`
  - `서비스 아키텍처 개요`
  - `릴리즈 준비 체크리스트`
- 백엔드
  - `백엔드 그룹 안내`
  - `Docker Compose 운영 가이드`
  - `JWT 인증 단순화 기록`
- 프론트엔드
  - `프론트엔드 그룹 안내`
  - `Nuxt 화면 흐름 정리`
  - `문서 편집 UX 개선안`
- AI 실험실
  - `AI 실험실 그룹 안내`
  - `RAG 검색 실험 로그`
  - `프롬프트 평가 기준`

[request]
- requester `k-2403140006`
- pending 1건: `서비스 아키텍처 개요`
- approved 1건: `RAG 검색 실험 로그`

현재 테이블:
- `user`
- `group`
- `group_user`
- `document`
- `version`
- `request`
- `note`
- `bookmarks`
- `comment`
- `hash_tag`
- `doc_hash_tag`
- `attached_file`

테이블 핵심 컬럼 규칙:

[user]
- id
- name
- email
- phone_number
- password
- profile_image_url
- employed_day
- employee_id
- role

[group]
- id
- group_name
- group_type (`DEPARTMENT` or `BUSINESS`)
- super_group_id

[group_user]
- group_id
- user_id
- group_role (`SUPER` or `NORMAL`)

[document]
- id
- uuid
- title
- kms_doc_type (`SECTION` or `CONTENT`)
- book_count
- up_link_id
- down_link_id
- group_id

[version]
- id
- content
- message
- is_show (`Y` or `N`)
- document_id
- writer_id

[request]
- id
- due_date
- is_ok (`P`, `Y`, `N`)
- requester_del_yn
- del_yn
- days
- document_id
- requester_id
- group_id

[note]
- id
- is_read
- message
- writer_id
- receiver_id
- document_id

[bookmarks]
- id
- documentId
- user_id

[comment]
- id
- comment
- user_name
- super_comment_id
- document_id

[hash_tag]
- id
- tag_name

[doc_hash_tag]
- document_id
- hash_tag_id

[attached_file]
- id
- file_name
- file_type
- file_url
- document_id

이번에 생성할 추가 데이터 요구사항:
- 신규 사용자 12명 이상
- 신규 그룹 5개 이상
- 신규 공개 문서 5개 이상
- 신규 그룹 문서 20개 이상
- 버전 이력 10건 이상 추가
- 권한 요청 8건 이상
  - pending / approved / refused 상태를 모두 포함
- 북마크 10건 이상
- 댓글 10건 이상
- 해시태그 12개 이상
- doc_hash_tag 매핑 충분히 추가
- note 6건 이상

데이터 컨셉:
- `AI 소프트웨어 마에스트로 데모`의 확장 시나리오
- 신규 그룹 예시:
  - `배포 운영`
  - `디자인 시스템`
  - `데이터 파이프라인`
  - `모델 평가`
  - `온보딩`
- 문서 주제 예시:
  - 운영 회고
  - 장애 대응 매뉴얼
  - 프롬프트 실험 기록
  - 릴리즈 노트
  - 사용자 인터뷰 정리
  - 데이터 품질 체크리스트
  - API 연동 가이드

SQL 작성 원칙:
- 가능하면 `INSERT ... SELECT ... WHERE NOT EXISTS (...)`
- 또는 `INSERT IGNORE`
- 사용자/그룹/문서 매핑은 제목, employee_id, group_name 등으로 찾아서 연결
- 기존 기본 시드와 충돌 금지
- 실행 즉시 데모에서 조회 가능한 수준으로 관계를 채울 것
- 신규 그룹을 만들 때는 해당 그룹의 최상단 안내 문서(`SECTION`)와 버전도 함께 생성할 것
- 공개 문서는 `group_id IS NULL`
- 그룹 문서는 같은 그룹 내부에서 문서 체인이 이어지도록 할 것
- comments.user_name은 실제 작성자 이름과 맞출 것
- attached_file.file_url은 실제 외부 파일 없이도 동작하도록 예시 URL(`https://vue-spring-file.sejongclass.kr/demo/...`) 사용 가능

마지막 출력 형식:
- SQL only
- 설명 금지
- 주석은 최소한으로만 허용
```

## 인프라 적용 방식

생성된 `seed-rich.sql`은 아래 방식으로 바로 주입 가능하다.

### 실행 중인 DB에 직접 주입

```bash
docker exec -i kip-demo-mariadb-1 mariadb -ukip -pkip1234 kip < seed-rich.sql
```

### 최초 기동 시 자동 주입

```text
/docker-entrypoint-initdb.d/20-seed-rich.sql
```

단, 이 방식은 `MariaDB 데이터 디렉토리가 비어 있을 때만` 자동 실행된다.

## 주의할 점

- SQL은 DB 데이터만 넣는다.
- 첨부파일, 에디터 이미지가 실제 파일까지 필요하면 `MinIO` 객체도 별도로 넣어야 한다.
- 이미 떠 있는 DB에 여러 번 쏠 예정이면 `idempotent SQL`이 필수다.
