SET NAMES utf8mb4;
SET SESSION max_recursive_iterations = 2000;
SET @seed_password_hash := '{bcrypt}$2a$10$wLJ8/V6Vn0no02U8hBtjquLjmk9P4JUxvim6.INyXqVbZE5rgYiwa';

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS tmp_seq;
CREATE TEMPORARY TABLE tmp_seq (
    n INT PRIMARY KEY
);

INSERT INTO tmp_seq (n)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 600
)
SELECT n FROM seq;

DROP TEMPORARY TABLE IF EXISTS tmp_surnames;
CREATE TEMPORARY TABLE tmp_surnames (
    ord INT PRIMARY KEY,
    surname VARCHAR(10) NOT NULL
);

INSERT INTO tmp_surnames (ord, surname) VALUES
    (1, '김'),
    (2, '이'),
    (3, '박'),
    (4, '최'),
    (5, '정'),
    (6, '강'),
    (7, '조'),
    (8, '윤'),
    (9, '장'),
    (10, '임'),
    (11, '한'),
    (12, '오'),
    (13, '서'),
    (14, '신'),
    (15, '권');

DROP TEMPORARY TABLE IF EXISTS tmp_given_names;
CREATE TEMPORARY TABLE tmp_given_names (
    ord INT PRIMARY KEY,
    given_name VARCHAR(20) NOT NULL
);

INSERT INTO tmp_given_names (ord, given_name) VALUES
    (1, '민준'),
    (2, '서준'),
    (3, '도윤'),
    (4, '하준'),
    (5, '지호'),
    (6, '현우'),
    (7, '시우'),
    (8, '주원'),
    (9, '예준'),
    (10, '건우'),
    (11, '서연'),
    (12, '지우'),
    (13, '하윤'),
    (14, '수아'),
    (15, '소윤'),
    (16, '지민'),
    (17, '채원'),
    (18, '윤서'),
    (19, '가온'),
    (20, '연우'),
    (21, '다온'),
    (22, '유나'),
    (23, '태윤'),
    (24, '세윤'),
    (25, '은호'),
    (26, '준호'),
    (27, '서진'),
    (28, '민서'),
    (29, '지안'),
    (30, '지율'),
    (31, '태경'),
    (32, '현서'),
    (33, '재윤'),
    (34, '규리'),
    (35, '나윤'),
    (36, '유진'),
    (37, '승현'),
    (38, '하린'),
    (39, '수빈'),
    (40, '정원');

DROP TEMPORARY TABLE IF EXISTS tmp_name_pool;
CREATE TEMPORARY TABLE tmp_name_pool AS
SELECT
    ROW_NUMBER() OVER (ORDER BY s.ord, g.ord) AS rn,
    CONCAT(s.surname, g.given_name) AS full_name
FROM tmp_surnames s
CROSS JOIN tmp_given_names g;

DROP TEMPORARY TABLE IF EXISTS tmp_brand_prefix;
CREATE TEMPORARY TABLE tmp_brand_prefix (
    ord INT PRIMARY KEY,
    prefix_name VARCHAR(30) NOT NULL
);

INSERT INTO tmp_brand_prefix (ord, prefix_name) VALUES
    (1, 'Aero'),
    (2, 'Nova'),
    (3, 'Flux'),
    (4, 'Signal'),
    (5, 'Orbit'),
    (6, 'Lumen'),
    (7, 'Clover'),
    (8, 'Bridge'),
    (9, 'Motive'),
    (10, 'Pulse'),
    (11, 'Vertex'),
    (12, 'Anchor'),
    (13, 'Near'),
    (14, 'Loop'),
    (15, 'Spark');

DROP TEMPORARY TABLE IF EXISTS tmp_brand_suffix;
CREATE TEMPORARY TABLE tmp_brand_suffix (
    ord INT PRIMARY KEY,
    suffix_name VARCHAR(30) NOT NULL
);

INSERT INTO tmp_brand_suffix (ord, suffix_name) VALUES
    (1, 'Care'),
    (2, 'Route'),
    (3, 'Desk'),
    (4, 'Mate'),
    (5, 'Track'),
    (6, 'Flow'),
    (7, 'Note'),
    (8, 'Scope'),
    (9, 'Pilot'),
    (10, 'Works');

DROP TEMPORARY TABLE IF EXISTS tmp_brand_pool;
CREATE TEMPORARY TABLE tmp_brand_pool AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.ord, s.ord) AS rn,
    CONCAT(p.prefix_name, s.suffix_name) AS service_name
FROM tmp_brand_prefix p
CROSS JOIN tmp_brand_suffix s;

DROP TEMPORARY TABLE IF EXISTS tmp_theme_catalog;
CREATE TEMPORARY TABLE tmp_theme_catalog (
    theme_id INT PRIMARY KEY,
    theme_name VARCHAR(100) NOT NULL,
    target_customer VARCHAR(255) NOT NULL,
    problem_statement VARCHAR(500) NOT NULL,
    core_feature VARCHAR(500) NOT NULL,
    ai_strategy VARCHAR(500) NOT NULL,
    architecture_stack VARCHAR(500) NOT NULL,
    revenue_model VARCHAR(500) NOT NULL,
    competitor_hint VARCHAR(500) NOT NULL,
    validation_metric VARCHAR(255) NOT NULL,
    tag1 VARCHAR(50) NOT NULL,
    tag2 VARCHAR(50) NOT NULL,
    tag3 VARCHAR(50) NOT NULL
);

