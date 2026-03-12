package com.FINAL.KIP.common;

import com.FINAL.KIP.document.domain.Document;
import com.FINAL.KIP.document.domain.KmsDocType;
import com.FINAL.KIP.document.repository.DocumentRepository;
import com.FINAL.KIP.group.domain.Group;
import com.FINAL.KIP.group.domain.GroupRole;
import com.FINAL.KIP.group.domain.GroupType;
import com.FINAL.KIP.group.domain.GroupUser;
import com.FINAL.KIP.group.repository.GroupRepository;
import com.FINAL.KIP.group.repository.GroupUserRepository;
import com.FINAL.KIP.request.domain.Request;
import com.FINAL.KIP.request.repository.RequestRepository;
import com.FINAL.KIP.user.domain.Role;
import com.FINAL.KIP.user.domain.User;
import com.FINAL.KIP.user.repository.UserRepository;
import com.FINAL.KIP.version.domain.Version;
import com.FINAL.KIP.version.repository.VersionRepository;
import jakarta.transaction.Transactional;
import java.util.Optional;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class InitialDataLoader implements CommandLineRunner {

    private static final String DEFAULT_PASSWORD = "1234";
    private static final String ADMIN_EMPLOYEE_ID = "k-1234567890";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final GroupRepository groupRepository;
    private final GroupUserRepository groupUserRepository;
    private final DocumentRepository documentRepository;
    private final VersionRepository versionRepository;
    private final RequestRepository requestRepository;

    public InitialDataLoader(
        UserRepository userRepository,
        PasswordEncoder passwordEncoder,
        GroupRepository groupRepository,
        GroupUserRepository groupUserRepository,
        DocumentRepository documentRepository,
        VersionRepository versionRepository,
        RequestRepository requestRepository
    ) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.groupRepository = groupRepository;
        this.groupUserRepository = groupUserRepository;
        this.documentRepository = documentRepository;
        this.versionRepository = versionRepository;
        this.requestRepository = requestRepository;
    }

    @Override
    @Transactional
    public void run(String... args) {
        if (userRepository.findByEmployeeId(ADMIN_EMPLOYEE_ID).isPresent()) {
            return;
        }

        User admin = createUser(
            "소마멘토",
            "admin@kip.com",
            "01012345678",
            ADMIN_EMPLOYEE_ID,
            Role.ADMIN,
            "https://picsum.photos/seed/kip-admin/400",
            "2024년 3월 1일 금요일"
        );
        User pm = createUser(
            "김민서 PM",
            "pm@kip.com",
            "01010000001",
            "k-2403140001",
            Role.USER,
            "https://picsum.photos/seed/kip-pm/400",
            "2024년 3월 4일 월요일"
        );
        User backendLead = createUser(
            "이도윤 Backend",
            "backend@kip.com",
            "01010000002",
            "k-2403140002",
            Role.USER,
            "https://picsum.photos/seed/kip-backend/400",
            "2024년 3월 5일 화요일"
        );
        User frontendLead = createUser(
            "박서윤 Frontend",
            "frontend@kip.com",
            "01010000003",
            "k-2403140003",
            Role.USER,
            "https://picsum.photos/seed/kip-frontend/400",
            "2024년 3월 5일 화요일"
        );
        User aiLead = createUser(
            "정하늘 AI",
            "ai@kip.com",
            "01010000004",
            "k-2403140004",
            Role.USER,
            "https://picsum.photos/seed/kip-ai/400",
            "2024년 3월 6일 수요일"
        );
        User qaEngineer = createUser(
            "최지훈 QA",
            "qa@kip.com",
            "01010000005",
            "k-2403140005",
            Role.USER,
            "https://picsum.photos/seed/kip-qa/400",
            "2024년 3월 7일 목요일"
        );
        User mentor = createUser(
            "장유진 Mentor",
            "mentor@kip.com",
            "01010000006",
            "k-2403140006",
            Role.USER,
            "https://picsum.photos/seed/kip-mentor/400",
            "2024년 3월 8일 금요일"
        );
        User po = createUser(
            "한서준 PO",
            "po@kip.com",
            "01010000007",
            "k-2403140007",
            Role.USER,
            "https://picsum.photos/seed/kip-po/400",
            "2024년 3월 11일 월요일"
        );

        Group rootGroup = createGroup(
            "AI 소프트웨어 마에스트로 데모",
            GroupType.DEPARTMENT,
            null,
            admin,
            """
            <h2>AI 소프트웨어 마에스트로 데모 지식 허브</h2>
            <p>이 공간은 면접용 데모를 위해 구성된 샘플 지식관리 그룹입니다.</p>
            <ul>
              <li>공통 운영 문서</li>
              <li>제품 개발 문서</li>
              <li>AI 실험 문서</li>
            </ul>
            <p>각 그룹에는 실제 협업 상황을 가정한 문서, 버전, 권한 요청 더미데이터가 포함되어 있습니다.</p>
            """
        );
        Group opsGroup = createGroup(
            "공통 운영",
            GroupType.DEPARTMENT,
            rootGroup,
            admin,
            """
            <h2>공통 운영 그룹</h2>
            <p>면접 시연, 일정 관리, 회의록 정리 문서를 보관하는 그룹입니다.</p>
            <p>PM과 QA 중심의 운영 문서가 정리되어 있습니다.</p>
            """
        );
        Group productGroup = createGroup(
            "제품 개발",
            GroupType.DEPARTMENT,
            rootGroup,
            admin,
            """
            <h2>제품 개발 그룹</h2>
            <p>서비스 아키텍처, 릴리즈 계획, 배포 전략을 정리하는 상위 그룹입니다.</p>
            <p>하위 그룹으로 백엔드와 프론트엔드 문서를 분리해 관리합니다.</p>
            """
        );
        Group backendGroup = createGroup(
            "백엔드",
            GroupType.BUSINESS,
            productGroup,
            admin,
            """
            <h2>백엔드 그룹</h2>
            <p>인증, 문서 API, 파일 저장, 데모 배포 관련 기술 의사결정을 기록합니다.</p>
            """
        );
        Group frontendGroup = createGroup(
            "프론트엔드",
            GroupType.BUSINESS,
            productGroup,
            admin,
            """
            <h2>프론트엔드 그룹</h2>
            <p>문서 탐색 경험, 에디터 UX, 상태관리 규칙을 정리하는 공간입니다.</p>
            """
        );
        Group aiLabGroup = createGroup(
            "AI 실험실",
            GroupType.DEPARTMENT,
            rootGroup,
            admin,
            """
            <h2>AI 실험실 그룹</h2>
            <p>RAG 실험, 프롬프트 평가, 검색 품질 개선 기록을 정리하는 그룹입니다.</p>
            """
        );

        addUserToGroup(rootGroup, admin, GroupRole.SUPER);
        addUserToGroup(rootGroup, pm, GroupRole.NORMAL);
        addUserToGroup(rootGroup, po, GroupRole.NORMAL);

        addUserToGroup(opsGroup, pm, GroupRole.SUPER);
        addUserToGroup(opsGroup, qaEngineer, GroupRole.NORMAL);

        addUserToGroup(productGroup, admin, GroupRole.SUPER);
        addUserToGroup(productGroup, pm, GroupRole.NORMAL);
        addUserToGroup(productGroup, po, GroupRole.NORMAL);

        addUserToGroup(backendGroup, backendLead, GroupRole.SUPER);
        addUserToGroup(backendGroup, qaEngineer, GroupRole.NORMAL);

        addUserToGroup(frontendGroup, frontendLead, GroupRole.SUPER);
        addUserToGroup(frontendGroup, qaEngineer, GroupRole.NORMAL);

        addUserToGroup(aiLabGroup, aiLead, GroupRole.SUPER);
        addUserToGroup(aiLabGroup, po, GroupRole.NORMAL);

        createPublicDocument(
            admin,
            "데모 사용 가이드",
            """
            <h2>데모 사용 가이드</h2>
            <p>이 데모는 그룹, 문서, 권한 요청, 검색 흐름을 빠르게 확인하기 위한 상태로 구성되어 있습니다.</p>
            <ol>
              <li>관리자 계정으로 로그인합니다.</li>
              <li>그룹 구조와 공개 문서를 확인합니다.</li>
              <li>그룹 문서를 열어 버전과 접근권한을 확인합니다.</li>
              <li>다른 계정으로 로그인해 권한 요청 상태를 보여줍니다.</li>
            </ol>
            """
        );
        createPublicDocument(
            admin,
            "면접 시연 체크리스트",
            """
            <h2>면접 시연 체크리스트</h2>
            <ul>
              <li>관리자 로그인</li>
              <li>그룹 트리 확인</li>
              <li>문서 검색 시연</li>
              <li>권한 요청 및 승인 상태 설명</li>
              <li>버전 이력 화면 설명</li>
            </ul>
            """
        );
        createPublicDocument(
            admin,
            "프로젝트 한 줄 소개",
            """
            <h2>KIP 소개</h2>
            <p>KIP는 그룹 권한과 문서 버전 관리, 지식 탐색 기능을 결합한 사내 지식관리 서비스입니다.</p>
            <p>면접 데모에서는 Docker Compose 기반 배포 구조와 더불어 지식 축적 흐름을 함께 보여주는 것이 목적입니다.</p>
            """
        );

        Document opsStandup = appendGroupDocument(
            opsGroup,
            opsGroup.getDocuments().get(0),
            pm,
            "주간 운영 보드",
            KmsDocType.CONTENT,
            """
            <h2>주간 운영 보드</h2>
            <p>매주 월요일 운영 점검 항목을 정리합니다.</p>
            <ul>
              <li>사용자 피드백 수집</li>
              <li>문서 요청 누락 여부 확인</li>
              <li>면접 시연용 더미데이터 최신화</li>
            </ul>
            """
        );
        appendGroupDocument(
            opsGroup,
            opsStandup,
            pm,
            "면접 데모 시나리오",
            KmsDocType.CONTENT,
            """
            <h2>면접 데모 시나리오</h2>
            <p>1. 관리자 로그인</p>
            <p>2. 그룹과 사용자 구조 설명</p>
            <p>3. 문서 검색과 권한 요청 흐름 시연</p>
            <p>4. Docker Compose 기반 배포 구조 설명</p>
            """
        );

        Document architectureOverview = appendGroupDocument(
            productGroup,
            productGroup.getDocuments().get(0),
            admin,
            "서비스 아키텍처 개요",
            KmsDocType.CONTENT,
            null
        );
        createVersion(
            architectureOverview,
            admin,
            """
            <h2>초기 아키텍처</h2>
            <p>프론트는 Amplify, 백엔드는 ECR/EKS 기반으로 운영했고 검색과 파일 저장은 외부 서비스 의존도가 높았습니다.</p>
            <p>데모 준비 단계에서 구조가 무거워져 경량화가 필요했습니다.</p>
            """,
            "초기 AWS 배포 구조",
            "N"
        );
        createVersion(
            architectureOverview,
            admin,
            """
            <h2>현재 데모 아키텍처</h2>
            <p>프론트엔드, 백엔드, MariaDB, MinIO를 Docker Compose로 묶어 단일 서버에서 재현 가능한 구조로 단순화했습니다.</p>
            <ul>
              <li>검색은 DB fallback</li>
              <li>파일 저장은 MinIO</li>
              <li>인증은 access token only</li>
              <li>데모 데이터는 기동 시 자동 주입</li>
            </ul>
            """,
            "Lightsail 데모 구조 반영",
            "Y"
        );
        appendGroupDocument(
            productGroup,
            architectureOverview,
            pm,
            "릴리즈 준비 체크리스트",
            KmsDocType.CONTENT,
            """
            <h2>릴리즈 준비 체크리스트</h2>
            <ul>
              <li>환경변수 분리 확인</li>
              <li>더미 관리자 계정 확인</li>
              <li>검색, 권한 요청, 버전 조회 스모크 테스트</li>
              <li>Lightsail 서버 상태 확인</li>
            </ul>
            """
        );

        Document backendDeployGuide = appendGroupDocument(
            backendGroup,
            backendGroup.getDocuments().get(0),
            backendLead,
            "Docker Compose 운영 가이드",
            KmsDocType.CONTENT,
            """
            <h2>Docker Compose 운영 가이드</h2>
            <p>로컬과 서버에서 같은 compose 파일을 사용하고, 환경변수 값만 분리합니다.</p>
            <pre><code>docker compose up -d
docker compose logs -f backend
docker compose ps</code></pre>
            """
        );
        appendGroupDocument(
            backendGroup,
            backendDeployGuide,
            backendLead,
            "JWT 인증 단순화 기록",
            KmsDocType.CONTENT,
            """
            <h2>JWT 인증 단순화 기록</h2>
            <p>면접 데모 안정성을 위해 refresh token을 제거하고 access token only 구조로 정리했습니다.</p>
            <p>데모에서는 세션 길이를 충분히 잡고, 만료 시 재로그인하는 흐름으로 단순화합니다.</p>
            """
        );

        Document frontendFlow = appendGroupDocument(
            frontendGroup,
            frontendGroup.getDocuments().get(0),
            frontendLead,
            "Nuxt 화면 흐름 정리",
            KmsDocType.CONTENT,
            """
            <h2>Nuxt 화면 흐름 정리</h2>
            <p>로그인 -> 그룹 탐색 -> 문서 보기 -> 요청/북마크 확인 순으로 시연합니다.</p>
            <p>Nuxt runtime env를 사용해 로컬과 서버 API 주소를 유연하게 분리합니다.</p>
            """
        );
        appendGroupDocument(
            frontendGroup,
            frontendFlow,
            frontendLead,
            "문서 편집 UX 개선안",
            KmsDocType.CONTENT,
            """
            <h2>문서 편집 UX 개선안</h2>
            <ul>
              <li>저장 전 임시 상태 표시</li>
              <li>버전 변경 메시지 입력 유도</li>
              <li>문서 이동 시 그룹 트리 미리보기 제공</li>
            </ul>
            """
        );

        Document ragLog = appendGroupDocument(
            aiLabGroup,
            aiLabGroup.getDocuments().get(0),
            aiLead,
            "RAG 검색 실험 로그",
            KmsDocType.CONTENT,
            """
            <h2>RAG 검색 실험 로그</h2>
            <p>질문-문서 매칭 정확도를 높이기 위해 키워드 fallback과 문서 버전 본문 비교를 함께 테스트했습니다.</p>
            <p>데모 환경에서는 OpenSearch 대신 MariaDB 기반 fallback 검색으로 기능을 보여줍니다.</p>
            """
        );
        appendGroupDocument(
            aiLabGroup,
            ragLog,
            aiLead,
            "프롬프트 평가 기준",
            KmsDocType.CONTENT,
            """
            <h2>프롬프트 평가 기준</h2>
            <ul>
              <li>답변의 정확성</li>
              <li>문맥 회수율</li>
              <li>표현의 일관성</li>
              <li>실무 문서 재사용 가능성</li>
            </ul>
            """
        );

        createRequest(mentor, architectureOverview, 7, "P");
        createRequest(mentor, ragLog, 14, "Y");
    }

    private User createUser(
        String name,
        String email,
        String phoneNumber,
        String employeeId,
        Role role,
        String profileImageUrl,
        String employedDay
    ) {
        User user = User.builder()
            .name(name)
            .email(email)
            .password(passwordEncoder.encode(DEFAULT_PASSWORD))
            .phoneNumber(phoneNumber)
            .profileImageUrl(profileImageUrl)
            .employeeId(employeeId)
            .employedDay(employedDay)
            .role(role)
            .build();
        return userRepository.save(user);
    }

    private Group createGroup(
        String groupName,
        GroupType groupType,
        Group superGroup,
        User writer,
        String welcomeContent
    ) {
        Group group = Group.builder()
            .groupName(groupName)
            .groupType(groupType)
            .build();
        group.setSuperGroup(superGroup);

        Group savedGroup = groupRepository.save(group);
        Document homeDocument = savedGroup.getDocuments().get(0);
        homeDocument.setTitle(groupName + " 그룹 안내");
        createVersion(homeDocument, writer, welcomeContent, "초기 그룹 안내", "Y");
        return savedGroup;
    }

    private void addUserToGroup(Group group, User user, GroupRole groupRole) {
        Optional<GroupUser> existingGroupUser = groupUserRepository.findByGroupAndUser(group, user);
        if (existingGroupUser.isPresent()) {
            existingGroupUser.get().setGroupRole(groupRole);
            return;
        }

        groupUserRepository.save(
            GroupUser.builder()
                .group(group)
                .user(user)
                .groupRole(groupRole)
                .build()
        );
    }

    private Document createPublicDocument(User writer, String title, String content) {
        Document document = Document.builder()
            .title(title)
            .kmsDocType(KmsDocType.CONTENT)
            .build();
        Document savedDocument = documentRepository.save(document);
        createVersion(savedDocument, writer, content, "초기 공개 문서", "Y");
        return savedDocument;
    }

    private Document appendGroupDocument(
        Group group,
        Document previousDocument,
        User writer,
        String title,
        KmsDocType kmsDocType,
        String content
    ) {
        Document newDocument = Document.builder()
            .title(title)
            .kmsDocType(kmsDocType)
            .group(group)
            .build();

        Document nextDocument = previousDocument.getDownLink();
        newDocument.setUpLink(previousDocument);
        newDocument.setDownLink(nextDocument);
        previousDocument.setDownLink(newDocument);
        if (nextDocument != null) {
            nextDocument.setUpLink(newDocument);
        }

        Document savedDocument = documentRepository.save(newDocument);
        if (content != null) {
            createVersion(savedDocument, writer, content, "초기 문서 시드", "Y");
        }
        return savedDocument;
    }

    private Version createVersion(
        Document document,
        User writer,
        String content,
        String message,
        String isShow
    ) {
        return versionRepository.save(
            Version.builder()
                .content(content)
                .message(message)
                .isShow(isShow)
                .document(document)
                .writer(writer)
                .build()
        );
    }

    private void createRequest(User requester, Document document, int days, String status) {
        Request request = Request.builder()
            .requester(requester)
            .document(document)
            .group(document.getGroup())
            .days(days)
            .build();

        if ("Y".equals(status)) {
            request.agreeRequest();
        } else if ("N".equals(status)) {
            request.refuseRequest();
        }

        requestRepository.save(request);
    }
}
