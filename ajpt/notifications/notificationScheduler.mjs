import cron from 'node-cron';
import { checkAndSendLowBatteryNotifications, checkAndSendDangerPlantNotifications } from './notificationService.mjs';


// Utilisation d'expressions cron configurables (Fallback sur les valeurs de production)
const LOW_BATTERY_CRON = process.env.CRON_LOW_BATTERY //|| '0 0 * * *'; // Minuit
const DANGER_PLANT_CRON = process.env.CRON_DANGER_PLANT //|| '0 2 * * *'; // 02h00 du matin

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
 * Lance l'ensemble des planificateurs de notifications
 */
function startNotificationScheduler() {
  startLowBatteryScheduler();
  startDangerPlantScheduler();
}

export { startNotificationScheduler };