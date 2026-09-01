import { messaging } from './firebaseAdmin.mjs';
import { getLowBatteryObjectsWithTokens, cleanInvalidFcmToken } from '../models/notification.mjs';

const getLowBatteryMessage = (title, batteryLvl) => {
  const messages = [
    {
      title: `🪫 ${title} est épuisé`,
      body: `Bzzzt... Plus que ${batteryLvl}% d'énergie. Branche-moi vite avant que je m'endorme !`
    },
    {
      title: `⚠️ ${title} a faim !`,
      body: `Il ne me reste que ${batteryLvl}% de batterie... Je vais bientôt m'éteindre !`
    },
    {
      title: `⚡ ${title} appelle à l'aide`,
      body: `Niveau de charge critique (${batteryLvl}%). Recharge-moi pour que je continue de veiller sur tes plantes !`
    }
  ];
  return messages[Math.floor(Math.random() * messages.length)];
};

async function checkAndSendLowBatteryNotifications() {
  try {
    const lowBatteryItems = await getLowBatteryObjectsWithTokens();

    if (lowBatteryItems.length === 0) {
      console.log('[Notification] Aucune batterie faible détectée.');
      return;
    }

    console.log(`[Notification] Traitement de ${lowBatteryItems.length} objet(s)...`);

    // 1. Préparation de la liste complète des messages
    const messages = lowBatteryItems.map(item => {
      const payload = getLowBatteryMessage(item.object_title, item.battery_lvl);
      return {
        notification: {
          title: payload.title,
          body: payload.body,
        },
        token: item.fcm_token,
      };
    });

    // 2. Découpage par lots de 500 messages max (limite de l'API Firebase)
    const BATCH_SIZE = 500;
    for (let i = 0; i < messages.length; i += BATCH_SIZE) {
      const batch = messages.slice(i, i + BATCH_SIZE);
      
      // Envoi groupé en parallèle
      const response = await messaging.sendEach(batch);

    if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
            if (!resp.success) {
            const error = resp.error;
            // Code d'erreur Firebase indiquant un token expiré/invalide
            if (
                error.code === 'messaging/invalid-registration-token' ||
                error.code === 'messaging/registration-token-not-registered'
            ) {
                const invalidToken = batch[idx].token;
                console.log(`[Notification] Nettoyage du token obsolète : ${invalidToken}`);
                // Appel d'une fonction pour mettre le token à NULL en BDD
                cleanInvalidFcmToken(invalidToken);
            }
            }
        });
        }
        console.log(`[Notification] Lot envoyé : ${response.successCount} succès, ${response.failureCount} échecs.`);
    }

  } catch (error) {
    console.error('[Notification] Erreur globale lors de la vérification :', error);
  }
}

export { checkAndSendLowBatteryNotifications };