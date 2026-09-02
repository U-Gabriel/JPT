import { messaging } from './firebaseAdmin.mjs';
import { getLowBatteryObjectsWithTokens, getDangerPlantObjectsWithTokens, getDisconnectedObjectsWithTokens, cleanInvalidFcmToken } from '../models/notification.mjs';

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

/**
 * Générateur de messages d'urgence pour plante en danger
 */
const getDangerPlantMessage = (title) => {
  const messages = [
    {
      title: `🚨 ${title} est en danger !`,
      body: `Urgence ! Ta plante nécessite une attention immédiate avant qu'il ne soit trop tard.`
    },
    {
      title: `⚠️ Au secours ! ${title} va très mal`,
      body: `Mon état est critique. Viens vite vérifier mes paramètres !`
    },
    {
      title: `🌱 SOS pour ${title}`,
      body: `Ta plante appelle à l'aide ! Ouvre l'application pour voir ce qu'il se passe.`
    }
  ];
  return messages[Math.floor(Math.random() * messages.length)];
};

async function checkAndSendDangerPlantNotifications() {
  try {
    const dangerItems = await getDangerPlantObjectsWithTokens();

    if (dangerItems.length === 0) {
      console.log('[Notification] Aucune plante en danger détectée.');
      return;
    }

    console.log(`[Notification] Traitement de ${dangerItems.length} plante(s) en danger...`);

    // 1. Préparation de la liste complète des messages
    const messages = dangerItems.map(item => {
      const payload = getDangerPlantMessage(item.object_title);
      return {
        notification: {
          title: payload.title,
          body: payload.body,
        },
        token: item.fcm_token,
      };
    });

    // 2. Découpage par lots de 500 messages max (limite de l'API FCM Batch)
    const BATCH_SIZE = 500;
    for (let i = 0; i < messages.length; i += BATCH_SIZE) {
      const batch = messages.slice(i, i + BATCH_SIZE);
      
      const response = await messaging.sendEach(batch);

      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            const error = resp.error;
            if (
              error.code === 'messaging/invalid-registration-token' ||
              error.code === 'messaging/registration-token-not-registered'
            ) {
              const invalidToken = batch[idx].token;
              console.log(`[Notification] Nettoyage du token obsolète : ${invalidToken}`);
              cleanInvalidFcmToken(invalidToken);
            }
          }
        });
      }
      console.log(`[Notification] Lot plantes en danger envoyé : ${response.successCount} succès, ${response.failureCount} échecs.`);
    }

  } catch (error) {
    console.error('[Notification] Erreur globale lors de la vérification des plantes en danger :', error);
  }
}

/**
 * Générateur de messages pour objet hors-ligne / déconnecté
 */
const getDisconnectedMessage = (title) => {
  const messages = [
    {
      title: `📡 ${title} ne répond plus`,
      body: `Nous n'avons plus de nouvelles de ton objet depuis plus de 24h. Vérifie sa connexion Wi-Fi !`
    },
    {
      title: `🔌 Connexion perdue avec ${title}`,
      body: `Ton objet n'a pas transmis de données aujourd'hui. Est-il bien allumé ?`
    },
    {
      title: `❓ Où est passé ${title} ?`,
      body: `Aucun signe de vie depuis plus de 24 heures. Pense à jeter un œil.`
    }
  ];
  return messages[Math.floor(Math.random() * messages.length)];
};

async function checkAndSendDisconnectedNotifications() {
  try {
    const disconnectedItems = await getDisconnectedObjectsWithTokens();

    if (disconnectedItems.length === 0) {
      console.log('[Notification] Aucun objet déconnecté détecté.');
      return;
    }

    console.log(`[Notification] Traitement de ${disconnectedItems.length} objet(s) déconnecté(s)...`);

    const messages = disconnectedItems.map(item => {
      const payload = getDisconnectedMessage(item.object_title);
      return {
        notification: {
          title: payload.title,
          body: payload.body,
        },
        token: item.fcm_token,
      };
    });

    const BATCH_SIZE = 500;
    for (let i = 0; i < messages.length; i += BATCH_SIZE) {
      const batch = messages.slice(i, i + BATCH_SIZE);
      
      const response = await messaging.sendEach(batch);

      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            const error = resp.error;
            if (
              error.code === 'messaging/invalid-registration-token' ||
              error.code === 'messaging/registration-token-not-registered'
            ) {
              const invalidToken = batch[idx].token;
              console.log(`[Notification] Nettoyage du token obsolète : ${invalidToken}`);
              cleanInvalidFcmToken(invalidToken);
            }
          }
        });
      }
      console.log(`[Notification] Lot objets déconnectés envoyé : ${response.successCount} succès, ${response.failureCount} échecs.`);
    }

  } catch (error) {
    console.error('[Notification] Erreur globale lors de la vérification des objets déconnectés :', error);
  }
}

export { checkAndSendLowBatteryNotifications, checkAndSendDangerPlantNotifications, checkAndSendDisconnectedNotifications };