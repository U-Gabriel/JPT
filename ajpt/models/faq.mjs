import { pool } from "../middlewares/postgres.mjs";

const CreateFaqRequest = async (question, answer, id_tag, id_object, order_view) => {
  const query = {
    text: `
      INSERT INTO faq (question, answer, id_tag, id_object, order_view)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING id_faq, question, answer;
    `,
    values: [question, answer, id_tag || null, id_object || null, order_view || 0]
  };

  const { rows } = await pool.query(query);
  return rows[0];
};

const GetAllFaqsCompleteRequest = async () => {
    const query = {
        text: `
            SELECT 
                f.id_faq, f.question, f.answer, f.order_view,
                o.title AS object_title,
                t.title AS tag_title
            FROM faq f
            LEFT JOIN object o ON f.id_object = o.id_object
            LEFT JOIN tag t ON f.id_tag = t.id_tag
            ORDER BY f.order_view ASC;
        `
    };
    const { rows } = await pool.query(query);
    return rows;
};

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

const DeleteFaqRequest = async (id_faq) => {
  const query = {
    text: `DELETE FROM faq WHERE id_faq = $1 RETURNING id_faq`,
    values: [id_faq]
  };

  const { rows } = await pool.query(query);
  return rows.length > 0; // Retourne true si une ligne a été supprimée
};

export {CreateFaqRequest, GetAllFaqsCompleteRequest, GetFaqsByTagsRequest, GetFaqsByObjectRequest, DeleteFaqRequest };