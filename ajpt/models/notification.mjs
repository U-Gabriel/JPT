// models/notification.mjs
import { pool } from "../middlewares/postgres.mjs";

/**
 * Récupère tous les objets avec batterie < 10% et le token FCM de leur propriétaire.
 */
const getLowBatteryObjectsWithTokens = async () => {
  const query = {
    text: `
      SELECT 
        op.id_object_profile,
        op.title AS object_title,
        op.battery_lvl,
        p.id_person,
        p.fcm_token
      FROM object_profile op
      INNER JOIN person p ON op.id_person = p.id_person
      WHERE op.battery_lvl < 10 
        AND op.activate = 1
        AND p.fcm_token IS NOT NULL;
    `
  };

  const { rows } = await pool.query(query);
  return rows;
};

/**
 * Enregistre ou met à jour le token FCM d'un utilisateur.
 */
const updatePersonFcmToken = async (id_person, fcmToken) => {
  const query = {
    text: `
      UPDATE person 
      SET fcm_token = $1 
      WHERE id_person = $2
      RETURNING id_person, fcm_token;
    `,
    values: [fcmToken, id_person]
  };

  const { rows } = await pool.query(query);
  return rows[0];
};

const cleanInvalidFcmToken = async (fcmToken) => {
  const query = {
    text: `UPDATE person SET fcm_token = NULL WHERE fcm_token = $1;`,
    values: [fcmToken]
  };
  await pool.query(query);
};

/**
 * Récupère tous les objets dont la plante est en danger (state_plant = 5)
 * et le token FCM de leur propriétaire.
 */
const getDangerPlantObjectsWithTokens = async () => {
  const query = {
    text: `
      SELECT 
        op.id_object_profile,
        op.title AS object_title,
        op.state_plant,
        p.id_person,
        p.fcm_token
      FROM object_profile op
      INNER JOIN person p ON op.id_person = p.id_person
      WHERE op.state_plant = 5 
        AND op.activate = 1
        AND p.fcm_token IS NOT NULL;
    `
  };

  const { rows } = await pool.query(query);
  return rows;
};

/**
 * Récupère les objets qui n'ont pas envoyé de données depuis plus de 24h
 * et le token FCM de leur propriétaire.
 */
const getDisconnectedObjectsWithTokens = async () => {
  const query = {
    text: `
      SELECT 
        op.id_object_profile,
        op.title AS object_title,
        op.modify_op,
        p.id_person,
        p.fcm_token
      FROM object_profile op
      INNER JOIN person p ON op.id_person = p.id_person
      WHERE op.modify_op < NOW() - INTERVAL '2 day'
        AND op.activate = 1
        AND p.fcm_token IS NOT NULL;
    `
  };

  const { rows } = await pool.query(query);
  return rows;
};

export { getLowBatteryObjectsWithTokens, updatePersonFcmToken, cleanInvalidFcmToken, getDangerPlantObjectsWithTokens, getDisconnectedObjectsWithTokens };