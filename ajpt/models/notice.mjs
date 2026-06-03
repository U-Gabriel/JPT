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

const GetAllNoticesRequest = async () => {
    const query = `
        SELECT 
            n.title, n.content, n.status, n.created_at, n.is_public,
            p.pseudo AS author_pseudo,
            op.title AS object_profile_title,
            o.title AS object_title,
            t.title AS tag_name
        FROM notice n
        LEFT JOIN person p ON n.id_person = p.id_person
        LEFT JOIN object_profile op ON n.id_object_profile = op.id_object_profile
        LEFT JOIN object o ON op.id_object = o.id_object
        LEFT JOIN tag t ON n.id_tag = t.id_tag
        WHERE n.status <> 'CLOSED'
        ORDER BY n.created_at DESC;
    `;
    const { rows } = await pool.query(query);
    return rows;
};

/**
 * Met à jour le status ou supprime si status === 'CLOSED'
 */
const UpdateNoticeStatusRequest = async (id_notice, status) => {
    if (status === 'CLOSED') {
        const query = {
            text: `DELETE FROM notice WHERE id_notice = $1 RETURNING id_notice`,
            values: [id_notice]
        };
        const { rows } = await pool.query(query);
        return { action: 'deleted', id: rows[0]?.id_notice };
    } else {
        const query = {
            text: `UPDATE notice SET status = $1 WHERE id_notice = $2 RETURNING id_notice, status`,
            values: [status, id_notice]
        };
        const { rows } = await pool.query(query);
        return { action: 'updated', data: rows[0] };
    }
};

export { CreateNoticeRequest, CountUserNotices, GetAllNoticesRequest, UpdateNoticeStatusRequest };