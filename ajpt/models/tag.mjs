import { pool } from "../middlewares/postgres.mjs";

const CreateTagRequest = async (title, color_code, description, lvl_page) => {
  const query = {
    text: `
      INSERT INTO tag (title, color_code, description, lvl_page)
      VALUES ($1, $2, $3, $4)
      RETURNING id_tag, title, color_code, description, lvl_page;
    `,
    values: [title, color_code, description, lvl_page]
  };

  const { rows } = await pool.query(query);
  return rows[0];
};

const GetAllTagRequest = async () => {
  const query = {
    text: `SELECT id_tag, title, color_code, description FROM tag ORDER BY title ASC;`
  };

  const { rows } = await pool.query(query);
  return rows; // Retourne un tableau d'objets
};

const DeleteTagRequest = async (id_tag) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    // 1. Nettoyage des références dans les tables liées
    await client.query('UPDATE object SET id_tag = NULL WHERE id_tag = $1', [id_tag]);
    await client.query('UPDATE faq SET id_tag = NULL WHERE id_tag = $1', [id_tag]);
    await client.query('UPDATE notice SET id_tag = NULL WHERE id_tag = $1', [id_tag]);

    // 2. Suppression du tag
    const result = await client.query('DELETE FROM tag WHERE id_tag = $1', [id_tag]);
    
    await client.query('COMMIT');
    return result.rowCount > 0; // Retourne true si supprimé
  } catch (e) {
    await client.query('ROLLBACK');
    throw e;
  } finally {
    client.release();
  }
};

export {CreateTagRequest, GetAllTagRequest, DeleteTagRequest };