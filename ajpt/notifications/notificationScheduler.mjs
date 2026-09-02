import cron from 'node-cron';
import { checkAndSendLowBatteryNotifications, checkAndSendDangerPlantNotifications, checkAndSendDisconnectedNotifications } from './notificationService.mjs';


const getCronExpression = (envVar, defaultCron) => {
  return String(envVar || defaultCron).trim();
};

const LOW_BATTERY_CRON = getCronExpression(process.env.CRON_LOW_BATTERY, '0 0 * * *');
const DANGER_PLANT_CRON = getCronExpression(process.env.CRON_DANGER_PLANT, '0 2 * * *');
const DISCONNECTED_CRON = getCronExpression(process.env.CRON_DISCONNECTED, '0 4 * * *'); 

/**
 * Planificateur pour les batteries faibles
 */
function startLowBatteryScheduler() {
  cron.schedule(LOW_BATTERY_CRON, () => {
    console.log('[Scheduler] Démarrage : Vérification de la batterie des objets...');
    
    setImmediate(async () => {
      try {
        await checkAndSendLowBatteryNotifications();
      } catch (err) {
        console.error('[Scheduler] Erreur critique lors de la vérification des batteries :', err);
      }
    });
  });

  console.log(`[Scheduler] Tâche batterie faible initialisée (${LOW_BATTERY_CRON}).`);
}

/**
 * Planificateur pour les plantes en danger
 */
function startDangerPlantScheduler() {
  cron.schedule(DANGER_PLANT_CRON, () => {
    console.log('[Scheduler] Démarrage : Vérification des plantes en danger...');
    
    setImmediate(async () => {
      try {
        await checkAndSendDangerPlantNotifications();
      } catch (err) {
        console.error('[Scheduler] Erreur critique lors de la vérification des plantes :', err);
      }
    });
  });

  console.log(`[Scheduler] Tâche plantes en danger initialisée (${DANGER_PLANT_CRON}).`);
}

/**
 * Planificateur pour la perte de connexion des objets
 */
function startDisconnectedScheduler() {
  cron.schedule(DISCONNECTED_CRON, () => {
    console.log('[Scheduler] Démarrage : Vérification des objets déconnectés...');
    setImmediate(async () => {
      try {
        await checkAndSendDisconnectedNotifications();
      } catch (err) {
        console.error('[Scheduler] Erreur critique objets déconnectés :', err);
      }
    });
  });

  console.log(`[Scheduler] Tâche objets déconnectés initialisée (${DISCONNECTED_CRON}).`);
}

/**
 * Lance l'ensemble des planificateurs de notifications
 */
function startNotificationScheduler() {
  startLowBatteryScheduler();
  startDangerPlantScheduler();
  startDisconnectedScheduler();
}

export { startNotificationScheduler };