INSERT INTO tmp_theme_catalog (
    theme_id,
    theme_name,
    target_customer,
    problem_statement,
    core_feature,
    ai_strategy,
    architecture_stack,
    revenue_model,
    competitor_hint,
    validation_metric,
    tag1,
    tag2,
    tag3
) VALUES
    (1, '모빌리티 운영 자동화', '지자체 교통약자 지원센터와 배차 담당자', '복지 이동 서비스는 예약과 배차 판단이 수기로 분산되어 배차 지연과 공차가 반복된다.', '실시간 수요판, 기사 스케줄 보드, 긴급 배차 추천', '배차 이력과 운행 패턴을 학습해 수요를 예측하고 경로를 추천한다.', 'Spring API, Vue 운영 대시보드, Python 추천 모듈, MariaDB, MinIO', '기관 구독형 SaaS와 차량 단위 추가 과금', '기존 전화 예약, 엑셀 배차, 단순 관제 솔루션', '배차 소요시간 30% 단축', '모빌리티', '운영자동화', '추천시스템'),
    (2, '헬스케어 코칭', '생활습관 개선이 필요한 직장인과 웰니스 코치', '건강 기록이 앱마다 흩어져 있어 행동 변화가 이어지지 않고 상담 준비 시간이 길다.', '건강 루틴 추천, 상담 전 요약 리포트, 주간 피드백', '생활 패턴과 상담 이력을 묶어 리스크 신호와 루틴 이탈 가능성을 분류한다.', 'Spring API, Python 분석 파이프라인, Vue 앱, MariaDB', '개인 구독과 기업 복지 패키지', '운동 기록 앱, 메신저 코칭, 단순 체크리스트 서비스', '4주 유지율 60% 달성', '헬스케어', 'AI', '데이터'),
    (3, '에듀테크 학습 코치', '부트캠프 운영진과 과제 관리 부담이 큰 학습자', '과제 피드백과 학습 진도 관리가 분산되어 개인 맞춤 개입 시점이 늦다.', '학습 대시보드, 과제 우선순위 추천, 학습 리포트', '학습 로그를 기반으로 이탈 위험과 복습 타이밍을 예측한다.', 'Nuxt 프론트, Spring API, Python 모델 서빙, MariaDB', '교육기관 라이선스와 팀 단위 구독', 'LMS, 과제 게시판, 단순 진도표 서비스', '주간 과제 제출률 20% 향상', '에듀테크', 'AI', 'SaaS'),
    (4, '접근성 우선 서비스', '시각 정보 접근이 어려운 사용자와 공공 서비스 운영자', '정보 접근성이 낮은 서비스는 핵심 기능 진입 전 이탈이 발생하고 민원이 누적된다.', '접근성 검사 보드, 대체 텍스트 가이드, 사용자 흐름 진단', '화면 구조와 문장 패턴을 분석해 접근성 위반 가능 구간을 우선순위로 정리한다.', 'Spring API, 접근성 규칙 엔진, Vue 대시보드, MariaDB', '공공기관 구축형 계약과 유지보수 패키지', '수동 접근성 점검, 외주 보고서, 일반 QA 도구', '주요 경로 접근성 이슈 50% 감소', '접근성', 'UX', '모바일'),
    (5, '로컬 커머스 운영', '지역 상점 운영자와 단골 고객', '로컬 상점은 고객 재방문 데이터를 축적하지 못해 프로모션 타이밍을 놓치기 쉽다.', '재방문 알림, 단골 고객 관리, 지역 이벤트 보드', '구매 이력과 방문 패턴을 바탕으로 재방문 시점과 상품 추천을 제안한다.', 'Vue 고객 앱, Spring API, 추천 배치, MariaDB', '상점 월 구독과 프로모션 발송 과금', '메신저 단골방, 수기 포인트 적립, 단순 쿠폰 앱', '월 재방문율 15% 개선', '로컬서비스', 'B2C', '온보딩'),
    (6, 'B2B 생산성 SaaS', '문서 승인 흐름이 복잡한 중소기업 운영팀', '결재와 후속 작업이 분리되어 문서 병목과 책임 공백이 자주 발생한다.', '업무 큐, 자동 리마인드, 승인 이후 실행 체크리스트', '업무 히스토리와 조직 패턴을 분석해 지연 가능 단계를 미리 알린다.', 'Spring API, Vue 워크스페이스, 이벤트 스케줄러, MariaDB', '사용자 수 기반 SaaS 과금', '전자결재, 협업 메신저, 스프레드시트 운영', '문서 처리 리드타임 25% 단축', '생산성', 'B2B', 'SaaS'),
    (7, '커뮤니티 매칭', '동아리 운영진과 관심사 기반 신규 사용자', '초기 커뮤니티는 관계 형성 신호가 약해 첫 주 이탈이 크게 발생한다.', '관심사 매칭, 첫 주 활동 미션, 추천 피드', '활동 로그와 대화 패턴을 분석해 관계 형성 가능성이 높은 조합을 추천한다.', 'Nuxt 앱, Spring API, 추천 서비스, MariaDB', '프리미엄 구독과 제휴 광고', '오픈채팅, 단순 게시판, 수동 운영 커뮤니티', '첫 주 활성 사용자 35% 확보', '커뮤니티', 'B2C', '추천시스템'),
    (8, '핀테크 리스크 모니터링', '소상공인 정산 운영팀과 재무 담당자', '정산 오류와 이상 거래를 늦게 발견하면 고객 신뢰와 운영 비용이 동시에 악화된다.', '정산 대시보드, 이상 거래 탐지, 이슈 티켓 관리', '거래 패턴과 이력 데이터를 조합해 이상 징후를 조기에 탐지한다.', 'Spring API, Python 이상 탐지, Vue 대시보드, MariaDB', '기업 계약형 라이선스와 분석 모듈 추가 과금', '수기 정산 검수, 범용 BI 도구, 단순 알림 서비스', '이상 거래 탐지 시간 70% 단축', '핀테크', '보안', '데이터'),
    (9, '제조 현장 관제', '소규모 제조사 생산 관리자와 현장 작업자', '설비 상태와 작업 지시가 분산되어 비가동 원인을 즉시 파악하기 어렵다.', '작업 현황판, 설비 알림, 생산 이슈 기록', '현장 이벤트를 학습해 비가동 패턴과 정비 우선순위를 제안한다.', 'Spring API, Vue 관제 화면, 이벤트 수집기, MariaDB', '공장 라인 단위 구독과 설치형 패키지', '화이트보드 관리, 메신저 보고, 범용 MES 일부 기능', '비가동 시간 18% 감소', '제조', '운영자동화', '데이터'),
    (10, 'HR 테크 채용 운영', '채용 담당자와 지원자 경험을 개선하려는 스타트업', '채용 단계별 커뮤니케이션이 분산되어 지원자 이탈과 평가 편차가 커진다.', '지원자 파이프라인, 면접 메모 요약, 평가 템플릿', '지원서와 면접 메모를 요약해 우선 검토 대상을 빠르게 정리한다.', 'Spring API, Vue 운영 콘솔, LLM 요약 모듈, MariaDB', '채용 파이프라인 구독형 SaaS', 'ATS, 메일 스레드, 스프레드시트 평가표', '서류 검토 시간 40% 단축', 'HR테크', 'B2B', 'AI'),
    (11, '여행 일정 운영', '지역 관광 운영사와 개별 여행자', '현지 일정 정보가 파편화되어 여행 전환율과 현장 만족도가 동시에 떨어진다.', '일정 추천, 현지 운영 보드, 일정 변경 알림', '이동 동선과 선호 데이터를 바탕으로 일정 후보를 개인화한다.', 'Nuxt 앱, Spring API, 일정 추천 로직, MariaDB', '여행 패스 제휴 수수료와 B2B 운영 도구 구독', '블로그 모음, 수기 일정표, OTA 기본 기능', '추천 일정 클릭률 25% 달성', '여행', '로컬서비스', '데이터'),
    (12, '푸드테크 매장 운영', '테이크아웃 매장 운영자와 반복 주문 고객', '주문 피크 시간과 재고 흐름을 예측하지 못해 품절과 대기시간 불만이 반복된다.', '피크타임 예측, 재고 경보, 고객 재주문 유도', '요일별 주문 패턴과 재고 데이터를 이용해 준비량과 쿠폰 타이밍을 제안한다.', 'Spring API, Vue 운영 보드, Python 예측 배치, MariaDB', '매장 월 구독과 주문 연동 수수료', 'POS 기본 통계, 수기 재고표, 쿠폰 발송 도구', '품절률 20% 감소', '푸드테크', '로컬서비스', '데이터'),
    (13, '펫케어 케어플랜', '반려동물 보호자와 돌봄 서비스 운영자', '건강 기록과 돌봄 이력이 연결되지 않아 보호자가 상태 변화를 놓치기 쉽다.', '케어 일정, 상태 기록, 보호자 안심 리포트', '이상 행동 기록과 건강 지표를 묶어 상담 우선순위와 루틴 변경 포인트를 제안한다.', 'Nuxt 앱, Spring API, 알림 엔진, MariaDB', '개인 구독과 제휴 병원 추천 수수료', '메신저 상담, 단순 캘린더 앱, 수기 돌봄 노트', '주간 기록 유지율 70% 확보', '펫케어', '커뮤니티', '헬스케어'),
    (14, '에너지 운영 분석', '건물 에너지 관리자와 설비 운영팀', '에너지 사용량과 설비 이벤트가 분산되어 절감 포인트를 제때 찾기 어렵다.', '이상 사용량 탐지, 설비 비교, 절감 과제 보드', '시간대 사용 패턴을 분석해 이상치와 절감 우선 구간을 탐지한다.', 'Spring API, Vue 대시보드, Python 분석 잡, MariaDB', '건물 단위 구독과 컨설팅 패키지', '엑셀 리포트, 계량기 수기 확인, 범용 BEMS 일부 기능', '월 전력 사용량 8% 절감', '에너지', '데이터', '운영자동화'),
    (15, '지식관리 워크스페이스', '프로젝트 문서를 체계화하려는 운영팀과 개발팀', '문서가 채널별로 흩어져 있어 최신 정보 확인과 권한 관리가 동시에 어렵다.', '문서 트리, 태그 검색, 권한 요청, 버전 기록', '문서 내용과 태그를 연결해 검색 우선순위와 추천 문서를 제안한다.', 'Spring API, Nuxt 웹, 태그 검색 로직, MariaDB, MinIO', '조직 단위 SaaS와 저장 용량 추가 과금', '폴더형 드라이브, 위키, 메신저 검색', '탐색 시간 40% 단축', '지식관리', 'RAG', 'SaaS');

DROP TEMPORARY TABLE IF EXISTS tmp_seed_users;
CREATE TEMPORARY TABLE tmp_seed_users (
    employee_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(255) NOT NULL,
    profile_image_url VARCHAR(255) NOT NULL,
    employed_day VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    user_kind VARCHAR(20) NOT NULL,
    user_seq INT NOT NULL,
    created_at DATETIME NOT NULL
);

INSERT INTO tmp_seed_users (
    employee_id, name, email, phone_number, profile_image_url, employed_day, role, user_kind, user_seq, created_at
) VALUES
    ('asm-0008', '서울센터 운영', 'seoul.ops@soma17.demo', '01050000008', 'https://picsum.photos/seed/asm-0008/400', '2026년 03월 24일', 'USER', 'OPS', 1, '2026-03-24 09:00:00'),
    ('asm-0009', '부산센터 운영', 'busan.ops@soma17.demo', '01050000009', 'https://picsum.photos/seed/asm-0009/400', '2026년 03월 24일', 'USER', 'OPS', 2, '2026-03-24 09:05:00'),
    ('asm-0010', '프로그램 운영', 'program.ops@soma17.demo', '01050000010', 'https://picsum.photos/seed/asm-0010/400', '2026년 03월 25일', 'USER', 'OPS', 3, '2026-03-25 09:00:00'),
    ('asm-0011', '데모데이 운영', 'demoday.ops@soma17.demo', '01050000011', 'https://picsum.photos/seed/asm-0011/400', '2026년 03월 25일', 'USER', 'OPS', 4, '2026-03-25 09:05:00'),
    ('asm-0012', '운영지원 매니저', 'ops.support@soma17.demo', '01050000012', 'https://picsum.photos/seed/asm-0012/400', '2026년 03월 26일', 'USER', 'OPS', 5, '2026-03-26 09:00:00'),
    ('asm-0013', '멘토링 코디네이터', 'mentoring.coordinator@soma17.demo', '01050000013', 'https://picsum.photos/seed/asm-0013/400', '2026년 03월 26일', 'USER', 'OPS', 6, '2026-03-26 09:05:00'),
    ('asm-0014', '투자연계 매니저', 'investment.manager@soma17.demo', '01050000014', 'https://picsum.photos/seed/asm-0014/400', '2026년 03월 27일', 'USER', 'OPS', 7, '2026-03-27 09:00:00'),
    ('asm-0015', '성과확산 매니저', 'impact.manager@soma17.demo', '01050000015', 'https://picsum.photos/seed/asm-0015/400', '2026년 03월 27일', 'USER', 'OPS', 8, '2026-03-27 09:05:00');

INSERT INTO tmp_seed_users (
    employee_id, name, email, phone_number, profile_image_url, employed_day, role, user_kind, user_seq, created_at
)
SELECT
    CONCAT('asm-', LPAD(15 + s.n, 4, '0')) AS employee_id,
    CONCAT(np.full_name, ' 멘토') AS name,
    CONCAT('mentor', LPAD(s.n, 3, '0'), '@soma17.demo') AS email,
    CONCAT('0106', LPAD(s.n, 7, '0')) AS phone_number,
    CONCAT('https://picsum.photos/seed/', CONCAT('asm-', LPAD(15 + s.n, 4, '0')), '/400') AS profile_image_url,
    DATE_FORMAT(DATE_ADD('2026-03-28', INTERVAL s.n DAY), '%Y년 %m월 %d일') AS employed_day,
    'USER' AS role,
    'MENTOR' AS user_kind,
    s.n AS user_seq,
    DATE_ADD('2026-03-28 09:00:00', INTERVAL s.n DAY) AS created_at
FROM tmp_seq s
JOIN tmp_name_pool np ON np.rn = s.n + 450
WHERE s.n <= 150;

INSERT INTO tmp_seed_users (
    employee_id, name, email, phone_number, profile_image_url, employed_day, role, user_kind, user_seq, created_at
)
SELECT
    CONCAT('asm-', LPAD(165 + s.n, 4, '0')) AS employee_id,
    np.full_name AS name,
    CONCAT('trainee', LPAD(s.n, 3, '0'), '@soma17.demo') AS email,
    CONCAT('0107', LPAD(s.n, 7, '0')) AS phone_number,
    CONCAT('https://picsum.photos/seed/', CONCAT('asm-', LPAD(165 + s.n, 4, '0')), '/400') AS profile_image_url,
    DATE_FORMAT(
        DATE_ADD(
            CASE WHEN s.n <= 300 THEN '2026-04-07' ELSE '2026-05-12' END,
            INTERVAL ((s.n - 1) MOD 45) DAY
        ),
        '%Y년 %m월 %d일'
    ) AS employed_day,
    'USER' AS role,
    'TRAINEE' AS user_kind,
    s.n AS user_seq,
    DATE_ADD(
        CASE WHEN s.n <= 300 THEN '2026-04-07 09:00:00' ELSE '2026-05-12 09:00:00' END,
        INTERVAL ((s.n - 1) MOD 60) DAY
    ) AS created_at
