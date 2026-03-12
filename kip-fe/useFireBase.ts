import { initializeApp, getApps } from 'firebase/app';
import type { FirebaseApp } from 'firebase/app';
import { getPublicRuntimeConfig, isPushEnabled } from '~/utils/runtimeConfig';

export const useFirebaseApp = (): FirebaseApp | null => {
  if (!isPushEnabled()) {
    return null;
  }

  const config = getPublicRuntimeConfig();
  let app: FirebaseApp;
  if (!getApps().length) {
    app = initializeApp({
      apiKey: config.firebaseApiKey,
      appId: config.firebaseAppId,
      authDomain: config.firebaseAuthDomain,
      databaseURL: config.firebaseDatabaseUrl,
      measurementId: config.firebaseMeasurementId,
      messagingSenderId: config.firebaseMessagingSenderId,
      projectId: config.firebaseProjectId,
      storageBucket: config.firebaseStorageBucket,
    });
  } else {
    app = getApps()[0];
  }
  return app;
};
