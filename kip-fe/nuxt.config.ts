import vuetify, {transformAssetUrls} from 'vite-plugin-vuetify'
// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    devtools: {enabled: true},
    ssr: false,
    css: ['~/assets/styles/global.css'],
    runtimeConfig: {
        public: {
            apiBaseUrl: process.env.NUXT_PUBLIC_API_BASE_URL || 'http://localhost:8080',
            pushEnabled: process.env.NUXT_PUBLIC_PUSH_ENABLED || 'false',
            firebaseApiKey: process.env.NUXT_PUBLIC_FIREBASE_API_KEY || '',
            firebaseAppId: process.env.NUXT_PUBLIC_FIREBASE_APP_ID || '',
            firebaseAuthDomain: process.env.NUXT_PUBLIC_FIREBASE_AUTH_DOMAIN || '',
            firebaseDatabaseUrl: process.env.NUXT_PUBLIC_FIREBASE_DATABASE_URL || '',
            firebaseMeasurementId: process.env.NUXT_PUBLIC_FIREBASE_MEASUREMENT_ID || '',
            firebaseMessagingSenderId: process.env.NUXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID || '',
            firebaseProjectId: process.env.NUXT_PUBLIC_FIREBASE_PROJECT_ID || '',
            firebaseStorageBucket: process.env.NUXT_PUBLIC_FIREBASE_STORAGE_BUCKET || '',
            firebaseVapidKey: process.env.NUXT_PUBLIC_FIREBASE_VAPID_KEY || '',
        }
    },
    imports: { // stores 폴더에 있는 것들 모두 임포트
        dirs: ["stores"],
    },
    build: {
        transpile: ['vuetify'],
    },

    modules: [
        (_options, nuxt) => {
            nuxt.hooks.hook('vite:extendConfig', (config) => {
                // @ts-expect-error
                config.plugins.push(vuetify({autoImport: true}))
            })
        }, // Nuxt 전용 뷰티파이 불러오는 설정
        ['@pinia/nuxt', {
            autoImports: ["defineStore", "acceptHMRUpdate"]  // 피니아 생성시 임포트 생략
        }],
        '@formkit/nuxt',
        '@vueuse/nuxt',
    ],
    vite: {
        vue: {
            template: {
                transformAssetUrls,
            },
        },
        css: { // CSS파일을 빌드할때 추가하는 설정 (로그인에서 CSS가 빌드가 안됨) 효과없음.
            preprocessorOptions: {
                includePaths: ['node_modules']
            }
        }
    },
    nitro: {
        routeRules: {
            // toast-ui editor 가 SSR 을 지원하지 않아 reload시 에러가 나는것을 방지
            "editor/toast": {
                ssr: false,
            },
        },
    },

})