FROM tmp_seq s
JOIN tmp_name_pool np ON np.rn = s.n
WHERE s.n <= 450;

INSERT INTO `user` (
    created_at,
    updated_at,
    email,
    employed_day,
    employee_id,
    name,
    password,
    phone_number,
    profile_image_url,
    role
)
SELECT
    su.created_at,
    su.created_at,
    su.email,
    su.employed_day,
    su.employee_id,
    su.name,
    @seed_password_hash,
    su.phone_number,
    su.profile_image_url,
    su.role
FROM tmp_seed_users su
WHERE NOT EXISTS (
    SELECT 1
    FROM `user` u
    WHERE u.employee_id = su.employee_id
);

UPDATE `user`
SET password = @seed_password_hash
WHERE employee_id IN (
    'asm-1234', 'asm-0001', 'asm-0002', 'asm-0003', 'asm-0004', 'asm-0005', 'asm-0006', 'asm-0007',
    'asm-0008', 'asm-0009', 'asm-0010', 'asm-0011', 'asm-0012', 'asm-0013', 'asm-0014', 'asm-0015'
);

INSERT INTO `group` (
    created_at,
    updated_at,
    group_name,
    group_type,
    super_group_id
)
SELECT
    '2026-04-01 09:00:00',
    '2026-04-01 09:00:00',
    '제17기 운영',
    'DEPARTMENT',
    root_group.id
FROM (
    SELECT MIN(id) AS id
    FROM `group`
    WHERE group_name = 'AI SW 마에스트로'
) root_group
WHERE root_group.id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM `group` g
      WHERE g.group_name = '제17기 운영'
        AND g.super_group_id = root_group.id
  );

INSERT INTO `group` (
    created_at,
    updated_at,
    group_name,
    group_type,
    super_group_id
)
SELECT
    '2026-04-02 09:00:00',
    '2026-04-02 09:00:00',
    center_seed.group_name,
    'DEPARTMENT',
    op_group.id
FROM (
    SELECT '서울센터' AS group_name
    UNION ALL
    SELECT '부산센터' AS group_name
) center_seed
JOIN `group` op_group ON op_group.group_name = '제17기 운영'
WHERE NOT EXISTS (
    SELECT 1
    FROM `group` g
    WHERE g.group_name = center_seed.group_name
      AND g.super_group_id = op_group.id
);

DROP TEMPORARY TABLE IF EXISTS tmp_team_plan;
CREATE TEMPORARY TABLE tmp_team_plan AS
SELECT
    s.n AS team_seq,
    CASE WHEN s.n <= 100 THEN 'SEOUL' ELSE 'BUSAN' END AS center_code,
    CASE WHEN s.n <= 100 THEN '서울센터' ELSE '부산센터' END AS center_group_name,
    CASE WHEN s.n <= 100 THEN CONCAT('서울 17기 ', LPAD(s.n, 3, '0'), '팀')
         ELSE CONCAT('부산 17기 ', LPAD(s.n - 100, 3, '0'), '팀')
    END AS team_group_name,
    CASE WHEN s.n <= 100 THEN s.n ELSE s.n - 100 END AS local_team_no,
    bp.service_name,
    ((s.n - 1) MOD 15) + 1 AS theme_id,
    CONCAT('asm-', LPAD(165 + ((s.n - 1) * 3) + 1, 4, '0')) AS student1_employee_id,
    CONCAT('asm-', LPAD(165 + ((s.n - 1) * 3) + 2, 4, '0')) AS student2_employee_id,
    CONCAT('asm-', LPAD(165 + ((s.n - 1) * 3) + 3, 4, '0')) AS student3_employee_id,
    CONCAT('asm-', LPAD(15 + s.n, 4, '0')) AS mentor1_employee_id,
    CONCAT('asm-', LPAD(15 + (((s.n + 49) MOD 150) + 1), 4, '0')) AS mentor2_employee_id,
    CONCAT('asm-', LPAD(15 + (((s.n + 99) MOD 150) + 1), 4, '0')) AS mentor3_employee_id
FROM tmp_seq s
JOIN tmp_brand_pool bp ON bp.rn = s.n
WHERE s.n <= 150;

INSERT INTO `group` (
    created_at,
    updated_at,
    group_name,
    group_type,
    super_group_id
)
SELECT
    DATE_ADD('2026-04-03 09:00:00', INTERVAL tp.team_seq HOUR),
    DATE_ADD('2026-04-03 09:00:00', INTERVAL tp.team_seq HOUR),
    tp.team_group_name,
    'BUSINESS',
    center_group.id
FROM tmp_team_plan tp
JOIN `group` center_group ON center_group.group_name = tp.center_group_name
WHERE NOT EXISTS (
    SELECT 1
    FROM `group` g
    WHERE g.group_name = tp.team_group_name
      AND g.super_group_id = center_group.id
);

INSERT IGNORE INTO group_user (
    created_at,
    updated_at,
    group_role,
    user_id,
    group_id
)
SELECT
    '2026-04-01 09:30:00',
    '2026-04-01 09:30:00',
    membership.group_role,
    u.id,
    g.id
FROM (
    SELECT '제17기 운영' AS group_name, 'asm-1234' AS employee_id, 'SUPER' AS group_role
    UNION ALL SELECT '제17기 운영', 'asm-0010', 'SUPER'
    UNION ALL SELECT '제17기 운영', 'asm-0011', 'NORMAL'
    UNION ALL SELECT '제17기 운영', 'asm-0013', 'NORMAL'
    UNION ALL SELECT '서울센터', 'asm-1234', 'SUPER'
    UNION ALL SELECT '서울센터', 'asm-0008', 'SUPER'
    UNION ALL SELECT '서울센터', 'asm-0013', 'NORMAL'
    UNION ALL SELECT '부산센터', 'asm-1234', 'SUPER'
    UNION ALL SELECT '부산센터', 'asm-0009', 'SUPER'
    UNION ALL SELECT '부산센터', 'asm-0013', 'NORMAL'
) membership
JOIN `group` g ON g.group_name = membership.group_name
JOIN `user` u ON u.employee_id = membership.employee_id;

INSERT IGNORE INTO group_user (
    created_at,
    updated_at,
    group_role,
    user_id,
    group_id
)
SELECT
    DATE_ADD('2026-04-07 09:00:00', INTERVAL tp.team_seq MINUTE),
    DATE_ADD('2026-04-07 09:00:00', INTERVAL tp.team_seq MINUTE),
    'NORMAL',
    u.id,
    g.id
FROM tmp_team_plan tp
JOIN `group` g ON g.group_name = tp.team_group_name
JOIN `user` u ON u.employee_id IN (tp.student1_employee_id, tp.student2_employee_id, tp.student3_employee_id);

INSERT IGNORE INTO group_user (
    created_at,
    updated_at,
    group_role,
    user_id,
    group_id
)
SELECT
    DATE_ADD('2026-04-07 10:00:00', INTERVAL mentor_map.team_seq MINUTE),
    DATE_ADD('2026-04-07 10:00:00', INTERVAL mentor_map.team_seq MINUTE),
    mentor_map.group_role,
    u.id,
    g.id
FROM (
    SELECT team_seq, team_group_name, mentor1_employee_id AS employee_id, 'SUPER' AS group_role FROM tmp_team_plan
    UNION ALL
    SELECT team_seq, team_group_name, mentor2_employee_id AS employee_id, 'NORMAL' AS group_role FROM tmp_team_plan
    UNION ALL
    SELECT team_seq, team_group_name, mentor3_employee_id AS employee_id, 'NORMAL' AS group_role FROM tmp_team_plan
) mentor_map
JOIN `group` g ON g.group_name = mentor_map.team_group_name
JOIN `user` u ON u.employee_id = mentor_map.employee_id;

DROP TEMPORARY TABLE IF EXISTS tmp_public_docs;
CREATE TEMPORARY TABLE tmp_public_docs (
    doc_no INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_employee_id VARCHAR(20) NOT NULL,
    tag_set VARCHAR(50) NOT NULL,
    summary TEXT NOT NULL,
    audience TEXT NOT NULL,
    highlight_1 TEXT NOT NULL,
    highlight_2 TEXT NOT NULL,
    highlight_3 TEXT NOT NULL
);

