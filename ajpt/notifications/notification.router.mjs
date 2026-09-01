import { Router } from 'express';
import { saveFcmToken } from './notificationService.mjs';

const routerNotification = Router();

routerNotification.post('/users/fcm-token', (req, res) => {
  const { fcmToken } = req.body;

  if (!fcmToken) {
    return res.status(400).json({ success: false, message: 'fcmToken manquant' });
  }

  saveFcmToken(fcmToken);

  return res.status(200).json({ success: true, message: 'Token FCM enregistré' });
});

export { routerNotification };