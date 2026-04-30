import { pool } from "../middlewares/postgres.mjs";

const GetAllTagRequest = async () => {
  const query = {
    text: `SELECT id_tag, title, color_code, description FROM tag ORDER BY title ASC;`
  };

  const { rows } = await pool.query(query);
  return rows; // Retourne un tableau d'objets
};

export { GetAllTagRequest };