INSERT INTO tmp_public_docs (
    doc_no, title, author_employee_id, tag_set, summary, audience, highlight_1, highlight_2, highlight_3
) VALUES
    (1, '서울센터 오리엔테이션 운영안', 'asm-0008', 'ORIENTATION', '서울센터 300명 연수생이 첫 주에 필요한 흐름과 안내 채널을 한 번에 이해할 수 있게 정리한 운영 문서다.', '센터 운영진, 멘토, 신규 연수생', '첫 3일 온보딩 동선을 체크리스트 형태로 나눈다.', '멘토 만남, 팀 빌딩, 계정 발급 시간을 분리한다.', '운영 문의 채널과 응답 SLA를 함께 적는다.'),
    (2, '부산센터 오리엔테이션 운영안', 'asm-0009', 'ORIENTATION', '부산센터 150명 연수생 기준으로 공간 안내와 예비 과정 출석 흐름을 정리한 문서다.', '부산센터 운영진, 멘토, 신규 연수생', '센터 출입과 장비 수령 절차를 한 화면에서 확인하게 한다.', '오프라인 데스크 문의 시간을 명시한다.', '지역 협력기관 일정과 센터 운영 시간을 같이 적는다.'),
    (3, '예비 과정 주간 로드맵', 'asm-0010', 'CURRICULUM', '예비 과정에서 팀 빌딩과 문제정의, 고객 인터뷰 준비가 어떤 순서로 진행되는지 보여주는 주간 로드맵이다.', '프로그램 운영진, 연수생', '1주차는 문제정의와 팀 빌딩에 집중한다.', '2주차는 고객 인터뷰와 경쟁 분석에 집중한다.', '3주차는 MVP 범위 정의와 피드백 정리에 집중한다.'),
    (4, '본 과정 운영 일정', 'asm-0010', 'CURRICULUM', '본 과정에 들어간 이후 멘토링, 스프린트 리뷰, 데모데이 준비까지의 운영 캘린더를 정리한 문서다.', '운영진, 멘토, 팀 리더', '월간 리뷰와 중간 점검 일정을 분리해서 잡는다.', '센터별 오프라인 세션과 온라인 멘토링을 병행한다.', '데모데이 준비는 마지막 6주 동안 별도 트랙으로 운영한다.'),
    (5, '멘토링 운영 기준', 'asm-0013', 'MENTORING', '멘토 1인당 최대 3팀을 담당하는 구조에서 피드백 밀도를 유지하기 위한 운영 기준이다.', '멘토링 코디네이터, 멘토', '멘토 미팅은 주간 아젠다와 회의록을 남겨야 한다.', '기술 피드백과 사업 피드백을 한 문서에서 분리해 기록한다.', '다음 액션 아이템을 팀별로 3개 이하로 정리한다.'),
    (6, '프로젝트 활동비 사용 가이드', 'asm-0012', 'MONEY', '프로젝트 활동비 집행 시 연수생 팀이 지켜야 할 신청과 정산 흐름을 정리한 문서다.', '연수생, 운영지원 매니저', '지출 목적과 실험 가설을 먼저 적는다.', '영수증과 집행 결과를 같은 주에 등록한다.', '공용 소프트웨어와 개별 장비 예외 규정을 구분한다.'),
    (7, 'IT기기 지원 체크리스트', 'asm-0012', 'ORIENTATION', '노트북, 테스트 기기, 촬영 장비 등 프로그램 공용 장비를 대여할 때 필요한 체크리스트다.', '연수생, 운영진', '대여 기간과 사용 목적을 먼저 등록한다.', '분실과 파손 대응 기준을 문서 하단에 고정한다.', '반납 시 초기화와 계정 로그아웃 절차를 함께 적는다.'),
    (8, '데모데이 발표 가이드', 'asm-0011', 'DEMODAY', '면접관과 외부 심사위원이 빠르게 이해할 수 있는 데모데이 발표 구성 기준을 정리한 문서다.', '데모데이 운영진, 팀 발표자', '문제, 고객, 해결책, 지표, 다음 계획 순으로 발표를 구성한다.', '기술 시연은 3분 이내로 잘라 핵심만 보여준다.', '질의응답에서 투자 포인트와 실행력 근거를 함께 설명한다.'),
    (9, 'IR Deck 작성 팁', 'asm-0014', 'DEMODAY', '초기 창업팀이 투자자 관점으로 자료를 재구성할 때 빠지기 쉬운 항목을 정리한 문서다.', '투자연계 매니저, 팀 리더', '문제 크기와 고객 세그먼트를 먼저 정의한다.', '차별점은 기능 나열보다 실행 데이터로 설명한다.', '향후 6개월 계획을 팀 역량과 연결해서 적는다.'),
    (10, '고객 인터뷰 가이드', 'asm-0013', 'RESEARCH', '실사용자 인터뷰를 준비하는 팀이 질문 순서와 정리 방식에서 실수하지 않도록 만든 문서다.', '연수생, 멘토', '문제 경험을 묻는 질문을 먼저 배치한다.', '가설 검증 질문과 솔루션 반응 질문을 분리한다.', '인터뷰 직후 인사이트와 반례를 같은 문서에 적는다.'),
    (11, 'MVP 범위 정의 방법', 'asm-0013', 'GROWTH', '예비 과정에서 기능 욕심을 줄이고 핵심 검증 포인트만 남기는 기준을 설명하는 문서다.', '연수생, PM 역할 팀원', '고객 행동 변화를 확인할 핵심 기능 한두 개만 남긴다.', '운영 자동화보다 수기 운영이 빠른 부분은 과감히 남겨 둔다.', '배포 가능한 범위를 2주 단위로 끊어본다.'),
    (12, 'AI 윤리 점검표', 'asm-0015', 'COMPLIANCE', 'AI 기능을 포함한 팀이 데이터 수집과 결과 제공 방식에서 꼭 점검해야 할 기준을 모은 문서다.', '연수생, 멘토, 운영진', '민감정보와 비민감정보를 분리해서 다룬다.', 'AI 결과의 오판 가능성과 대응 문구를 적는다.', '사람 검토가 필요한 구간을 화면 흐름에 명시한다.'),
    (13, '개인정보 처리 체크리스트', 'asm-0015', 'COMPLIANCE', '서비스 기획 단계에서 개인정보를 다루는 팀이 최소한으로 지켜야 할 수집과 보관 기준을 정리한 문서다.', '연수생, 멘토', '수집 항목을 꼭 필요한 수준으로 줄인다.', '보관 기간과 삭제 흐름을 화면과 문서에 함께 남긴다.', '외부 도구로 전송되는 데이터 범위를 검토한다.'),
    (14, '접근성 우선 설계 기준', 'asm-0015', 'COMPLIANCE', '모바일과 웹 MVP를 동시에 다루는 팀이 접근성 우선순위를 빠르게 판단할 수 있게 만든 문서다.', '기획자, 디자이너, 프론트엔드 역할 팀원', '명도 대비와 초점 이동을 우선 점검한다.', '대체 텍스트와 키보드 이동 경로를 체크한다.', '음성 안내가 필요한 화면을 따로 표시한다.'),
    (15, '창업팀 협업 규칙', 'asm-0010', 'ORIENTATION', '3인 팀과 멘토 3명이 함께 움직일 때 협업 리듬이 무너지지 않도록 만든 공통 규칙 문서다.', '모든 연수생과 멘토', '의사결정 로그를 한 문서에 모은다.', '회의록은 24시간 안에 정리한다.', '역할 충돌이 있으면 다음 스프린트 전에 바로 조정한다.'),
    (16, '주간 스프린트 회고 템플릿', 'asm-0010', 'CURRICULUM', '팀이 매주 무엇을 시도했고 어떤 가설이 틀렸는지 빠르게 정리할 수 있는 회고 템플릿이다.', '연수생, 멘토', '시도한 실험과 지표 결과를 분리해서 적는다.', '계속할 일과 중단할 일을 명확히 남긴다.', '다음 주 우선순위를 3개 이하로 정리한다.'),
    (17, '문제정의 워크숍 정리법', 'asm-0013', 'RESEARCH', '초기 문제정의 세션 후 흩어진 메모를 한 장의 문서로 구조화하는 방법을 설명한다.', 'PM, PO 역할 팀원', '관찰 사실과 해석을 구분해서 정리한다.', '문제 빈도와 해결 비용을 같이 적는다.', '팀 내부 공감대를 만들 문장을 마지막에 남긴다.'),
    (18, '실사용자 인터뷰 질문 예시', 'asm-0013', 'RESEARCH', '문제 경험, 현재 대안, 지불 의사까지 자연스럽게 이어지는 질문 예시를 담은 문서다.', '연수생, 멘토', '현재 대안을 묻는 질문을 중반에 배치한다.', '답을 유도하는 표현을 피한다.', '인터뷰 종료 후 다음 행동을 물어본다.'),
    (19, '초기 지표 설계 가이드', 'asm-0014', 'GROWTH', '사용자 수가 많지 않은 초기 단계에서 무엇을 지표로 볼지 정리한 실무형 가이드다.', '팀 리더, 데이터 담당', '허무 지표 대신 행동 지표를 먼저 본다.', '실험 목표와 지표를 한 화면에 정리한다.', '주 단위로 비교 가능한 최소 샘플 크기를 적는다.'),
    (20, '온보딩 흐름 설계 메모', 'asm-0166', 'GROWTH', '사용자가 처음 들어와 핵심 가치를 이해하기까지의 문턱을 줄이기 위한 설계 메모다.', '기획자, 디자이너', '첫 행동을 1분 안에 끝내게 설계한다.', '가입 직후 얻는 보상을 명확히 보여준다.', '정보 요청은 단계적으로 나눈다.'),
    (21, 'B2B 제안서 핵심 구성', 'asm-0014', 'GROWTH', '기관과 기업 고객을 상대하는 팀이 초기에 어떤 장표 구성을 가져가야 하는지 설명한다.', 'B2B 성격 팀, 투자연계 매니저', '고객 문제와 조직 리스크를 먼저 적는다.', '도입 전후 업무 흐름 차이를 그림으로 보여준다.', '계약 이후 운영 비용 절감 효과를 숫자로 적는다.'),
    (22, 'B2C 커뮤니티 운영 기준', 'asm-0167', 'GROWTH', '초기 사용자 커뮤니티를 만들 때 운영 규칙과 활성화 장치를 어떻게 설계할지 정리한 문서다.', 'B2C 팀 운영자', '첫 주 환영 흐름을 자동화한다.', '신규 사용자가 바로 참여할 미션을 둔다.', '운영 가이드와 제재 기준을 분리해서 적는다.'),
    (23, '데이터 수집 동의 문구 샘플', 'asm-0015', 'COMPLIANCE', '실험 초기 단계에서 팀이 참고할 수 있는 데이터 수집 동의 문구 예시를 담은 문서다.', '기획자, 프론트엔드, 운영진', '문구는 서비스 맥락에 맞게 짧게 적는다.', '보관 기간과 철회 방법을 함께 적는다.', '제3자 제공 여부를 쉽게 구분하게 만든다.'),
    (24, '프롬프트 실험 기록 템플릿', 'asm-0016', 'TECH', 'LLM 실험을 반복하는 팀이 입력, 결과, 비용, 실패 사례를 함께 추적하도록 만든 템플릿이다.', 'AI 기능을 다루는 팀', '프롬프트 버전을 날짜와 함께 남긴다.', '실패 응답과 예외 조건을 따로 적는다.', '비용과 성공률을 함께 기록한다.'),
    (25, '추천 품질 검증 기준', 'asm-0017', 'TECH', '추천 로직을 쓰는 팀이 오프라인 검증과 실제 사용성 검증을 함께 설계할 수 있게 만든 문서다.', '추천 기능 담당 팀, 멘토', '정답률과 체감 품질을 분리해서 본다.', '노출 다양성과 반복 노출 비율을 함께 본다.', '실험군과 비교군 차이를 작은 샘플로 먼저 본다.'),
    (26, 'RAG PoC 설계 팁', 'asm-0030', 'TECH', '문서 검색 기반 기능을 처음 시도하는 팀이 검색 품질과 응답 속도 사이 균형을 잡게 돕는 문서다.', '지식관리, 고객지원, 검색 기능 팀', '문서 청크 기준을 먼저 정한다.', '정확도보다 실패 케이스 분류를 먼저 만든다.', '검색 로그와 답변 로그를 분리해서 저장한다.'),
    (27, '비용 절감형 LLM 운영 전략', 'asm-0018', 'TECH', '모델 호출 비용이 빠르게 커지는 팀이 기능 품질을 유지하며 비용을 줄이는 방법을 정리한 문서다.', 'AI 기능 담당 팀, 운영진', '고비용 호출이 필요한 구간만 남긴다.', '캐시와 규칙 기반 처리 범위를 넓힌다.', '실패율이 높은 요청 유형을 먼저 분리한다.'),
    (28, '서버 아키텍처 리뷰 체크리스트', 'asm-0019', 'TECH', '백엔드와 인프라 결정을 할 때 놓치기 쉬운 데이터 흐름과 장애 포인트를 점검하는 문서다.', '백엔드 역할 팀원, 기술 멘토', '인증과 권한 경계를 먼저 점검한다.', '저장소와 비동기 처리 경로를 도식화한다.', '비용이 큰 병목 지점을 로그 기준으로 확인한다.'),
    (29, '관제 자동화 아이디어 모음', 'asm-0020', 'TECH', '운영자동화 계열 팀이 문제를 찾을 때 참고할 수 있는 관제 자동화 아이디어를 정리한 문서다.', '운영자동화 팀, 멘토', '반복 알림보다 이상 패턴 탐지를 우선한다.', '사람이 마지막 승인하는 구간을 남긴다.', '현장 운영자가 바로 쓸 수 있는 화면 단위를 먼저 설계한다.'),
    (30, '로컬 서비스 PMF 인터뷰 기록', 'asm-0168', 'RESEARCH', '지역 기반 서비스를 준비하는 팀이 실제 인터뷰에서 어떤 반응을 얻었는지 참고할 수 있는 사례 문서다.', '로컬서비스 팀', '재방문 빈도와 대체 수단을 먼저 묻는다.', '단골 고객과 신규 고객 반응을 분리해서 본다.', '지역 행사와 연결되는 니즈를 별도로 적는다.'),
    (31, '웰니스 서비스 개인정보 주의점', 'asm-0015', 'COMPLIANCE', '건강과 생활습관 데이터를 다루는 팀이 놓치기 쉬운 개인정보 이슈를 정리한 문서다.', '헬스케어 팀, 멘토', '민감정보 여부를 먼저 분류한다.', '상담 기록과 행동 데이터 저장 범위를 나눈다.', '외부 공유 시 비식별 규칙을 먼저 정한다.'),
    (32, '에듀테크 학습데이터 지표 초안', 'asm-0169', 'RESEARCH', '학습 행동 데이터를 수집하는 팀이 초기에 추적할 지표를 정리한 초안 문서다.', '에듀테크 팀, 데이터 담당', '학습 지속성과 성취를 분리해서 본다.', '도움 요청과 과제 제출을 같은 지표로 묶지 않는다.', '학습 개입 후 행동 변화까지 추적한다.'),
    (33, '접근성 우선 MVP 설계 사례', 'asm-0016', 'COMPLIANCE', '접근성 이슈를 뒤로 미루지 않고 MVP 단계에서 반영한 사례를 정리한 문서다.', '기획자, 프론트엔드 역할 팀원', '핵심 경로부터 접근성 개선을 시작한다.', '대체 텍스트와 명도 대비를 동시에 확인한다.', '실사용자 피드백을 점검 항목에 넣는다.'),
    (34, '모빌리티 운영 대시보드 요구사항', 'asm-0021', 'TECH', '배차와 현장 이슈를 다루는 모빌리티 팀이 운영 대시보드에 담아야 할 요구사항을 정리한 문서다.', '모빌리티 팀, 기술 멘토', '긴급 이슈와 일반 상태를 한눈에 분리해서 보여준다.', '배차 추천 근거를 함께 노출한다.', '운영자가 바로 수정할 수 있는 액션 버튼을 둔다.'),
    (35, 'SaaS 전환율 개선 아이디어', 'asm-0170', 'GROWTH', '무료 체험에서 유료 전환까지 이어지는 흐름을 개선하기 위한 아이디어를 정리한 문서다.', 'SaaS 성격 팀, PM 역할 팀원', '첫 성공 경험까지 걸리는 시간을 줄인다.', '기능 설명보다 결과 예시를 먼저 보여준다.', '이탈 구간별 가설을 한 문서에서 관리한다.'),
    (36, '멘토 피드백 반영 회의록 샘플', 'asm-0022', 'MENTORING', '멘토 피드백을 받은 뒤 어떤 방식으로 실행 계획으로 전환하는지 보여주는 샘플 회의록이다.', '멘토, 팀 리더', '피드백 원문과 실행 계획을 분리해서 적는다.', '책임자와 완료 시점을 꼭 남긴다.', '다음 미팅 전 확인할 검증 결과를 함께 적는다.'),
    (37, '데모데이 리허설 운영안', 'asm-0011', 'DEMODAY', '데모데이 직전 리허설을 어떻게 운영할지 시간표와 체크리스트 기준으로 정리한 문서다.', '데모데이 운영진, 발표 팀', '입장 동선과 장비 점검 순서를 먼저 정한다.', '발표 시간과 질의응답 시간을 엄격히 자른다.', '장애 상황 대체 플로우를 미리 적어 둔다.'),
    (38, '투자자 FAQ 초안', 'asm-0014', 'DEMODAY', '초기 팀이 자주 받는 질문을 미리 정리해 IR 준비 속도를 높이기 위한 문서다.', '투자연계 매니저, 팀 리더', '시장 크기와 진입 방식 답변을 먼저 준비한다.', '경쟁 우위와 실행 속도를 수치와 연결한다.', '향후 12개월 목표를 현실적으로 적는다.'),
    (39, '프로그램 홍보용 성과 정리', 'asm-0015', 'DEMODAY', '센터별 프로젝트 성과와 운영 지표를 한 장으로 요약해 외부 홍보 자료에 활용하기 위한 문서다.', '운영진, 대외협력 담당', '프로젝트 수와 인터뷰 건수를 함께 정리한다.', '투자연계와 PoC 성과를 분리해서 적는다.', '센터별 특성을 짧게 비교한다.'),
    (40, '종료보고서 작성 가이드', 'asm-0010', 'CURRICULUM', '과정 종료 시 팀이 남겨야 할 핵심 기록과 회고 항목을 정리한 문서다.', '연수생, 운영진', '문제와 해결책 변화를 시간순으로 정리한다.', '고객 반응과 지표 결과를 같이 적는다.', '다음 단계 실행 계획을 3개 이하로 남긴다.');

