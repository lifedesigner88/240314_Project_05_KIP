export const getPublicRuntimeConfig = () => useRuntimeConfig().public;

const isLocalHost = (hostname) => hostname === 'localhost' || hostname === '127.0.0.1' || hostname === '::1';

export const getApiBaseUrl = () => {
  const configuredBaseUrl = getPublicRuntimeConfig().apiBaseUrl;

  if (!import.meta.client || !configuredBaseUrl) {
    return configuredBaseUrl;
  }

  try {
    const url = new URL(configuredBaseUrl);
    const currentHostname = window.location.hostname;

    // If the app is opened through a remote host/IP but the configured API still
    // points to localhost, follow the current host and keep the backend port.
    if (isLocalHost(url.hostname) && currentHostname && !isLocalHost(currentHostname)) {
      url.hostname = currentHostname;
      return url.toString().replace(/\/$/, '');
    }
  } catch {
    return configuredBaseUrl;
  }

  return configuredBaseUrl;
};

export const isPushEnabled = () => {
  const value = getPublicRuntimeConfig().pushEnabled;
  return value === true || value === 'true';
};
