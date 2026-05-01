import { pool } from "../middlewares/postgres.mjs";

const GetAllProductsRequest = async (id_tag, title_search) => {
  const tagValue = id_tag || null;
  const searchValue = title_search ? `%${title_search}%` : null;

  const query = {
    text: `
      SELECT 
        obj.id_object, 
        obj.title, 
        obj.description, 
        obj.price, 
        obj.discount_price,
        obj.stock_quantity, 
        obj.sku, 
        obj.brand,
        -- On crée un tableau JSON contenant toutes les photos de l'objet
        COALESCE(
          (SELECT json_agg(json_build_object(
            'id_asset', asset.id_asset,
            'file_path', asset.file_path,
            'is_main', asset.is_main_picture
          ) ORDER BY asset.is_main_picture DESC, asset.order_view ASC)
           FROM object_asset asset 
           WHERE asset.id_object = obj.id_object
          ), '[]'
        ) as assets
      FROM object obj
      WHERE obj.is_active = true
        AND ($1::int IS NULL OR obj.id_tag = $1)
        AND ($2::text IS NULL OR obj.title ILIKE $2)
      ORDER BY obj.created_at DESC;
    `,
    values: [tagValue, searchValue]
  };

  const { rows } = await pool.query(query);
  return rows;
};

export { GetAllProductsRequest };