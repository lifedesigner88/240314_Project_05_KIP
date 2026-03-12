# <div align="center">집단 지성 활용을 위한 지식 관리 시스템</div>

## <div align="center">KIP: Knowledge Is Power</div>

### <div align="center">5조 Team_KIP</div>
<div align="center">🐰장준혁 팀장 🐂김영광 팀원 🐲박세종 팀원 🐴윤지용 팀원</div>
<br/>

⭐ [개발 히스토리](https://blog.naver.com/PostList.naver?blogId=lifedesigner88&categoryNo=34&skinType=&skinId=&from=menu)  
⭐ [KIP PPT - 산출물 제출용.pdf](https://github.com/lifedesigner88/240314_Project_05_KIP/files/15318458/KIP.PPT.-.pdf)

![프로젝트-1위-박세종](https://github.com/lifedesigner88/240314_Project_05_KIP/assets/123573918/a8c1596a-6e71-4fdf-aac9-22860a00a970)

---

## 프로젝트 소개

KIP는 조직 내부의 문서와 노하우를 체계적으로 축적하고 공유하기 위한 사내 지식관리 시스템입니다.  
문서 권한, 조직 계층, 버전 이력, 검색, 알림 기능을 함께 다루며 "정보는 쌓이는데 찾기 어렵고, 권한 때문에 공유가 막히는 문제" 해결에 집중.

### 핵심 목표
- 조직형 문서 자산 통합 관리.
- 팀과 부서 단위 권한 모델 적용.
- 문서 검색, 해시태그, 북마크, 이력 관리로 재사용성 강화.
- 관리자 중심 사용자/조직 관리 기능 구현.

### 핵심 포인트
- `Nuxt 3 + Spring Boot` 분리형 아키텍처.
- `JWT 기반 인증/인가`와 `조직 권한 모델`.
- `문서 버전 관리`, `권한 요청`, `첨부파일`, `검색`까지 포함한 업무형 서비스.
- `AWS 기반 데모 배포` 경험.

---

## 주요 기능

### 1. 권한 기반 문서 관리
- 전체 공개 문서와 그룹 전용 문서 관리.
- 상위 조직 관리자의 하위 조직 문서 열람 구조 설계.
- 타 조직 문서 대상 권한 요청 및 승인 흐름 지원.

### 2. 관리자 중심 사용자/조직 관리
- 관리자 계정 생성 및 그룹 배치 기능 구성.
- 조직 계층 기반 그룹 생성, 수정, 삭제, 슈퍼유저 지정 기능 제공.

### 3. 지식 탐색 기능
- 문서 검색, 해시태그, 북마크 기능 제공.
- 공개 문서와 권한 승인 문서 구분 및 접근 가능 여부 판단.

### 4. 문서 이력과 협업
- 마크다운 기반 문서 작성 및 수정 지원.
- 수정 이력 버전 관리 및 이전 상태 복원 지원.
- 첨부파일 업로드와 문서 이동 기능 포함.

### 5. 알림과 사용자 경험
- 권한 요청 승인/거절 이벤트 기반 알림 흐름 구성.
- 마이페이지에서 사용자 정보 수정, 비밀번호 변경, 북마크 조회 지원.

---

## 레포 구조

```text
.
├── src/                   # Spring Boot backend
├── kip-fe/                # Nuxt 3 frontend
├── k8s/                   # Kubernetes manifests
├── .github/workflows/     # GitHub Actions CI/CD
├── Dockerfile             # Backend container build
├── build.gradle           # Backend dependencies
└── README.md
```

---

## 기술 스택

> 소스코드 기준으로 정리한 기술 스택입니다.

### 공통
- 형상관리 및 협업: `Git`, `GitHub`, `Jira`, `Slack`
- 운영 환경: `Linux`

### 프론트엔드
- Framework: `Nuxt 3`, `Vue 3`
- State Management: `Pinia`
- UI / Form: `Vuetify`, `FormKit`
- Editor: `Toast UI Editor`
- Notification: `Firebase Cloud Messaging`
- Language / Runtime: `JavaScript`, `Node.js`

### 백엔드
- Language: `Java 17`
- Framework: `Spring Boot 3`, `Spring Web`, `Spring Security`, `Spring Validation`
- Authentication: `JWT`
- ORM / Persistence: `Spring Data JPA`
- Database: `MariaDB`
- Cache: `Redis`
- Search: `OpenSearch`
- File Storage: `AWS S3`
- Notification: `Firebase Admin SDK`
- Build Tool: `Gradle`

### 인프라 / DevOps
- CI/CD: `GitHub Actions`
- Containerization: `Docker`
- Orchestration: `Kubernetes`
- AWS Infrastructure: `Amazon EKS`, `Amazon ECR`, `Amazon S3`, `Amazon OpenSearch Service`

---

## 시스템 아키텍처

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/a485d85c-4004-46a6-ac37-6cebe1cef493">
</p>

- 프론트엔드 `Nuxt 3`, 백엔드 API 분리 구조.
- 백엔드는 `Spring Boot` 기반으로 인증, 문서, 조직, 알림 도메인 처리.
- 검색, 파일 저장, 알림 기능은 외부 서비스 연동 구조로 확장.

---

## ERD

![image](https://github.com/lifedesigner88/240314_Project_05_KIP/assets/123573918/65882803-15e3-4e06-a1f6-2bbbdd1b33ca)

---

## 화면 예시

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/e78374c8-e5e5-43d2-b53a-85d6c2b3c179">
</p>

- [KIP 화면설계 피그마 링크](https://www.figma.com/file/7uzpyZLpNiRnG6SaqKPq0G/KIP_FrontPage?type=design&node-id=0%3A1&mode=design&t=bmqXufLzF1sSbCEr-1)

---

## 기존 데모 배포 방식

AWS 중심 구조로 데모 배포 진행.

### 프론트엔드
- `AWS Amplify`에 GitHub 저장소 연결 후 배포.
- 환경변수 주입 및 커스텀 도메인 `www.teamkip.info` 연결.
- 브랜치 변경 시 자동 프론트 배포 진행.

### 백엔드
- `GitHub Actions`에서 Docker 이미지 빌드.
- 빌드 이미지 `Amazon ECR` 푸시.
- `Amazon EKS` 배포 후 `Kubernetes Deployment/Service/Ingress`로 서비스.
- 도메인 `server.teamkip.info` 연결.

### 부가 인프라
- 첨부파일과 문서 이미지 저장에 `Amazon S3` 사용.
- 문서 검색에 `OpenSearch` 사용.
- 알림 토큰 저장에 `Redis` 사용.
- 푸시 알림에 `Firebase` 사용.

### 당시 배포 흐름

```text
Frontend
GitHub -> AWS Amplify -> www.teamkip.info

Backend
GitHub -> GitHub Actions -> Docker Build -> Amazon ECR -> Amazon EKS -> server.teamkip.info

Supporting Services
S3 / OpenSearch / Redis / Firebase
```

### 회고
- 실제 클라우드 환경 배포 경험 확보.
- 외부 서비스 의존성이 높아 장기적인 `0원 포트폴리오 배포` 구조로는 유지비 부담 존재.

---

## 데모 버전 배포 방향

기존 핵심 기능 유지, 인프라 복잡도 축소 방향 권장.

### 추천 방향
- `Docker Compose + AWS Lightsail` 기반 단일 서버 배포.
- `Kubernetes/EKS` 대신 단일 인스턴스 중심 운영.
- 면접용 데모에 필요한 핵심 시나리오 중심 구성.

### 추천 이유
- 기존 AWS 배포 경험과 자연스럽게 연결되는 흐름.
- `EKS` 대비 배포 구조와 운영 난이도 대폭 축소.
- 백엔드, DB, 리버스 프록시를 한 번에 관리 가능한 구조.
- 데모 준비 속도와 유지 편의성 측면에서 현실적인 선택지.

### 권장 구성
- `Nginx` 또는 `Caddy`: 리버스 프록시, 도메인 연결, HTTPS 처리.
- `Spring Boot`: API 서버 컨테이너.
- `MariaDB`: 데모 데이터 저장용 DB 컨테이너.
- `Nuxt`: 정적 빌드 후 웹 서버에서 서빙하거나 별도 컨테이너로 운영.

### 데모용 단순화 기준
- 검색: `OpenSearch` 대신 DB 기반 검색 또는 제목/본문 단순 검색.
- 첨부파일: `S3` 대신 로컬 볼륨 기반 저장.
- 푸시 알림: `Firebase + Redis` 대신 비활성화 또는 인앱 알림만 유지.
- 배포: `Docker Compose`로 서비스 일괄 기동 및 관리.

### 우선 데모에서 보여줄 시나리오
1. 관리자 로그인
2. 사용자 생성
3. 그룹 생성 및 사용자 배치
4. 문서 작성 및 수정
5. 권한 요청 및 승인
6. 북마크 및 검색

### 판단
- 면접용 데모 관점에서는 좋은 방향.
- 장기 `0원` 운영 관점에서는 별도 무료 호스팅 구조 검토 필요.
- `Lightsail`은 데모용 현실적 선택지, `0원 포트폴리오용` 최종 해법과는 구분 필요.

---

## 프로젝트 자료

- 개발 히스토리: 프로젝트 진행 과정과 트러블슈팅 기록.
- 발표 자료: 전체 기능과 아키텍처를 빠르게 이해할 수 있는 문서.
- 피그마: UI 흐름과 화면 설계 참고 자료.

---

## 상세 자료 아카이브

<details>
<summary><b>조직 구성도 / WBS / 핵심기술</b></summary>

<br/>

#### 조직 구성도
<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KMS/assets/148752498/66bf55a1-e357-4f2c-8f24-f85c1e895be2">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KMS/assets/148752498/64a40d88-6eba-4dfa-a8c9-6f595811ed93">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KMS/assets/148752498/d2a61076-9508-42b6-8c7a-95ee573c1254">
</p>

#### WBS
<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/b15d6953-c466-446a-89d4-c21e84929911">
</p>

#### 핵심기술
![image](https://github.com/lifedesigner88/240314_Project_05_KIP/assets/123573918/8911b03e-bc47-4e60-ba74-a5413455ca10)

</details>

<details>
<summary><b>API 사양 캡처</b></summary>

<br/>

![image](https://github.com/user-attachments/assets/a2a2388b-5597-4af5-82bb-8195766b9dc2)

![image](https://github.com/user-attachments/assets/b2b38845-2e8d-495c-bbca-63c42fb7386a)

</details>

<details>
<summary><b>AWS 배포 캡처</b></summary>

<br/>

#### AWS Amplify 프론트엔드 배포
<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/08db9538-c8e8-41b0-b590-993435af17b0">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/e48e41c7-daf1-4640-b04a-97f45752c310">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/d18b4fde-d36f-4f2f-87d2-bdb202e10190">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/2c958c13-fb33-4913-8c35-562016b997c5">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/140cf7a3-ed06-416d-abb8-fff700738b70">
</p>

#### Amazon EKS 백엔드 배포
<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/c9c6b593-7e91-4e7a-afdb-1edb0473016a">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/81687fa8-4014-4009-b809-8f3eaba6dfa9">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/92ebec21-1c4e-47db-a5b9-2541dc0b700b">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/9d433654-b6ff-4e61-b774-631c4aa64f61">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/6c69aae9-c4b8-4a47-abfc-9704fb4a1afe">
</p>

</details>

<details>
<summary><b>tmp</b></summary>

<br/>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/00b01d93-a0ad-4fe1-8a6a-28e2c504b604">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/01431245-c6ac-4adc-a095-2f0be08b030d">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/01b2b78b-1d26-4915-b93f-5dffa1cb7f5e">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/07012c21-a3ac-4a41-8a7e-fad433e98a15">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/0a5d4af9-0ac1-47b7-b0eb-db6c54a61546">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/121a655e-27a9-452f-af99-69db8dec8a17">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/2008171b-f393-47f2-a874-f44f54ad844f">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/2609a4a2-59c7-452b-8f91-590608172240">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/295c787c-9abd-422b-a115-2869c3ae918b">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/3590e6e6-1091-4cb7-906e-1f5b42ab0e4b">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/39cffc5b-319c-450e-88eb-4e03def6443b">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/3b9e3b74-62d6-4f02-bde5-4f158883e0d4">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/3bdcbff8-c0a2-4a58-b7d3-f2030d04937c">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/40a3d5fe-74a8-4c02-914e-9b73d034478a">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/41bed38a-da35-4357-b2b4-c46823157113">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/44ef1e32-9f9a-4510-81a9-3579c337f065">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/452d84f8-65f5-4179-8834-5602afa96139">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/48f5830a-84aa-4889-97a1-ed659478d45a">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/49c05135-ff7c-49ee-af09-69a11ab2def6">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/51900586-4052-44bf-8a90-d3f7ce4e72ef">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/578c8a9b-24ca-44e9-9601-ad49b23b72b6">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/593212ab-6157-4466-a928-18ee33dc22ec">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/6c37120b-8017-4fe4-9209-ec665c4b4c4d">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/7b36c5b4-a2fd-4334-885c-945967e35063">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/7df3164b-6d23-4f33-9032-81887025aa64">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/7eabf38a-e1f4-449f-bd92-0427bc8d5687">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/7f1d726c-3d9d-49a6-bd63-52ca05dbfb2d">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8141176f-e103-44e1-8224-dc035e551a76">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8728d228-b7b6-4ca2-9fa2-1df4dcb406a7">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8784726d-8c86-4620-bdad-d02ea85ecfcf">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8aa3141f-58d7-46c2-bcfc-358cb4c4b969">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8d684f91-5b67-46ae-a17b-4074eb698695">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8dfc24c6-67c5-436d-87f3-8a99c686d952">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/8e628b1d-87a2-48fe-ba8e-524911313054">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/90ec9070-b97d-4ce8-a2e5-648ba4bd2601">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/965b5d1b-f76c-4cf1-b5d8-18effec3658c">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/ac2b9825-22c6-4d1d-b21b-ea284a960ca4">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/b4fdf432-1b6e-4dc9-96e7-a164f67552b1">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/bbbfd3c5-2501-4d28-a2ce-32d4cd9df086">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/c949e7b4-b989-46ca-bc28-e4ba477616c0">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/c995dc15-fbac-4b59-b62d-444a7a3bbce9">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/cab26644-06b9-49a0-89b2-fb5c9dc4b54d">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/cb3703ca-d26f-4522-96e6-00b00e719798">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/cbacc674-5584-4a6a-bc36-42b4e6a9563f">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/d7780c6c-2dda-44a1-8457-2531f15e614a">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/db89ce50-4014-4d35-afcf-1a69789d7b75">
</p>

<p align="center">
  <img src="https://github.com/beyond-sw-camp/be03-fin-5TEAM-KIP/assets/148752498/f7df9435-8dcc-4904-9f81-afcc429db4d4">
</p>

</details>
