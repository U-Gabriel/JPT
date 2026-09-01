// scheduler.mjs
import cron from 'node-cron';
import { checkAndSendLowBatteryNotifications } from './notificationService.mjs';

export function startNotificationScheduler() {
  // Test actuel : '*/2 * * * *' (toutes les 2 min)
  // Production : '0 10 * * *' (chaque jour à 10h00 du matin)
  cron.schedule('0 0 * * *', () => {
    console.log('[Scheduler] Vérification de la batterie des objets...');
    
    setImmediate(() => {
      checkAndSendLowBatteryNotifications();
    });
  });

  console.log('[Scheduler] Tâche de vérification batterie initialisée.');
}