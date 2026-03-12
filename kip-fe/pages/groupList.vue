<script setup>
import {VTreeview} from 'vuetify/labs/VTreeview'
import {useRequest} from "~/stores/Request.js";
import {
  ADMIN_EMPLOYEE_ID,
  DEFAULT_USER_PASSWORD,
} from "~/utils/employeeIdPolicy.js";

// 피니아
const user = useUser();
const group = useGroup();
const color = useColor();
const groupUser = useGroupuser();
const document = useDocumentList()
const request = useRequest();

// 맴버 관련 데이터
const loading = ref(false);
const clickedGroupId = ref(1);
const employedDay = ref()

// 모달 관련 데이터
const addNewMemberModdal = ref();
const createMemberModdal = ref();
const createNewGroupModal = ref();
const updateGruopInfoModal = ref();
const selectSuperGroupModal = ref();
const sendRequestModal = ref(false);

// 상단 네비 제목 설정
group.TopNaviGroupList = [
  "Knowledge is Power",
  "부서목록",
  "타 부서 문서와 구성원을 조회할 수 있습니다. 🥩️"
];

// 그릅 유저 정보 초기화


// ❤️ 유저들의 정보를 세팅하는 함수들
const setUsersInfoInGroup = async (groupId) => {
  clickedGroupId.value = groupId
  await groupUser.setUsersInfoInGroup(groupId);
  await document.setAdminDocumentList(groupId);
}
const setAllUserInfoInKip = async () => {
  // 모달창 열고
  addNewMemberModdal.value = true
  // 현재 그룹에 없는 회원들만 조회
  await groupUser.setAllUserInfoInKip();
}
const deleteUserFromGroup = async (groupId, userId) => {
  await groupUser.deleteUserFromGroup(groupId, userId)
  await group.setMyGroupsInfo();
}
const addUserToGroup = async (userId) => {
  await groupUser.addUserToGroup(clickedGroupId.value, userId);
  await setUsersInfoInGroup(clickedGroupId.value);
  await group.setMyGroupsInfo();
}
const deletUserFromDataBaese = async (employeeId, name) => {
  if (user.getLoginUserRole !== 'ADMIN') {
    alert("관리자에게 문의하세요.");
    return;
  }
  if (employeeId === ADMIN_EMPLOYEE_ID)
    alert("관리자의 아이디는 삭제할 수 없습니다.")
  else {
    await user.deleteUser(employeeId, name);
    groupUser.deletUserFromAllUserInfoInKip(employeeId);
  }
}

// ⏩ 회원가입 관련 세팅
// 전송할 데이터
const data = ref({
  name: '',
  email: '',
  phoneNumber: '',
  employedDay: '',
});

// 최종 제출 관련 함수
const CreateNewUser = async (event) => {
  loading.value = true
  const results = await event
  await wait(500); // 0.5초 대기
  if (results.valid) {
    const createdUser = await user.createUserAccount(data.value)
    await groupUser.addCreatedUserToAllUsers(user.getCreatedUserData)
    alert(`${createdUser.name}님의 계정이 생성되었습니다. 아이디: ${createdUser.employeeId} / 비밀번호: ${DEFAULT_USER_PASSWORD}`)
    Object.keys(data.value).forEach(key => data.value[key] = "");
    createMemberModdal.value = false; // 모달창 닫기
  }
  loading.value = false
}

// 한국말로 입사일 형식 변경하는 함수
const formattedDate = () => {
  let date = new Date(employedDay.value);
  let options = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'long'
  }
  let formattedDate = date.toLocaleDateString('ko-KR', options);
  data.value.employedDay = formattedDate
  return formattedDate
}

// 폼데이터 벨리데이션 체크
const rules = {
  nameRule: value => !!value || '이름 입력이 필요합니다.',

  // 연락처
  phoneNumberRule: value => /^010-\d{4}-\d{4}$/.test(value) || '010- 으로 시작하는 8자리 숫자를 입력해주세요',
  phoneNumberDupulicateCheck: async value => {
    await user.isExistPhoneNumberForCreate(value)
    return !user.getIsExistPhoneNumber || '연락처가 중복됩니다.'
  },

  // 이메일
  emailRule: value => {
    const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    return pattern.test(value) || '이메일 형식이 아닙니다.'
  },
  emailDupulicateCheck: async value => {
    await user.isExistEmailForCreate(value)
    return !user.getIsExistEmail || '같은 이메일이 존재합니다.'
  },

  // 입사일
  employedDayRule: value => /^(19\d{2}|20\d{2})년 (\d{1,2})월 (\d{1,2})일 [월화수목금토일]요일$/.test(value) || '오른쪽 달력을 클릭하여 입력해 주세요',
};

