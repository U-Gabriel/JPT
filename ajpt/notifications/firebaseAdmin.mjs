import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const serviceAccount = require('../config/serviceAccountKey.json');

// Initialiser l'application Firebase uniquement si elle ne l'est pas déjà
if (getApps().length === 0) {
  initializeApp({
    credential: cert(serviceAccount),
  });
}

export const messaging = getMessaging();