<script lang="ts" setup>
import {toastEditorInstance} from "~/useToastEditor";

const form = ref({
  content: "",
  message: "",
});

const emit = defineEmits(["submit"]);
const props = defineProps({
  dataToPass: String
})

const editor = ref();
onMounted(() => {
  editor.value = toastEditorInstance(
      editor.value,
      "markdown",
      false,
      false,
      "80vh",
      "문서의 내용을 여기에 작성해주세요.",
      "vertical",
      <string>props.dataToPass
  );
});
const submit = () => {
  if (props.dataToPass === editor.value.getMarkdown())
    alert("수정사항이 없습니다.")
  else {
    form.value.content = editor.value.getMarkdown();
    emit('submit', form)
  }
}

defineExpose({submit});
</script>
<template>
  <v-row>
    <v-col cols="12" style="height: 120px">
      <v-text-field
          class="input_commit"
          variant="solo-inverted"
          v-model="form.message"
          placeholder="수정사항을 간단히 적어주세요."
      />
    </v-col>
  </v-row>
  <div ref="editor" class="editor__CSS"></div>
  <!-- 내용 -->
</template>
<style>
.input_commit input {
  font-size: 25px;
  background-color: #ffdbc1;
  font-weight: bold;
  color: var(--primary-color);
}

.input_commit input:focus {
  color: white;
  background-color: var(--primary-color);
}

</style>