// routes/notification.router.mjs
import { Router } from 'express';
import { SaveFcmTokenController } from '../controllers/notification.controller.mjs';

const routerNotification = Router();

routerNotification.post('/users/fcm-token', async (req, res) => {
  const response = await SaveFcmTokenController(req.body);
  res.status(response.code).send(response);
});

export { routerNotification };