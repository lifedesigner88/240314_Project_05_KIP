export const getPublicRuntimeConfig = () => useRuntimeConfig().public;

export const getApiBaseUrl = () => getPublicRuntimeConfig().apiBaseUrl;

export const isPushEnabled = () => {
  const value = getPublicRuntimeConfig().pushEnabled;
  return value === true || value === 'true';
};
