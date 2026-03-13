import { getApiBaseUrl } from "~/utils/runtimeConfig";

const BASE_URL = { toString: () => getApiBaseUrl() };
const getUserStore = () => useUser();

export const useCreateDocument = defineStore("createDocument", {
  state() {
    return {
      form: {}
    };
  },
  getters: {

  },

  actions: {
    async createNewDocument(form) {
      try {
        const response = await fetch(`${BASE_URL}/doc`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + getUserStore().getAccessToken},
          body: JSON.stringify(form),
        });
        const temp = await response.json();
        return temp;
      } catch (error) {
        console.error('Error fetching bookmarks:', error.message);
      }
    },
  }
});
