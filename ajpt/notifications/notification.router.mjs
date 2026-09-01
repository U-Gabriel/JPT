import { Router } from 'express';
import { saveFcmToken } from './notificationService.mjs';

const routerNotification = Router();

// Route pour recevoir le token FCM envoyé par l'app Flutter
routerNotification.post('/api/users/fcm-token', (req, res) => {
  const { fcmToken } = req.body;

  saveFcmToken(fcmToken);

  res.status(200).json({ success: true, message: 'Token FCM enregistré' });
});

export { routerNotification };