// 🏢 그룹 정보 관련 변수들
const clickedGroupName = ref();
const clickedSuperGroupName = ref();
const BeforeSuperGroupName = ref();
const GroupChildrenIdList = ref([]);
const documentsCount = ref();

// 생성요청과 수정요청을 보내는 JSON 객체
const createGroupReq = ref({
  groupId: 1,
  groupName: "",
  groupType: "DEPARTMENT",
  superGroupId: 1
})

// 🏢 그룹 정보 관련 함수들
const OpenCrateModal = (groupInfo) => {
  createNewGroupModal.value = true;

  clickedGroupName.value = groupInfo.title;
  createGroupReq.value.groupName = "";
  createGroupReq.value.superGroupId = groupInfo.id;
}
const createNewGruopWidhReq = async (event) => {
  loading.value = true
  const results = await event
  await wait(500); // 0.5초 대기

  if (results.valid) {
    await group.createNewGroup(createGroupReq.value)
    createNewGroupModal.value = false;
    createGroupReq.value.groupName = ""
  }
  loading.value = false
}
const OpenUpdateGroupModal = (groupInfo) => {
  if (groupInfo.id === 1)
    alert("최상위 그룹은 수정할 수 없습니다.")
  else {
    updateGruopInfoModal.value = true;

    BeforeSuperGroupName.value = groupInfo.superGroupName
    clickedSuperGroupName.value = groupInfo.superGroupName

    createGroupReq.value.groupId = groupInfo.id
    clickedGroupName.value = groupInfo.title

    createGroupReq.value.groupName = groupInfo.title
    createGroupReq.value.groupType = groupInfo.groupType
    createGroupReq.value.superGroupId = groupInfo.superGroupId

    GroupChildrenIdList.value = groupInfo.childrenIdList;
    documentsCount.value = groupInfo.documentsCount;
  }
}
const OpenSelectSuperGroupModal = () => {
  selectSuperGroupModal.value = true
}

// 그룹 수정 관련 함수
const SetSuperGroupIdAndName = (selectedSuperGruupInfo) => {
  if (selectedSuperGruupInfo.id === createGroupReq.value.groupId)
    alert("상위그룹으로 자신을 선택하셨습니다. 다시 선택해 주세요")
  else if (GroupChildrenIdList.value.includes(selectedSuperGruupInfo.id))
    alert("자신의 하위 그룹으로 이동시킬 수 없습니다. 다시 선택해 주세요.")
  else {
    createGroupReq.value.superGroupId = selectedSuperGruupInfo.id
    clickedSuperGroupName.value = `${BeforeSuperGroupName.value} 👉 ${selectedSuperGruupInfo.title}`
    selectSuperGroupModal.value = false
  }
}
const UpdateGroupInfoReq = async (event) => {
  loading.value = true
  const results = await event
  await wait(500); // 0.5초 대기
  if (results.valid) {
    if (GroupChildrenIdList.value.includes(createGroupReq.value.superGroupId))
      alert("자신의 하위 그룹으로 이동시킬 수 없습니다. 다시 선택해 주세요.")
    else {
      await group.updateGroupInfo(createGroupReq.value)
      await group.setMyGroupsInfo();
      updateGruopInfoModal.value = false;
    }
  }
  loading.value = false
}
const DeleteGruopFromDataBase = async () => {
  if (user.getLoginUserRole !== 'ADMIN') {
    alert("관리자에게 문의하세요.");
    return;
  }
  if (String(createGroupReq.value.groupId) === "1")
    alert("기본 최상단 그룹은 삭제할 수 없습니다.")
  else if (GroupChildrenIdList.value.length !== 0)
    alert("하위그룹이 있는 그룹은 삭제할 수 없습니다.")
  else if (documentsCount.value > 1)
    alert("문서가 2개이상인 그룹은 삭제할 수 없습니다. 그룹 문서를 확인하세요")
  else if (confirm(`${createGroupReq.value.groupName} 그룹이 영구 삭제됩니다.`)) {
    await group.DeleteGruopFromDataBase(createGroupReq.value.groupId)
    alert(`${createGroupReq.value.groupName} 그룹이 영구 삭제 되었습니다.`)
  }
  updateGruopInfoModal.value = false;
}

