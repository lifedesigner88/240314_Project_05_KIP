import type {DefaultConfigOptions} from "@formkit/vue";
import {createAutoAnimatePlugin} from "@formkit/addons"
import {
    EMPLOYEE_ID_FORMAT_MESSAGE,
    EMPLOYEE_ID_NOT_FOUND_MESSAGE,
    PASSWORD_FORMAT_MESSAGE,
} from "./utils/employeeIdPolicy.js";

const config: DefaultConfigOptions = {
    theme: "genesis",
    plugins: [createAutoAnimatePlugin()], // 입력 폼 애니메이션 플러그인.
    messages: {
        en: {
            validation: {
                id_check: EMPLOYEE_ID_NOT_FOUND_MESSAGE,
                matches: EMPLOYEE_ID_FORMAT_MESSAGE,
                pass_check: '잘못된 비밀번호 입니다.',
                password_Regex: PASSWORD_FORMAT_MESSAGE

            }
        }
    },
}
export default config;
