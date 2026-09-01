import { messaging } from './firebaseAdmin.mjs';

const registeredTokens = new Set();

export function saveFcmToken(token) {
  if (token) {
    registeredTokens.add(token);
    console.log(`[Notification] Token enregistré : ${token}`);
  }
}

export async function sendPingNotificationToAll() {
  const tokens = Array.from(registeredTokens);

  if (tokens.length === 0) {
    console.log('[Notification] Aucun token enregistré pour l\'envoi.');
    return;
  }

  const message = {
    notification: {
      title: 'GDOME Status',
      body: 'OK ça marche',
    },
    tokens: tokens,
  };

  try {
    const response = await messaging.sendEachForMulticast(message);
    console.log(`[Notification] ${response.successCount} notification(s) envoyée(s).`);
  } catch (error) {
    console.error('[Notification] Erreur d\'envoi :', error);
  }
}