DROP TEMPORARY TABLE IF EXISTS tmp_seed_docs;
CREATE TEMPORARY TABLE tmp_seed_docs (
    doc_scope VARCHAR(20) NOT NULL,
    group_name VARCHAR(255) NULL,
    title VARCHAR(255) NOT NULL,
    kms_doc_type VARCHAR(20) NOT NULL,
    sort_order INT NULL,
    writer_employee_id VARCHAR(20) NOT NULL,
    category_code VARCHAR(50) NOT NULL,
    tag_set VARCHAR(50) NULL,
    theme_id INT NULL,
    created_at DATETIME NOT NULL,
    content TEXT NOT NULL
);

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
) VALUES
    ('GROUP', '제17기 운영', '제17기 운영 허브', 'SECTION', 1, 'asm-0010', 'TEAM_HOME', 'ORIENTATION', NULL, '2026-04-01 10:00:00', '<h2>제17기 운영 허브</h2><p>AI SW 마에스트로 17기 운영의 전체 흐름과 센터 구조를 한 번에 보여주는 허브 문서다.</p><ul><li>서울센터 300명, 부산센터 150명 기준으로 운영한다.</li><li>예비 과정은 문제정의와 팀 빌딩에, 본 과정은 제품 검증과 데모데이에 집중한다.</li><li>운영팀은 멘토링, 활동비, 발표 지원 흐름을 문서 단위로 관리한다.</li></ul>'),
    ('GROUP', '제17기 운영', '17기 운영 로드맵', 'CONTENT', 2, 'asm-0010', 'SERVICE', 'CURRICULUM', NULL, '2026-04-01 10:05:00', '<h2>17기 운영 로드맵</h2><p>예비 과정에서 팀과 문제를 정리하고, 본 과정에서 MVP와 고객 검증을 반복한 뒤 데모데이로 연결하는 운영 로드맵이다.</p><ul><li>4월과 5월은 고객 인터뷰와 팀 정합성 확보에 집중한다.</li><li>6월 이후는 MVP 배포와 피드백 수집을 중심으로 스프린트를 운영한다.</li><li>10월 이후는 발표 자료와 투자 연계 준비 비중을 높인다.</li></ul>'),
    ('GROUP', '제17기 운영', '센터 운영 기준', 'CONTENT', 3, 'asm-0008', 'SERVICE', 'ORIENTATION', NULL, '2026-04-01 10:10:00', '<h2>센터 운영 기준</h2><p>서울센터와 부산센터가 동일한 기준으로 출석, 공지, 공간 운영, 운영 문의를 처리하도록 만든 문서다.</p><ul><li>센터별 특성을 반영하되 공통 KPI와 문서 양식은 통일한다.</li><li>오프라인 운영 이슈는 당일 기록하고 주간 회의에서 재발 방지안을 정리한다.</li><li>센터 공지는 공개 문서와 그룹 문서를 병행해 남긴다.</li></ul>'),
    ('GROUP', '제17기 운영', '멘토링 운영 기준', 'CONTENT', 4, 'asm-0013', 'BUSINESS', 'MENTORING', NULL, '2026-04-01 10:15:00', '<h2>멘토링 운영 기준</h2><p>멘토 1인당 최대 3팀을 맡는 구조에서 피드백 밀도와 운영 가시성을 유지하기 위한 기준이다.</p><ul><li>모든 팀은 최소 주 1회 멘토링 로그를 남긴다.</li><li>기술과 사업 피드백은 각각 액션 아이템으로 전환한다.</li><li>센터 운영진은 월 1회 멘토링 품질을 점검한다.</li></ul>'),
    ('GROUP', '제17기 운영', '데모데이 준비 일정', 'CONTENT', 5, 'asm-0011', 'BUSINESS', 'DEMODAY', NULL, '2026-04-01 10:20:00', '<h2>데모데이 준비 일정</h2><p>발표 준비, 리허설, 투자자 응대, 운영 체크리스트를 일정 단위로 나눈 문서다.</p><ul><li>중간 점검 이후 발표 구조를 확정한다.</li><li>데모 영상과 라이브 시연 백업 플로우를 따로 준비한다.</li><li>투자자 FAQ와 후속 미팅 리스트를 사전에 정리한다.</li></ul>'),
    ('GROUP', '서울센터', '서울센터 운영 허브', 'SECTION', 1, 'asm-0008', 'TEAM_HOME', 'ORIENTATION', NULL, '2026-04-02 10:00:00', '<h2>서울센터 운영 허브</h2><p>서울센터 300명 연수생 운영 흐름과 공간 사용 기준을 정리하는 문서 허브다.</p><ul><li>출석, 멘토링, 장비 대여, 공개 공지 흐름을 한곳에서 확인한다.</li><li>100개 팀의 운영 이슈는 주간 회의에서 모아 본다.</li><li>센터 운영진과 프로그램 운영진의 역할 분리를 명확히 한다.</li></ul>'),
    ('GROUP', '서울센터', '서울센터 온보딩 운영안', 'CONTENT', 2, 'asm-0008', 'SERVICE', 'ORIENTATION', NULL, '2026-04-02 10:05:00', '<h2>서울센터 온보딩 운영안</h2><p>서울센터에서 첫 2주 동안 진행할 온보딩 세션과 팀 빌딩 지원 흐름을 정리한다.</p><ul><li>첫날에는 계정 발급과 공간 안내를 끝낸다.</li><li>1주차 후반에는 고객 인터뷰 준비 워크숍을 진행한다.</li><li>멘토 첫 만남은 팀 빌딩 직후로 배치한다.</li></ul>'),
    ('GROUP', '서울센터', '서울센터 주간 운영표', 'CONTENT', 3, 'asm-0010', 'SERVICE', 'CURRICULUM', NULL, '2026-04-02 10:10:00', '<h2>서울센터 주간 운영표</h2><p>서울센터 공용 세션, 멘토링 슬롯, 운영 회의 시간을 주 단위로 관리하는 문서다.</p><ul><li>공통 세션은 월요일 오전에 배치한다.</li><li>멘토링은 화요일과 목요일 오후에 집중 배치한다.</li><li>운영 이슈 회고는 금요일 마지막 슬롯에 진행한다.</li></ul>'),
    ('GROUP', '부산센터', '부산센터 운영 허브', 'SECTION', 1, 'asm-0009', 'TEAM_HOME', 'ORIENTATION', NULL, '2026-04-02 11:00:00', '<h2>부산센터 운영 허브</h2><p>부산센터 150명 연수생 기준의 운영 흐름과 지역 협력 리소스를 관리하는 허브 문서다.</p><ul><li>센터 운영과 지역 연계 일정이 동시에 보이도록 문서를 구성한다.</li><li>50개 팀의 현장 운영 이슈는 운영진이 일일 체크한다.</li><li>공개 문서와 그룹 문서를 분리해 혼선을 줄인다.</li></ul>'),
    ('GROUP', '부산센터', '부산센터 온보딩 운영안', 'CONTENT', 2, 'asm-0009', 'SERVICE', 'ORIENTATION', NULL, '2026-04-02 11:05:00', '<h2>부산센터 온보딩 운영안</h2><p>부산센터 연수생이 예비 과정 초기에 필요한 계정, 공간, 일정 정보를 빠르게 파악하도록 만든 문서다.</p><ul><li>센터 출입과 장비 대여 안내를 첫날에 끝낸다.</li><li>팀 결성 전 고객 인터뷰 준비 세션을 배치한다.</li><li>서울센터와 다른 지역 협력 일정은 별도로 표시한다.</li></ul>'),
    ('GROUP', '부산센터', '부산센터 주간 운영표', 'CONTENT', 3, 'asm-0010', 'SERVICE', 'CURRICULUM', NULL, '2026-04-02 11:10:00', '<h2>부산센터 주간 운영표</h2><p>부산센터의 공통 세션, 멘토링, 현장 협력 프로그램 일정을 함께 보는 주간 운영 문서다.</p><ul><li>현장 협력 일정은 오전에 몰아 두지 않는다.</li><li>팀 발표와 멘토링은 같은 날 겹치지 않게 배치한다.</li><li>운영 회고는 센터 운영진과 프로그램 운영진이 함께 진행한다.</li></ul>');

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 팀 허브'),
    'SECTION',
    1,
    tp.student1_employee_id,
    'TEAM_HOME',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:00:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' 팀 허브</h2>',
        '<p>', tp.team_group_name, '은 ', th.theme_name, ' 영역에서 ', th.target_customer, '을 위한 서비스를 준비하는 팀이다.</p>',
        '<ul><li>센터: ', tp.center_group_name, '</li><li>대표 서비스명: ', tp.service_name, '</li><li>이번 스프린트 목표: 고객 검증과 MVP 정합성 확보</li></ul>',
        '<p>이 허브 아래에 문제정의, 시장 분석, 사용자 여정, 서비스 기획, 기술 아키텍처, 수익화 문서를 순서대로 관리한다.</p>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 팀/문제 정의'),
    'CONTENT',
    2,
    tp.student1_employee_id,
    'PROBLEM',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:05:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' | 팀/문제 정의</h2>',
        '<p>', th.problem_statement, '</p>',
        '<p>주요 고객은 ', th.target_customer, '이며, 팀은 예비 과정 동안 인터뷰와 관찰을 통해 문제 빈도와 긴급도를 함께 검증한다.</p>',
        '<ul><li>핵심 가설: ', th.core_feature, '가 가장 큰 병목을 줄인다.</li><li>검증 지표: ', th.validation_metric, '</li><li>초기 인터뷰 목표: 30명 이상</li></ul>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 시장 조사 및 경쟁 분석'),
    'CONTENT',
    3,
    tp.student2_employee_id,
    'MARKET',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:10:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' | 시장 조사 및 경쟁 분석</h2>',
        '<p>현재 시장에서는 ', th.competitor_hint, '이 주요 대안으로 쓰이고 있다.</p>',
        '<p>팀은 고객이 왜 기존 대안을 계속 쓰는지와 어떤 순간에 불편이 커지는지에 집중해 경쟁 구도를 정리한다.</p>',
        '<ul><li>차별화 포인트: AI 기반 의사결정 속도 향상</li><li>진입 전략: 좁은 문제와 작은 고객군부터 시작</li><li>검증 방식: 유료 의사와 반복 사용 빈도를 함께 확인</li></ul>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 사용자 페르소나 및 고객 여정'),
    'CONTENT',
    4,
    tp.student3_employee_id,
    'PERSONA',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:15:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' | 사용자 페르소나 및 고객 여정</h2>',
        '<p>핵심 페르소나는 ', th.target_customer, ' 중에서 문제를 가장 자주 겪는 실무 책임자다.</p>',
        '<p>현재 여정은 문제 인지, 대안 탐색, 수기 처리, 결과 확인 단계로 이어지며 각 단계마다 응답 지연과 정보 누락이 발생한다.</p>',
        '<ul><li>첫 번째 개선 포인트: 가입 첫날 핵심 가치 인지</li><li>두 번째 개선 포인트: 반복 업무 자동화 체감</li><li>세 번째 개선 포인트: 결과 리포트 공유</li></ul>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 서비스 기획서'),
    'CONTENT',
    5,
    tp.student1_employee_id,
    'SERVICE',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:20:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' | 서비스 기획서</h2>',
        '<p>', tp.service_name, '는 ', th.target_customer, '이 빠르게 상황을 파악하고 실행하게 돕는 ', th.theme_name, ' 서비스다.</p>',
        '<ul><li>핵심 기능: ', th.core_feature, '</li><li>MVP 범위: 핵심 입력, 결과 화면, 운영자 리포트</li><li>실험 계획: 2주 단위 사용자 반응 측정</li></ul>',
        '<p>본 과정 초반에는 수기 운영을 병행해 기능 사용 맥락을 먼저 검증하고, 이후 반복 업무부터 자동화한다.</p>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 기술 아키텍처'),
    'CONTENT',
    6,
    tp.mentor1_employee_id,
    'ARCH',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:25:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' | 기술 아키텍처</h2>',
        '<p>현재 아키텍처는 ', th.architecture_stack, ' 조합을 기본으로 잡는다.</p>',
        '<p>AI 또는 데이터 기능은 ', th.ai_strategy, ' 방식으로 MVP 단계에 맞춰 가볍게 붙인다.</p>',
        '<ul><li>운영 로그와 실험 로그를 분리 저장한다.</li><li>권한과 개인정보 경계를 백엔드에서 먼저 통제한다.</li><li>데모데이 전에는 장애 대응용 수동 플로우를 함께 준비한다.</li></ul>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'GROUP',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 비즈니스 모델 및 수익화'),
    'CONTENT',
    7,
    tp.mentor2_employee_id,
    'BUSINESS',
    NULL,
    tp.theme_id,
    DATE_ADD('2026-04-07 13:30:00', INTERVAL tp.team_seq MINUTE),
    CONCAT(
        '<h2>', tp.service_name, ' | 비즈니스 모델 및 수익화</h2>',
        '<p>초기 수익화 모델은 ', th.revenue_model, ' 전략을 기준으로 설계한다.</p>',
        '<p>예비 과정에서는 유료 의사와 도입 장벽을 확인하고, 본 과정에서는 반복 사용과 확장 가능성을 검증한다.</p>',
        '<ul><li>도입 기준: 실제 운영 시간 절감 혹은 행동 변화 체감</li><li>세일즈 포인트: 빠른 설정, 명확한 리포트, 가벼운 온보딩</li><li>데모데이 메시지: 문제 크기와 실행 속도 동시 증명</li></ul>'
    )