// 전체 공개문서로 변경
const makePublicDocument = async (title, documentId) => {
  if (user.getLoginUserRole !== 'ADMIN') {
    alert("관리자에게 문의하세요.");
    return;
  }
  if (confirm(`${title} 문서가 전체공개 그룹으로 이동됩니다`)) {
    await document.makePublicDocumentFromGroup(documentId)
    await document.setAdminDocumentList(clickedGroupId.value)
    alert(`${title} 문서가 전체공개로 이동하였습니다.`)
  }
}

// 문서이동
const handlerTargetButtonForMove = ref(false)
const moveDocumentReq = ref({
  startDocId: "",
  endDocId: "",
})
const realShowTargetButton = (startDoctId) => {
  if (user.getLoginUserRole !== 'ADMIN') {
    alert("관리자에게 문의하세요.");
    return;
  }
  handlerTargetButtonForMove.value = true
  moveDocumentReq.value.startDocId = startDoctId
}
const RealMoveDocumnet = async (targetDocId) => {
  if (user.getLoginUserRole !== 'ADMIN') {
    alert("관리자에게 문의하세요.");
    return;
  }
  moveDocumentReq.value.endDocId = targetDocId
  await document.moveDocumentToTargetDoc(moveDocumentReq.value);
  await document.setAdminDocumentList(clickedGroupId.value)
  handlerTargetButtonForMove.value = false
}


// 문서 삭제
const deleteDocument = async (title, documentId) => {
  if (user.getLoginUserRole !== 'ADMIN') {
    alert("관리자에게 문의하세요.");
    return;
  }
  // 최상단 문서 검사
  if (document.getAdminDocumentList[0].documentId === documentId)
    alert("최상단 문서는 삭제할 수 없습니다.")
  else if (confirm(`${title} 문서가 영구 삭제됩니다`)) {
    await document.deleteDocument(documentId)
    await document.setAdminDocumentList(clickedGroupId.value)
    alert(`${title} 문서가 삭제 되었습니다.`)
  }
}
const requestDays = ref(30);
const docUUID = ref();
const sendRequest = async (documentUUID) => {
  const groupId = groupUser.getGroupId
  const groupIdList = group.getMyGroupNamesAndId.find(group => group.groupId === groupId)
  if (groupIdList) {
    alert("권한을 가지고 있는 문서입니다.")
    return;
  }
  requestDays.value = 30;
  sendRequestModal.value = true;
  docUUID.value = documentUUID;
}

const confirmRequest = async () => {
  if (requestDays.value < 1)
    alert("최소 요청일은 하루 입니다.")
  else
    await request.sendRequest(docUUID.value, requestDays.value);
  sendRequestModal.value = false;
}

