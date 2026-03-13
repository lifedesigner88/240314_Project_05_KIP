<script setup>
import { ref, reactive, watch } from 'vue';
import { useUser } from "@/stores/User";

const DEMO_DISABLED_MESSAGE = '수정불가 (Demo)';

const currentTab = ref('info');
const userStore = useUser();
const userInfo = ref({});
const password = reactive({
  current: '',
  new: '',
  confirm: ''
});
const showPassword = ref(false);
const isCurrentPasswordValid = ref(false);
const passwordErrors = reactive({
  current: [],
  new: [],
  confirm: []
});

const syncUserInfo = (value) => {
  userInfo.value = { ...(value || {}) };
};

const validateCurrentPassword = async () => {
  passwordErrors.current = [];
  if (!password.current) {
    passwordErrors.current.push("현재 비밀번호를 입력하세요.");
    return;
  }

  try {
    const isValid = await userStore.validateCurrentPassword(password.current);
    isCurrentPasswordValid.value = isValid;

    if (!isValid) {
      passwordErrors.current.push("현재 비밀번호가 올바르지 않습니다.");
    }
  } catch (error) {
    console.error('비밀번호 검증 중 오류 발생:', error);
    alert('비밀번호 검증 중 문제가 발생했습니다.');
  }
};

const validateNewPassword = () => {
  passwordErrors.new = [];
  const isNumeric = /^\d+$/.test(password.new);
  if (!isNumeric || password.new.length !== 4) {
    passwordErrors.new.push("비밀번호는 4자리 숫자여야 합니다.");
  }
};

const toggleShowPassword = () => {
  showPassword.value = !showPassword.value;
};

watch(
  () => userStore.userInfo,
  (value) => {
    syncUserInfo(value);
  },
  { deep: true, immediate: true }
);

watch(password, () => {
  if (password.new !== password.confirm) {
    passwordErrors.confirm = ["비밀번호가 일치하지 않습니다."];
  } else {
    passwordErrors.confirm = [];
  }
}, { deep: true });
</script>

<template>
  <v-row class="px-10 py-6 mt-2">
    <v-col>
      <v-tabs v-model="currentTab" centered>
        <v-tab
            class="px-16"
            style="font-size: 18px"
            key="info" value="info">ℹ️ 개인 정보
          <v-tooltip
              activator="parent"
              location="bottom"
          >읽기전용
          </v-tooltip>
        </v-tab>
        <v-tab
            class="px-16"
            style="font-size: 18px"
            key="password" value="password"> 🗝️ 비밀번호 변경
          <v-tooltip
              activator="parent"
              location="bottom"
          >읽기전용
          </v-tooltip>
        </v-tab>
      </v-tabs>
    </v-col>
  </v-row>

  <v-row justify="center" class="my-5">
    <v-col cols="12" md="10" lg="8">
      <v-fade-transition mode="out-in">
        <div v-if="currentTab === 'info'" :key="'info'">
          <v-card rounded="xl" class="my-card" outlined>
            <v-card-title class="headline">개인 정보 ℹ️</v-card-title>
            <v-row>
              <v-col cols="6" class="d-flex flex-row justify-center align-center">
                <v-img
                    rounded="xl"
                    class="align-end text-white mx-16"
                    style="height: 250px !important; width: 250px !important;"
                    :src="userStore.getProfileImageUrl"
                    cover
                />
              </v-col>
              <v-col cols="6">
                <v-card-text class="mr-10">
                  <v-text-field label="이름" outlined dense v-model="userInfo.name" />
                  <v-text-field label="아이디" outlined dense v-model="userInfo.employeeId" readonly />
                  <v-text-field label="이메일" outlined dense v-model="userInfo.email" />
                  <v-text-field label="전화번호" outlined dense v-model="userInfo.phoneNumber" />
                  <v-text-field
                      label="고용된 날짜"
                      outlined
                      dense
                      v-model="userInfo.employedDay"
                      readonly
                  />
                </v-card-text>
              </v-col>
            </v-row>
            <v-card-actions class="demo-card-actions">
              <p class="demo-disabled-note">{{ DEMO_DISABLED_MESSAGE }}</p>
            </v-card-actions>
          </v-card>
        </div>

        <div v-if="currentTab === 'password'" :key="'password'">
          <v-card rounded="xl" class="my-card" outlined>
            <v-card-title class="headline mb-7">비밀번호 변경 🗝️</v-card-title>
            <v-card-text class="headline my-4 mx-10">
              <v-text-field
                  v-model="password.current"
                  :type="showPassword ? 'text' : 'password'"
                  label="현재 비밀번호"
                  outlined
                  dense
                  append-icon="mdi-eye"
                  @click:append="toggleShowPassword"
                  @input="validateCurrentPassword"
                  :error-messages="passwordErrors.current"
              />
              <v-text-field
                  v-model="password.new"
                  :type="showPassword ? 'text' : 'password'"
                  label="새로운 비밀번호"
                  outlined
                  dense
                  append-icon="mdi-eye"
                  @input="validateNewPassword"
                  :error-messages="passwordErrors.new"
                  required
              />
              <v-text-field
                  v-model="password.confirm"
                  :type="showPassword ? 'text' : 'password'"
                  label="새로운 비밀번호 확인"
                  outlined
                  dense
                  append-icon="mdi-eye"
                  :error-messages="passwordErrors.confirm"
                  required
              />
            </v-card-text>
            <v-card-actions class="demo-card-actions">
              <p class="demo-disabled-note">{{ DEMO_DISABLED_MESSAGE }}</p>
            </v-card-actions>
          </v-card>
        </div>
      </v-fade-transition>
    </v-col>
  </v-row>
</template>

<style scoped>
.my-card {
  max-width: 60vw;
  width: 100%;
  padding: 30px;
  display: flex;
  flex-direction: column;
}

.demo-card-actions {
  padding: 0 24px 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.demo-disabled-note {
  margin: 0;
  font-size: 0.95rem;
  color: #5f6368;
}
</style>
