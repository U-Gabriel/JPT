import { startNotificationScheduler } from './notifications/notificationScheduler.mjs';

console.log("[Worker] Démarrage du processus d'arrière-plan pour les tâches planifiées...");

startNotificationScheduler();