FROM tmp_team_plan tp
JOIN tmp_theme_catalog th ON th.theme_id = tp.theme_id;

INSERT INTO tmp_seed_docs (
    doc_scope, group_name, title, kms_doc_type, sort_order, writer_employee_id, category_code, tag_set, theme_id, created_at, content
)
SELECT
    'PUBLIC',
    NULL,
    pd.title,
    'CONTENT',
    NULL,
    pd.author_employee_id,
    'PUBLIC',
    pd.tag_set,
    NULL,
    DATE_ADD('2026-04-05 09:00:00', INTERVAL pd.doc_no DAY),
    CONCAT(
        '<h2>', pd.title, '</h2>',
        '<p>', pd.summary, '</p>',
        '<p>대상 독자는 ', pd.audience, '이며, 문서의 목적은 운영과 창업 실행을 같은 리듬으로 보이게 만드는 데 있다.</p>',
        '<ul><li>', pd.highlight_1, '</li><li>', pd.highlight_2, '</li><li>', pd.highlight_3, '</li></ul>',
        '<p>면접용 데모에서는 이 문서를 통해 공개 문서 영역이 단순 공지 게시판이 아니라 운영 지식 허브로 동작한다는 점을 보여준다.</p>'
    )
FROM tmp_public_docs pd;

