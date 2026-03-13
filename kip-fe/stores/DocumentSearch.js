import { getApiBaseUrl } from "~/utils/runtimeConfig";

const BASE_URL = { toString: () => getApiBaseUrl() };
const getUserStore = () => useUser();

export const useDocumentSearch = defineStore("documentSearch", {
    state() {
        return {
            rowData: {},
            document: [],
            totalPages: 0,
            isLoading: false,
            hasSearched: false,
            canView: String,
            groupId: {}
        };
    },
    getters: {
        getSearchDocument(state) {
            // 여기서는 직접적으로 필요한 객체 구조를 반환합니다.
            return state.document;
        },
        getCurrentPages(state) {
            return state.rowData.number;
        },
        getTotalPages(state) {
            return state.rowData.totalPages;
        },
        getIsLoading(state) {
            return state.isLoading;
        },
        getHasSearched(state) {
            return state.hasSearched;
        },
        getAvailable(state) {
            // 여기서는 직접적으로 필요한 객체 구조를 반환합니다.
            return state.canView
        },
        getTotalPagesCount(state) {
            return state.rowData.totalElements;
        },
        getGroupId(state) {
            return {
                groupId: state.groupId
            };
        },
    },

    actions: {
        resetSearch() {
            this.rowData = {};
            this.document = [];
            this.totalPages = 0;
            this.isLoading = false;
            this.hasSearched = false;
            this.canView = String;
            this.groupId = {};
        },
        async setSearchDocument(keyword, pageNumber) {
            this.isLoading = true;
            try {
                const response = await fetch(`${BASE_URL}/doc/search?keyword=${keyword}&pageNumber=${pageNumber}`, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + getUserStore().getAccessToken
                    },
                });
                const data = await response.json()
                this.rowData = data
                this.document = data.content;
                this.totalPages = data.totalPages - 1;
                this.hasSearched = true;
            } catch (error) {
                console.error('Error fetching search:', error.message);
            } finally {
                this.isLoading = false;
            }
        },
        async viewDocument(documentUUID) {
            try {
                const response = await fetch(`${BASE_URL}/doc/search/${documentUUID}`, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + getUserStore().getAccessToken
                    },
                });
                const data = await response.json()
                this.groupId = data.groupId;
                this.canView = data.result;
            } catch (error) {
                console.error('Error fetching search:', error.message);
            }
        },
    }
});
