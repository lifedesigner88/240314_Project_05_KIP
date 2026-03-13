<script setup lang="ts">

import {useRequest} from "~/stores/Request";
import _ from 'lodash';
import {useColor} from "#imports";

const props = defineProps<{
  isOpen: boolean
}>();
const keyword = ref();
const pageNumber = ref(0);
const documentSearch = useDocumentSearch()
const sendRequestModal = ref(false);
const requestDays = ref(30);
const request = useRequest();
const docUUID = ref();
const color = useColor();

const emit = defineEmits(['closeModal']);
const showEmptyState = computed(() => {
  const normalizedKeyword = keyword.value?.trim() ?? '';
  return normalizedKeyword
      && documentSearch.getHasSearched
      && !documentSearch.getIsLoading
      && documentSearch.getSearchDocument.length === 0;
});

const resetSearchState = () => {
  keyword.value = '';
  pageNumber.value = 0;
  documentSearch.resetSearch();
};

const confirmRequest = async () => {
  if (requestDays.value < 1) {
    alert("최소 요청일수는 1일 입니다.")
    requestDays.value = 30;
    return
  }
  await request.sendRequest(docUUID.value, requestDays.value);
  sendRequestModal.value = false;
}
const debouncedSearch = _.debounce(async () => {
  const normalizedKeyword = keyword.value?.trim() ?? '';
  if (normalizedKeyword) {
    await documentSearch.setSearchDocument(normalizedKeyword, pageNumber.value);
    return;
  }
  documentSearch.resetSearch();
}, 500);

const handleInput = () => {
  pageNumber.value = 0;
  const normalizedKeyword = keyword.value?.trim() ?? '';
  if (!normalizedKeyword) {
    debouncedSearch.cancel();
    documentSearch.resetSearch();
    return;
  }
  debouncedSearch();
};

const viewDocument = async (documentUUID: string) => {
  await documentSearch.viewDocument(documentUUID);
  const canView: any = documentSearch.getAvailable;
  if (canView === `Public Document`) {
    await navigateTo(`/publicOpenDoc`)
    emit('closeModal')
  }
  if (canView === `Group User`) {
    const groupNumber = documentSearch.getGroupId.groupId;
    await navigateTo(`/group/${groupNumber}`)
    emit('closeModal')
  }
  if (canView === `Available User`) {
    await navigateTo('/agree')
    emit('closeModal')
  }
  if (canView === `Unavailable User`) {
    docUUID.value = documentUUID
    sendRequestModal.value = true;
  }
}
function toolTipFunction()  {
  const canView: any = documentSearch.getAvailable;
  if (canView === `Public Document`) return "전체공개 이동"
  if (canView === `Group User`) return "해당 그룹 이동"
  if (canView === `Available User`) return "승인문서 이동"
  if (canView === `Unavailable User`) return "권한요청 필요"
  return ""
}
const removeHTMLTags = (str: string) => {
  let output = str.replace(/<[^>]*>/g, '');
  output = output.replace(/&[^;]+;/g, '');
  output = output.replace(/[^a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣 ]/g, '');
  return output;
};

watch(() => props.isOpen, (isOpen) => {
  if (!isOpen) {
    debouncedSearch.cancel();
    resetSearchState();
  }
});

onUnmounted(() => {
  debouncedSearch.cancel();
  documentSearch.resetSearch();
});

</script>

<template>
  <v-sheet
      width="65vw"
      class="pa-6 px-8"
      rounded="xl"
  >
    <div v-if="documentSearch.getSearchDocument.length > 1"
         style="width:100%; display: flex; justify-content: end; margin-bottom: 15px; color: #ff9898">
      {{ documentSearch.getTotalPagesCount }}개의 연관문서가 검색되었습니다.
    </div>
    <v-text-field
        class="input__Search mt-3 px-4"
        rounded="xl"
        variant="solo-inverted"
        placeholder="검색할 단어를 입력하세요"
        v-model="keyword"
        @input="handleInput">
    </v-text-field>
    <div
        v-if="documentSearch.getIsLoading"
        class="d-flex flex-column align-center justify-center py-10"
    >
      <v-progress-circular
          indeterminate
          :color="color.kipMainColor"
          size="36"
          width="4"
      />
      <div class="mt-4" style="color: rgba(119,119,119,0.8);">
        검색 중입니다...
      </div>
    </div>
    <div
        v-else-if="showEmptyState"
        class="d-flex flex-column align-center justify-center py-10"
    >
      <div class="Search__empty-title">
        검색 결과가 없습니다.
      </div>
      <div class="Search__empty-description mt-2">
        다른 단어로 다시 검색해보세요.
      </div>
    </div>
    <v-list v-else lines="one">
      <v-list-item
          class="px-2"
          rounded="xl"
          v-for="searchedDoc in documentSearch.getSearchDocument"
          :key="searchedDoc.uuid"
          @click="viewDocument(searchedDoc.uuid)"
          @mouseenter="documentSearch.viewDocument(searchedDoc.uuid);"
      >
        <v-tooltip
            activator="parent"
            location="end"
            :text="toolTipFunction()"/>
        <div style="width:100%; display:flex; align-items: center; justify-content: space-between;" class="my-1">
          <span class="Search__head"> 📜 {{ searchedDoc.title }} </span>
          <span class="Search__group"> {{ searchedDoc.groupName }} 🚀  </span>
        </div>
        <div class="ellipsis Serch__content"
             style="width:100%; color:rgba(119,119,119,0.51); font-weight: 400; font-size: 13px">
          {{ removeHTMLTags(searchedDoc.content) }}</div>
      </v-list-item>
    </v-list>
    <div class="pa-4 d-flex justify-space-between">
      <v-row v-if="documentSearch.getSearchDocument.length > 1">
        <v-col cols="3">
          <v-btn
              v-if="pageNumber > 0"
              @click="pageNumber-- ; debouncedSearch()"
              style="font-size: 15px; height: 40px"
              :color="color.kipMainColor"
              variant="elevated"
              min-width="92"
              rounded
          >
            이전
          </v-btn>
        </v-col>
        <v-col cols="6" class="d-flex justify-center pt-6"  >
          {{ documentSearch.getCurrentPages + 1 }} / {{ documentSearch.getTotalPages }}
        </v-col>
        <v-col cols="3" class="d-flex justify-end">
          <v-btn
              v-if="pageNumber < documentSearch.totalPages"
              @click="pageNumber++ ; debouncedSearch()"
              style="font-size: 15px; height: 40px"
              :color="color.kipMainColor"
              min-width="92"
              rounded
          >
            다음
          </v-btn>
        </v-col>
      </v-row>
    </div>
  </v-sheet>
  <v-dialog
      class="d-flex"
      width="35vw"
      opacity="30%"
      v-model="sendRequestModal">
    <v-card
        rounded="xl"
        class="pa-5">
      <v-card-title class="headline">권한 요청</v-card-title>
      <v-card-text> 읽기 권한이 없습니다. 해당 글에 권한 요청을 하시겠습니까?
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
</template>

<style>
.input__Search input:focus {
  padding-left: 30px;
  color: white;
  background-color: var(--primary-color);
  border-radius: 25px;
}

.Search__head {
  font-size: 17px;
  font-weight: bold;
  color: var(--primary-color)
}

.Search__group {
  color: var(--secondary-color);
  font-size: 14px;
  font-weight: normal;

}

.Search__empty-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--primary-color);
}

.Search__empty-description {
  font-size: 14px;
  color: rgba(119, 119, 119, 0.85);
}
</style>
