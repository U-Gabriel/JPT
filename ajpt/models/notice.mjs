import { pool } from "../middlewares/postgres.mjs";

const CreateNoticeRequest = async (body) => {
  const {
    title,
    content,
    id_person,
    id_object_profile,
    id_tag,
    status,
    is_public,
  } = body;

  // On utilise COALESCE ou des valeurs par défaut pour les champs optionnels
  const query = {
    text: `
      INSERT INTO notice (
        title,
        content,
        id_person,
        id_object_profile,
        id_tag,
        status,
        is_public
      )
      VALUES ($1, $2, $3, $4, $5, COALESCE($6, 'PENDING'), COALESCE($7, FALSE))
      RETURNING id_notice, title, status, created_at;
    `,
    values: [
      title,
      content,
      id_person,
      id_object_profile || null, // Permet d'insérer NULL si vide
      id_tag || null,
      status,
      is_public
    ]
  };

  const { rows } = await pool.query(query);
  return rows[0];
};

const CountUserNotices = async (id_person) => {
    const query = {
        text: `SELECT COUNT(*) FROM notice WHERE id_person = $1`,
        values: [id_person]
    };
    const { rows } = await pool.query(query);
    return parseInt(rows[0].count);
};


export { CreateNoticeRequest, CountUserNotices };