INSERT INTO document (
    created_at,
    updated_at,
    book_count,
    kms_doc_type,
    title,
    uuid,
    down_link_id,
    group_id,
    up_link_id
)
SELECT
    sd.created_at,
    sd.created_at,
    0,
    sd.kms_doc_type,
    sd.title,
    UUID(),
    NULL,
    g.id,
    NULL
FROM tmp_seed_docs sd
JOIN `group` g ON g.group_name = sd.group_name
WHERE sd.doc_scope = 'GROUP'
  AND NOT EXISTS (
      SELECT 1
      FROM document d
      WHERE d.title = sd.title
        AND d.group_id = g.id
  );

INSERT INTO document (
    created_at,
    updated_at,
    book_count,
    kms_doc_type,
    title,
    uuid,
    down_link_id,
    group_id,
    up_link_id
)
SELECT
    sd.created_at,
    sd.created_at,
    0,
    sd.kms_doc_type,
    sd.title,
    UUID(),
    NULL,
    NULL,
    NULL
FROM tmp_seed_docs sd
WHERE sd.doc_scope = 'PUBLIC'
  AND NOT EXISTS (
      SELECT 1
      FROM document d
      WHERE d.title = sd.title
        AND d.group_id IS NULL
  );

INSERT INTO `version` (
    created_at,
    updated_at,
    content,
    is_show,
    message,
    document_id,
    writer_id
)
SELECT
    sd.created_at,
    sd.created_at,
    sd.content,
    'Y',
    'seed-rich v1',
    d.id,
    u.id
FROM tmp_seed_docs sd
JOIN `user` u ON u.employee_id = sd.writer_employee_id
LEFT JOIN `group` g ON g.group_name = sd.group_name
JOIN document d
    ON d.title = sd.title
   AND ((sd.doc_scope = 'PUBLIC' AND d.group_id IS NULL) OR (sd.doc_scope = 'GROUP' AND d.group_id = g.id))
WHERE NOT EXISTS (
    SELECT 1
    FROM `version` v
    WHERE v.document_id = d.id
      AND v.message = 'seed-rich v1'
);

DROP TEMPORARY TABLE IF EXISTS tmp_group_doc_order;
CREATE TEMPORARY TABLE tmp_group_doc_order AS
SELECT
    g.id AS group_id,
    d.id AS doc_id,
    sd.sort_order
FROM tmp_seed_docs sd
JOIN `group` g ON g.group_name = sd.group_name
JOIN document d ON d.title = sd.title AND d.group_id = g.id
WHERE sd.doc_scope = 'GROUP';

UPDATE document d
JOIN (
    SELECT
        cur.doc_id,
        prev.doc_id AS up_doc_id,
        nxt.doc_id AS down_doc_id
    FROM tmp_group_doc_order cur
    LEFT JOIN tmp_group_doc_order prev
        ON prev.group_id = cur.group_id
       AND prev.sort_order = cur.sort_order - 1
    LEFT JOIN tmp_group_doc_order nxt
        ON nxt.group_id = cur.group_id
       AND nxt.sort_order = cur.sort_order + 1
) links ON links.doc_id = d.id
SET
    d.up_link_id = links.up_doc_id,
    d.down_link_id = links.down_doc_id;

DROP TEMPORARY TABLE IF EXISTS tmp_seed_tags;
CREATE TEMPORARY TABLE tmp_seed_tags (
    tag_name VARCHAR(100) PRIMARY KEY
);

INSERT INTO tmp_seed_tags (tag_name) VALUES
    ('17기'), ('창업'), ('AI'), ('LLM'), ('RAG'), ('MVP'), ('PMF'), ('SaaS'), ('B2B'), ('B2C'),
    ('모빌리티'), ('헬스케어'), ('에듀테크'), ('접근성'), ('로컬서비스'), ('운영자동화'), ('생산성'), ('커뮤니티'), ('핀테크'), ('보안'),
    ('데이터'), ('추천시스템'), ('고객인터뷰'), ('UX'), ('A/B테스트'), ('지표설계'), ('멘토링'), ('오리엔테이션'), ('온보딩'), ('프로젝트관리'),
    ('예비과정'), ('본과정'), ('활동비'), ('데모데이'), ('IR'), ('투자'), ('발표'), ('AI윤리'), ('개인정보'), ('클라우드'),
    ('백엔드'), ('프론트엔드'), ('문제정의'), ('시장검증'), ('경쟁분석'), ('사용자조사'), ('서비스기획'), ('아키텍처'), ('수익화'), ('협업'),
    ('운영정책'), ('프로토타입'), ('브랜딩'), ('성과공유'), ('API'), ('정책'), ('스타트업'), ('일정관리'), ('발표자료'), ('모바일'),
    ('그로스'), ('지식관리'), ('여행'), ('제조'), ('HR테크'), ('푸드테크'), ('펫케어'), ('에너지'), ('피드백');

INSERT IGNORE INTO hash_tag (
    created_at,
    updated_at,
    tag_name
)
SELECT
    '2026-04-01 08:00:00',
    '2026-04-01 08:00:00',
    tag_name
FROM tmp_seed_tags;

DROP TEMPORARY TABLE IF EXISTS tmp_public_tag_rules;
CREATE TEMPORARY TABLE tmp_public_tag_rules (
    tag_set VARCHAR(50) NOT NULL,
    tag_name VARCHAR(100) NOT NULL
);

INSERT INTO tmp_public_tag_rules (tag_set, tag_name) VALUES
    ('ORIENTATION', '17기'), ('ORIENTATION', '오리엔테이션'), ('ORIENTATION', '온보딩'), ('ORIENTATION', '프로젝트관리'),
    ('ORIENTATION', '협업'), ('ORIENTATION', '스타트업'), ('ORIENTATION', '운영정책'), ('ORIENTATION', '멘토링'),
    ('CURRICULUM', '17기'), ('CURRICULUM', '예비과정'), ('CURRICULUM', '본과정'), ('CURRICULUM', '일정관리'),
    ('CURRICULUM', '프로젝트관리'), ('CURRICULUM', 'MVP'), ('CURRICULUM', '멘토링'), ('CURRICULUM', '성과공유'),
    ('MENTORING', '멘토링'), ('MENTORING', '고객인터뷰'), ('MENTORING', '시장검증'), ('MENTORING', '문제정의'),
    ('MENTORING', '피드백'), ('MENTORING', 'PMF'), ('MENTORING', '프로토타입'), ('MENTORING', 'IR'),
    ('MONEY', '활동비'), ('MONEY', '운영정책'), ('MONEY', '프로젝트관리'), ('MONEY', '스타트업'),
    ('MONEY', 'MVP'), ('MONEY', '데모데이'), ('MONEY', '협업'), ('MONEY', '정책'),
    ('RESEARCH', '사용자조사'), ('RESEARCH', '고객인터뷰'), ('RESEARCH', 'UX'), ('RESEARCH', '지표설계'),
    ('RESEARCH', '시장검증'), ('RESEARCH', 'A/B테스트'), ('RESEARCH', '온보딩'), ('RESEARCH', 'PMF'),
    ('COMPLIANCE', 'AI윤리'), ('COMPLIANCE', '개인정보'), ('COMPLIANCE', '접근성'), ('COMPLIANCE', '보안'),
    ('COMPLIANCE', '데이터'), ('COMPLIANCE', '정책'), ('COMPLIANCE', '클라우드'), ('COMPLIANCE', '운영정책'),
    ('GROWTH', '그로스'), ('GROWTH', '수익화'), ('GROWTH', 'B2B'), ('GROWTH', 'B2C'),
    ('GROWTH', 'SaaS'), ('GROWTH', 'PMF'), ('GROWTH', 'IR'), ('GROWTH', '지표설계'),
    ('DEMODAY', '데모데이'), ('DEMODAY', 'IR'), ('DEMODAY', '발표'), ('DEMODAY', '투자'),
    ('DEMODAY', '브랜딩'), ('DEMODAY', '성과공유'), ('DEMODAY', '프로토타입'), ('DEMODAY', '창업'),
    ('TECH', 'AI'), ('TECH', 'LLM'), ('TECH', 'RAG'), ('TECH', '클라우드'),
    ('TECH', 'API'), ('TECH', '백엔드'), ('TECH', '데이터'), ('TECH', '아키텍처');

DROP TEMPORARY TABLE IF EXISTS tmp_category_tag_rules;
CREATE TEMPORARY TABLE tmp_category_tag_rules (
    category_code VARCHAR(50) NOT NULL,
    tag_name VARCHAR(100) NOT NULL
);

INSERT INTO tmp_category_tag_rules (category_code, tag_name) VALUES
    ('TEAM_HOME', '17기'), ('TEAM_HOME', '협업'), ('TEAM_HOME', '프로젝트관리'),
    ('PROBLEM', '창업'), ('PROBLEM', '문제정의'), ('PROBLEM', '시장검증'),
    ('MARKET', '경쟁분석'), ('MARKET', 'PMF'), ('MARKET', '고객인터뷰'),
    ('PERSONA', 'UX'), ('PERSONA', '사용자조사'), ('PERSONA', '온보딩'),
    ('SERVICE', '서비스기획'), ('SERVICE', 'MVP'), ('SERVICE', '프로토타입'),
    ('ARCH', '아키텍처'), ('ARCH', '백엔드'), ('ARCH', '클라우드'),
    ('BUSINESS', '수익화'), ('BUSINESS', 'IR'), ('BUSINESS', '스타트업');

INSERT IGNORE INTO doc_hash_tag (
    created_at,
    updated_at,
    document_id,
    hash_tag_id
)
SELECT
    sd.created_at,
    sd.created_at,
    d.id,
    ht.id
