import { pool } from "../middlewares/postgres.mjs";

const GetFaqsByTagsRequest = async (id_tag, title_search) => {
  // Préparation des valeurs pour le SQL
  const tagValue = id_tag || null;
  // On entoure le mot clé de % pour le LIKE (%mot%)
  const searchValue = title_search ? `%${title_search}%` : null;

  const query = {
    text: `
      SELECT id_faq, question, answer, id_tag, id_object, order_view 
      FROM faq 
      WHERE ($1::int IS NULL OR id_tag = $1)
        AND ($2::text IS NULL OR question ILIKE $2)
      ORDER BY order_view ASC;
    `,
    values: [tagValue, searchValue]
  };

  const { rows } = await pool.query(query);
  return rows;
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