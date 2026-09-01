import cron from 'node-cron';
import { sendPingNotificationToAll } from './notificationService.mjs';

export function startNotificationScheduler() {
  // Syntaxe cron : '*/5 * * * *' signifie "toutes les 5 minutes"
  cron.schedule('*/2 * * * *', () => {
    console.log('[Scheduler] Déclenchement automatique de la notification (5 min)');
    
    // Exécution en tâche de fond isolée (ne bloque pas le serveur)
    setImmediate(() => {
      sendPingNotificationToAll();
    });
  });

  console.log('[Scheduler] Tâche planifiée démarrée (Envoi toutes les 5 min)');
}