FROM tmp_seed_docs sd
LEFT JOIN `group` g ON g.group_name = sd.group_name
JOIN document d
    ON d.title = sd.title
   AND ((sd.doc_scope = 'PUBLIC' AND d.group_id IS NULL) OR (sd.doc_scope = 'GROUP' AND d.group_id = g.id))
JOIN tmp_public_tag_rules ptr ON ptr.tag_set = sd.tag_set
JOIN hash_tag ht ON ht.tag_name = ptr.tag_name;

INSERT IGNORE INTO doc_hash_tag (
    created_at,
    updated_at,
    document_id,
    hash_tag_id
)
SELECT
    sd.created_at,
    sd.created_at,
    d.id,
    ht.id
FROM tmp_seed_docs sd
JOIN `group` g ON g.group_name = sd.group_name
JOIN document d ON d.title = sd.title AND d.group_id = g.id
JOIN tmp_category_tag_rules ctr ON ctr.category_code = sd.category_code
JOIN hash_tag ht ON ht.tag_name = ctr.tag_name
WHERE sd.theme_id IS NOT NULL;

INSERT IGNORE INTO doc_hash_tag (
    created_at,
    updated_at,
    document_id,
    hash_tag_id
)
SELECT
    sd.created_at,
    sd.created_at,
    d.id,
    ht.id
FROM tmp_seed_docs sd
JOIN `group` g ON g.group_name = sd.group_name
JOIN document d ON d.title = sd.title AND d.group_id = g.id
JOIN tmp_theme_catalog th ON th.theme_id = sd.theme_id
JOIN hash_tag ht ON ht.tag_name IN (th.tag1, th.tag2, th.tag3)
WHERE sd.theme_id IS NOT NULL;

DROP TEMPORARY TABLE IF EXISTS tmp_seed_requests;
CREATE TEMPORARY TABLE tmp_seed_requests (
    request_code VARCHAR(50) PRIMARY KEY,
    requester_employee_id VARCHAR(20) NOT NULL,
    target_group_name VARCHAR(255) NOT NULL,
    target_doc_title VARCHAR(255) NOT NULL,
    days INT NOT NULL,
    is_ok VARCHAR(5) NOT NULL,
    due_date DATETIME NULL,
    requester_del_yn VARCHAR(5) NOT NULL,
    del_yn VARCHAR(5) NOT NULL,
    note_receiver_employee_id VARCHAR(20) NULL,
    note_writer_employee_id VARCHAR(20) NULL,
    note_type VARCHAR(20) NULL,
    created_at DATETIME NOT NULL
);

INSERT INTO tmp_seed_requests (
    request_code,
    requester_employee_id,
    target_group_name,
    target_doc_title,
    days,
    is_ok,
    due_date,
    requester_del_yn,
    del_yn,
    note_receiver_employee_id,
    note_writer_employee_id,
    note_type,
    created_at
)
SELECT
    CONCAT('ADMIN_APPROVED_', tp.team_seq),
    'asm-1234',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 기술 아키텍처'),
    90,
    'Y',
    '2026-12-31 23:59:59',
    'N',
    'N',
    'asm-1234',
    tp.mentor1_employee_id,
    'APPROVE',
    DATE_ADD('2026-08-01 09:00:00', INTERVAL tp.team_seq DAY)
FROM tmp_team_plan tp
WHERE tp.team_seq BETWEEN 11 AND 15;

INSERT INTO tmp_seed_requests (
    request_code,
    requester_employee_id,
    target_group_name,
    target_doc_title,
    days,
    is_ok,
    due_date,
    requester_del_yn,
    del_yn,
    note_receiver_employee_id,
    note_writer_employee_id,
    note_type,
    created_at
)
SELECT
    CONCAT('ADMIN_PENDING_', tp.team_seq),
    'asm-1234',
    tp.team_group_name,
    CONCAT('[', tp.service_name, '] 비즈니스 모델 및 수익화'),
    30,
    'P',
    NULL,
    'N',
    'N',
    NULL,
    NULL,
    NULL,
    DATE_ADD('2026-08-15 09:00:00', INTERVAL tp.team_seq DAY)
FROM tmp_team_plan tp
WHERE tp.team_seq BETWEEN 16 AND 20;

INSERT INTO tmp_seed_requests (
    request_code,
    requester_employee_id,
    target_group_name,
    target_doc_title,
    days,
    is_ok,
    due_date,
    requester_del_yn,
    del_yn,
    note_receiver_employee_id,
    note_writer_employee_id,
    note_type,
    created_at
)
SELECT
    CONCAT('ADMIN_INBOX_', req_seed.req_no),
    req_seed.requester_employee_id,
    req_seed.target_group_name,
    req_seed.target_doc_title,
    21,
    'P',
    NULL,
    'N',
    'N',
    'asm-1234',
    req_seed.requester_employee_id,
    'REQUEST',
    DATE_ADD('2026-08-20 09:00:00', INTERVAL req_seed.req_no DAY)
FROM (
    SELECT 1 AS req_no, 'asm-0466' AS requester_employee_id, '제17기 운영' AS target_group_name, '멘토링 운영 기준' AS target_doc_title
    UNION ALL
    SELECT 2, 'asm-0469', '제17기 운영', '데모데이 준비 일정'
    UNION ALL
    SELECT 3, 'asm-0472', '서울센터', '서울센터 온보딩 운영안'
    UNION ALL
    SELECT 4, 'asm-0475', '서울센터', '서울센터 주간 운영표'
    UNION ALL
    SELECT 5, 'asm-0478', '부산센터', '부산센터 온보딩 운영안'
) req_seed;

INSERT INTO request (
    created_at,
    updated_at,
    days,
    del_yn,
    due_date,
    is_ok,
    requester_del_yn,
    document_id,
    group_id,
    requester_id
)
SELECT
    sr.created_at,
    sr.created_at,
    sr.days,
    sr.del_yn,
    sr.due_date,
    sr.is_ok,
    sr.requester_del_yn,
    d.id,
    g.id,
    requester.id
FROM tmp_seed_requests sr
JOIN `group` g ON g.group_name = sr.target_group_name
JOIN document d ON d.title = sr.target_doc_title AND d.group_id = g.id
JOIN `user` requester ON requester.employee_id = sr.requester_employee_id
WHERE NOT EXISTS (
    SELECT 1
    FROM request r
    WHERE r.requester_id = requester.id
      AND r.document_id = d.id
      AND r.group_id = g.id
      AND r.is_ok = sr.is_ok
      AND r.days = sr.days
      AND r.due_date <=> sr.due_date
);

INSERT IGNORE INTO user_doc_authority (
    due_date,
    user_id,
    document_id
)
SELECT
    sr.due_date,
    requester.id,
    d.id
FROM tmp_seed_requests sr
JOIN `group` g ON g.group_name = sr.target_group_name
JOIN document d ON d.title = sr.target_doc_title AND d.group_id = g.id
JOIN `user` requester ON requester.employee_id = sr.requester_employee_id
WHERE sr.is_ok = 'Y'
  AND sr.due_date IS NOT NULL;

INSERT INTO note (
    created_at,
    updated_at,
    is_read,
    message,
    document_id,
    receiver_id,
    writer_id
)
SELECT
    sr.created_at,
    sr.created_at,
    'N',
    CASE
        WHEN sr.note_type = 'REQUEST' THEN CONCAT(writer.name, '님이 ', d.title, ' 문서의 접근 권한을 요청했습니다.')
        WHEN sr.note_type = 'APPROVE' THEN CONCAT(writer.name, '님이 ', d.title, ' 문서의 접근 권한 요청을 수락하셨습니다.')
        ELSE NULL
    END,
    d.id,
    receiver.id,
    writer.id
FROM tmp_seed_requests sr
JOIN `group` g ON g.group_name = sr.target_group_name
JOIN document d ON d.title = sr.target_doc_title AND d.group_id = g.id
JOIN `user` receiver ON receiver.employee_id = sr.note_receiver_employee_id
JOIN `user` writer ON writer.employee_id = sr.note_writer_employee_id
WHERE sr.note_type IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM note n
      WHERE n.receiver_id = receiver.id
        AND n.writer_id = writer.id
        AND n.document_id = d.id
        AND n.message = CASE
            WHEN sr.note_type = 'REQUEST' THEN CONCAT(writer.name, '님이 ', d.title, ' 문서의 접근 권한을 요청했습니다.')
            WHEN sr.note_type = 'APPROVE' THEN CONCAT(writer.name, '님이 ', d.title, ' 문서의 접근 권한 요청을 수락하셨습니다.')
            ELSE NULL
        END
  );

DROP TEMPORARY TABLE IF EXISTS tmp_admin_bookmarks;
CREATE TEMPORARY TABLE tmp_admin_bookmarks (
    doc_title VARCHAR(255) NOT NULL,
    group_name VARCHAR(255) NULL
);

INSERT INTO tmp_admin_bookmarks (doc_title, group_name) VALUES
    ('데모 사용 가이드', NULL),
    ('면접 시연 체크리스트', NULL),
    ('데모데이 발표 가이드', NULL),
    ('IR Deck 작성 팁', NULL),
    ('고객 인터뷰 가이드', NULL),
    ('AI 윤리 점검표', NULL),
    ('SaaS 전환율 개선 아이디어', NULL),
    ('[AeroCare] 기술 아키텍처', '서울 17기 001팀'),
    ('[AeroRoute] 기술 아키텍처', '서울 17기 002팀'),
    ('[AeroDesk] 기술 아키텍처', '서울 17기 003팀');

INSERT INTO bookmarks (
    created_at,
    updated_at,
    document_id,
    user_id
)
SELECT
    '2026-08-25 09:00:00',
    '2026-08-25 09:00:00',
    d.id,
    admin_user.id
FROM tmp_admin_bookmarks ab
JOIN `user` admin_user ON admin_user.employee_id = 'asm-1234'
LEFT JOIN `group` g ON g.group_name = ab.group_name
JOIN document d
    ON d.title = ab.doc_title
   AND ((ab.group_name IS NULL AND d.group_id IS NULL) OR (ab.group_name IS NOT NULL AND d.group_id = g.id))
WHERE NOT EXISTS (
    SELECT 1
    FROM bookmarks b
    WHERE b.user_id = admin_user.id
      AND b.document_id = d.id
);

UPDATE document d
SET d.book_count = (
    SELECT COUNT(*)
    FROM bookmarks b
    WHERE b.document_id = d.id
);

COMMIT;
