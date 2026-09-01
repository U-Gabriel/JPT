// controllers/notification.controller.mjs
import { updatePersonFcmToken } from "../models/notification.mjs";
import { ResponseApi } from "../models/response-api.mjs";

export const SaveFcmTokenController = async (reqBody) => {
  const { id_person, fcmToken } = reqBody;

  if (!id_person || !fcmToken) {
    return new ResponseApi().InitMissingParameters();
  }

  try {
    const data = await updatePersonFcmToken(id_person, fcmToken);
    return new ResponseApi().InitOK(data);
  } catch (error) {
    console.error("Erreur dans SaveFcmTokenController:", error);
    return new ResponseApi().InitInternalServer(error.message);
  }
};