</script>
<template>

  <!--            ☎️ 실제 본문 -->
  <v-container fluid>
    <v-row justify="center">

      <!-- 👈👈👈👈👈👈👈👈👈 왼쪽 조직 리스트 -->
      <v-col cols="4" class="pl-8">

        <v-card
            elevation="5"
            rounded="xl">
          <v-card-text>
            <v-treeview
                :items="group.getHierarchyInfo"
                color="blue">
              <template v-slot:prepend="{ item }">
                <v-icon
                    v-if="item.children"
                    :icon="`mdi-${item.children.length === 0
                                ? 'account-group-outline' : 'folder-network'}`"
                    @click="setUsersInfoInGroup( item.id)"
                />
              </template>
              <template v-slot:title="{ item }">
                <div @click="setUsersInfoInGroup( item.id)">
                  {{ item.title }}
                  {{ item.groupType === "DEPARTMENT" ? '&nbsp 🏢' : '&nbsp 🚀' }}
                  {{ item.childrenIdList.length === 0 ? '' : `(${item.childrenIdList.length})` }}
                </div>
              </template>
              <template v-slot:append="{ item }">

                <!--                  🖱️ 마우스 올렸을 때 -->
                <v-hover v-slot="{ isHovering, props }">

                  <!--                   ✏️ 수정버튼 -->
                  <v-btn
                      icon="mdi-pencil"
                      v-bind="props"
                      :class="{
                            'on-hover': isHovering,
                            'show-btns': isHovering
                          }"
                      color="rgba(255, 255, 255, 0)"
                      variant="plain"
                      @click="OpenUpdateGroupModal(item)"
                  />

                  <!--                  ➕ 생성버튼 -->
                  <v-btn
                      icon="mdi-plus-circle"
                      v-bind="props"
                      :class="{
                            'on-hover': isHovering,
                            'show-btns': isHovering
                          }"
                      color="rgba(255, 255, 255, 0)"
                      variant="plain"
                      @click="OpenCrateModal(item)"
                  />

                </v-hover>
              </template>
            </v-treeview>
          </v-card-text>
        </v-card>

        <!--           ✏️ 그룹수정을 위한 모달 -->
        <v-dialog
            class="d-flex justify-center"
            width="45vw"
            opacity="50%"
            v-model="updateGruopInfoModal">
          <v-sheet
              rounded="xl"
              class="d-flex justify-center flex-wrap pa-10">

            <v-form ref="form" style="width: 50vw" @submit.prevent="UpdateGroupInfoReq">
              <v-row>
                <v-col>
                  <h1>팀명 : [{{ clickedGroupName }}] 👉 [{{ createGroupReq.groupName }}]</h1>

                  <div class="d-flex mt-7">
                    <h2> 소속 : {{ clickedSuperGroupName }} </h2>
                    <v-btn
                        class="ml-4"
                        icon="mdi-pencil"
                        variant="tonal"
                        @click="OpenSelectSuperGroupModal"
                    />
                  </div>
                  <v-radio-group
                      class="mt-5"
                      v-model="createGroupReq.groupType"
                      :color="color.kipMainColor"
                      inline>
                    <v-radio
                        label="🏢 부서조직"
                        value="DEPARTMENT"/>
                    <v-radio
                        label="🚀 NewBiz팀"
                        value="BUSINESS"/>
                  </v-radio-group>
                  <v-text-field
                      label="신규 그룹 이름"
                      placeholder="한화시스템"
                      v-model="createGroupReq.groupName"
                      :rules="[rules.nameRule]"
                      counter
                      clearable
                      required
                  />
                  <v-btn
                      class="mt-7"
                      :color="color.kipMainColor"
                      :loading="loading"
                      text="수정"
                      type="submit"
                      block
                  />

                </v-col>
              </v-row>
            </v-form>
            <v-btn
                class="mt-7"
                color="error"
                text="영구 삭제"
                @click="DeleteGruopFromDataBase"
                block
            />
          </v-sheet>
        </v-dialog>

        <!--           ☝️ 상위 그룹 선택을 위한 모달 -->
        <v-dialog
            class="d-flex justify-center"
            width="35vw"
            opacity="75%"
            v-model="selectSuperGroupModal">
          <v-sheet
              rounded="xl"
              class="d-flex justify-center flex-wrap pa-10">

            <h1></h1>
            <v-treeview
                :items="group.getHierarchyInfo"
                color="blue">
              <template v-slot:prepend="{ item }">
                <v-icon
                    v-if="item.children"
                    :icon="`mdi-${item.children.length === 0
                                ? 'account-group-outline' : 'folder-network'}`"
                    @click="SetSuperGroupIdAndName(item)"
                />
              </template>
              <template v-slot:title="{ item }">
                <div @click="SetSuperGroupIdAndName(item)">
                  {{ item.title }} {{ item.groupType === "DEPARTMENT" ? '&nbsp 🏢' : '&nbsp 🚀' }}
                </div>
              </template>
            </v-treeview>
          </v-sheet>
        </v-dialog>

        <!--           🏢 그룹생성을 위한 모달 -->
        <v-dialog
            class="d-flex justify-center"
            width="30vw"
            opacity="50%"
            v-model="createNewGroupModal">
          <v-sheet
              rounded="xl"
              class="d-flex justify-center flex-wrap pa-10">

            <v-form ref="form" style="width: 50vw" @submit.prevent="createNewGruopWidhReq">
              <v-row>
                <v-col>
                  <h2>{{ clickedGroupName }} 소속</h2>
                  <v-radio-group
                      class="mt-5"
                      v-model="createGroupReq.groupType"
                      :color="color.kipMainColor"
                      inline>
                    <v-radio
                        label="🏢 부서조직"
                        value="DEPARTMENT"/>
                    <v-radio
                        label="🚀 NewBiz팀"
                        value="BUSINESS"/>
                  </v-radio-group>
                  <v-text-field
                      label="신규 그룹 이름"
                      placeholder="한화시스템"
                      v-model="createGroupReq.groupName"
                      :rules="[rules.nameRule]"
                      clearable
                      required
                  />

                  <v-btn
                      class="mt-7"
                      color="success"
                      :loading="loading"
                      text="신규 그룹 생성하기"
                      type="submit"
                      block
                  />
                </v-col>
              </v-row>
            </v-form>
          </v-sheet>
        </v-dialog>

      </v-col>

      <!-- 👉👉👉👉👉👉👉👉👉👉 오른쪽 구성원 리스트-->
      <v-col cols="8">

        <!--          🧑‍🦱  그룹에 소속된 회원 리스트-->
        <v-row>
          <v-col>
            <v-sheet
                class="d-flex flex-wrap">
              <v-card
                  width="100%"
                  class="mb-5 ml-5"
                  min-width="100"
                  max-width="240"
                  rounded="xl"
                  elevation="5"
              >
                <v-img
                    class="align-end text-white"
                    height="200"
                    :src="`/images/profile/user${Math.ceil((Math.random() * 14))}.jpg`"
                    cover
                >
                </v-img>
                <v-card-title v-text="`❤️ ${groupUser.getGroupName}`"/>
                <v-card-subtitle v-text="groupUser.getGroupType === 'DEPARTMENT' ? '🏢 부서조직': '🚀 NewBiz팀' "/>

                <v-card-actions class="d-flex justify-center">
                  <!--              신규 팀원 추가 버튼-->
                  <v-btn
                      @click="setAllUserInfoInKip"
                      variant="elevated"
                      color="green-lighten-1"
                      class="ma-2 px-4"
                      text="신규팀원추가"/>
                </v-card-actions>
              </v-card>

              <v-card
                  width="100%"
                  v-for="user in groupUser.getUsersInfoInGroup"
                  :key="user.userId"
                  class="mb-5 ml-5"
                  min-width="200"
                  max-width="240"
                  rounded="xl"
                  elevation="5"
              >
                <v-img
                    class="align-end text-white"
                    height="200"
                    :src="user['profileImageUrl']"
                    cover
                >
                </v-img>
                <v-card-title v-text="`${user.groupRole === 'SUPER'? '👑' : '✅'} ${user.name} `"/>
                <v-card-subtitle v-text="`📞 ${user.phoneNumber}`"/>


                <v-card-actions class="d-flex justify-center">
                  <v-btn
                      @click="groupUser.updateUserRoleInGroup(clickedGroupId, user.userId)"
                      variant="elevated"
                      :color="color.kipMainColor"
                      class="ma-2 px-3"
                      text="역할변경"/>
                  <v-btn
                      @Click="deleteUserFromGroup(clickedGroupId, user.userId)"
                      variant="elevated"
                      color="red-lighten-2"
                      class="ma-2 px-3"
                      text="그룹제외"/>
                </v-card-actions>
              </v-card>
            </v-sheet>
          </v-col>
        </v-row>

        <!--          ✅ 그룹에 사원 추가를 위한 모달 -->
        <v-dialog
            width="80vw"
            opacity="15%"
            v-model="addNewMemberModdal">
          <v-sheet
              rounded="xl"
              class="d-flex justify-center flex-wrap pa-10">
            <v-card
                width="100%"
                class="mb-5 ml-5"
                min-width="100"
                max-width="240"
                rounded="xl"
                elevation="5">
              <v-img
                  class="align-end text-white"
                  height="200"
                  :src="`/images/profile/user${Math.ceil((Math.random() * 14))}.jpg`"
                  cover
              >
              </v-img>
              <v-card-title
                  v-text="`❤️ ${groupUser.getGroupName}`"/>
              <v-card-subtitle
                  v-text="groupUser.getGroupType === 'DEPARTMENT' ? '🏢 부서조직': '🚀 NewBiz팀' "/>

              <v-card-actions class="d-flex justify-center">
                <!--              신규 팀원 추가 버튼-->
                <v-btn
                    @click="createMemberModdal=true"
                    variant="elevated"
                    color="blue-lighten-1"
                    class="ma-2 px-4"
                    text="신규계정생성"/>
              </v-card-actions>
            </v-card>

            <!--           그룹에 소속된 회원 리스트-->
            <v-card
                width="100%"
                v-for="userIn in groupUser.getAllUserInfoInKip"
                :key="userIn.userId"
                class="mb-5 ml-5"
                min-width="100"
                max-width="240"
                rounded="xl"
                elevation="5">
              <v-img
                  class="align-end text-white"
                  height="200"
                  :src="userIn['profileImageUrl']"
                  cover>
              </v-img>
              <v-card-title v-text="`🐋 ${userIn.name} `"/>
              <v-card-subtitle v-text="`📞 ${userIn.phoneNumber}`"/>

              <v-card-actions class="d-flex justify-center">
                <v-btn
                    @Click="addUserToGroup(userIn.userId)"
                    variant="elevated"
                    color="deep-purple-lighten-1"
                    class="ma-2 px-3"
                    :text="`팀원 추가`"/>
                <v-btn
                    @Click="deletUserFromDataBaese(userIn.employeeId, userIn.name)"
                    variant="elevated"
                    color="red"
                    class="ma-2 px-3"
                    :text="`영구 삭제`"/>
              </v-card-actions>
            </v-card>
          </v-sheet>
        </v-dialog>

        <!--          🥩 신규 회원 생성을 위한 모달 -->
        <v-dialog
            class="d-flex justify-center"
            width="70vw"
            opacity="50%"
            v-model="createMemberModdal">
          <v-sheet
              rounded="xl"
              class="d-flex justify-center flex-wrap pa-10">

            <!--           ❤️ 그룹에 소속된 회원 리스트-->
            <v-form ref="form" style="width: 75vw" @submit.prevent="CreateNewUser">
              <v-row>
                <v-col>
                  <v-text-field
                      label="아이디"
                      model-value="자동 발급"
                      hint="신규 사용자는 asm-0001부터 순차 발급됩니다. 관리자 계정은 asm-1234 입니다."
                      persistent-hint
                      readonly
                  />
                  <v-text-field
                      label="초기 비밀번호"
                      :model-value="DEFAULT_USER_PASSWORD"
                      hint="모든 신규 사용자 초기 비밀번호는 1234로 고정됩니다."
                      persistent-hint
                      readonly
                  />
                  <v-text-field
                      label="이름"
                      placeholder="홍길동"
                      v-model="data.name"
                      :rules="[rules.nameRule]"
                      clearable
                      required
                  />
                  <v-text-field
                      label="연락처"
                      placeholder="010-1234-5678"
                      v-model="data.phoneNumber"
                      :rules="[rules.phoneNumberRule, rules.phoneNumberDupulicateCheck]"
                      clearable
                      maxlength="13"
                      required
                      counter
                  />
                  <v-text-field
                      label="이메일"
                      placeholder="admin@kip.com"
                      v-model="data.email"
                      :rules="[rules.emailRule, rules.emailDupulicateCheck]"
                      clearable
                      required
                  />
                  <v-text-field
                      v-model="data.employedDay"
                      label="입사일"
                      :rules="[rules.employedDayRule]"
                      required
                      clearable
                  />
                </v-col>
                <v-col>
                  <v-date-picker
                      v-model="employedDay"
                      width="100%"
                      @click="formattedDate"
                      show-adjacent-months
                  />
                  <v-btn
                      class="mt-4"
                      color="success"
                      :loading="loading"
                      text="신규 계정 생성하기"
                      type="submit"
                      block
                  />
                </v-col>
              </v-row>
            </v-form>
          </v-sheet>
        </v-dialog>

        <!--          📁 그룹에 소속된 문서 리스트-->
        <v-row>
          <v-col>
            <v-sheet
                class="d-flex flex-wrap">
              <v-card
                  width="100%"
                  v-for="doc in document.getAdminDocumentList"
                  :key="doc.documentId"
                  class="mb-4 ml-5 pt-2 px-1 pb-1"
                  rounded="xl"
                  elevation="5"
                  clase="d-flex">
                <div class="d-flex justify-space-between">
                  <v-card-title
                      class="ellipsis"
                      style="width:25vw"
                      v-text="`${doc.docType === 'SECTION' ? '⏩' :
                        '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp' +
                         '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp'}
                         ${doc.title}`"/>
                  <v-card-actions class="d-flex justify-space-evenly">

                    <!--           ☝️ 전체 공개 버튼 -->
                    <v-hover v-slot="{ isHovering, props }">
                      <v-btn
                          v-if="!handlerTargetButtonForMove"
                          text="전체공개"
                          @click="makePublicDocument(doc.title, doc.documentId)"
                          v-bind="props"
                          :class="{
                            'on-hover': isHovering,
                            'public-btns': isHovering
                          }"
                          class="px-3 mr-2 mt-1"
                          color="rgba(255, 255, 255, 0)"
                          variant="outlined"
                          rounded="xl"
                      />
                      <v-btn
                          v-if="!handlerTargetButtonForMove"
                          text="영구삭제"
                          @click="deleteDocument(doc.title, doc.documentId)"
                          v-bind="props"
                          :class="{
                            'on-hover': isHovering,
                            'delete-btns': isHovering
                          }"
                          class="px-3 mr-2 mt-1"
                          color="rgba(255, 255, 255, 0)"
                          variant="outlined"
                          rounded="xl"
                      />
                      <v-btn
                          v-if="!handlerTargetButtonForMove"
                          text="문서이동"
                          @click="realShowTargetButton(doc.documentId)"
                          v-bind="props"
                          :class="{
                            'on-hover': isHovering,
                            'move-btns': isHovering
                          }"
                          class="px-3 mr-2 mt-1"
                          color="rgba(255, 255, 255, 0)"
                          variant="outlined"
                          rounded="xl"
                      />

                    </v-hover>

                    <!--          ➡️ 권한 요청 버튼 -->
                    <v-btn
                        v-if="handlerTargetButtonForMove
                        && doc.documentId !== moveDocumentReq.startDocId"
                        text="이동할곳"
                        variant="elevated"
                        color="red-lighten-1"
                        class="px-4 mr-4 mt-1"
                        rounded="xl"
                        @click="RealMoveDocumnet(doc.documentId)"
                    />
                    <v-btn
                        text="권한요청"
                        @click="sendRequest(doc.documentUUID)"
                        variant="elevated"
                        color="blue-lighten-1"
                        class="px-4 mr-4 mt-1"
                        rounded="xl"
                    />

                  </v-card-actions>
                </div>
              </v-card>
            </v-sheet>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
    <v-dialog
        class="d-flex"
        width="25vw"
        opacity="10%"
        v-model="sendRequestModal">
      <v-card
          rounded="xl"
          class="pa-5">
        <v-card-title class="headline">권한 요청</v-card-title>
        <v-card-text>해당 글에 권한 요청을 하시겠습니까?
          <v-text-field
              v-model="requestDays"
              label="요청 일수"
              type="number"
              min="1"
              max="30"
              step="1"
          ></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
              variant="elevated"
              :color="color.kipMainColor" @click="confirmRequest">요청
          </v-btn>
          <v-btn color="blue darken-1" @click="sendRequestModal = false">취소</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>
<style scoped>
.show-btns {
  color: var(--primary-color) !important;
}

.delete-btns {
  color: #ff0000 !important;
}

.move-btns {
  color: #0066ff !important;
}

.public-btns {
  color: #57af3d !important;
}

</style>
