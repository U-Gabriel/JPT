import { pool } from "../middlewares/postgres.mjs";

const GetFaqsByTagsRequest = async (id_tag) => {
  // On convertit undefined en null pour que Postgres comprenne le IS NULL
  const tagValue = id_tag || null;

  const query = {
    text: `
      SELECT id_faq, question, answer, id_tag, order_view 
      FROM faq 
      WHERE ($1::int IS NULL OR id_tag = $1)
      ORDER BY order_view ASC;
    `,
    values: [tagValue]
  };

  const { rows } = await pool.query(query);
  return rows; // On retourne tout le tableau (rows), pas juste rows[0]
};

const GetFaqsByObjectRequest = async (id_object) => {
  const query = {
    text: `
      SELECT id_faq, question, answer, id_tag, id_object, order_view 
      FROM faq 
      WHERE id_object = $1
      ORDER BY order_view ASC;
    `,
    values: [id_object]
  };

  const { rows } = await pool.query(query);
  return rows;
};

export { GetFaqsByTagsRequest, GetFaqsByObjectRequest };