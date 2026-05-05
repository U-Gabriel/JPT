import { pool } from "../middlewares/postgres.mjs";

/**
 * Compte le nombre total d'articles (somme des quantités) dans le panier
 */
const GetCartItemCountRequest = async (id_person) => {
    const query = {
        text: `
            SELECT SUM(quantity) as total 
            FROM cart_item 
            WHERE id_person = $1
        `,
        values: [id_person]
    };

    const { rows } = await pool.query(query);
    
    // Si le panier est vide, SUM renvoie null, on convertit en 0
    return rows[0].total ? parseInt(rows[0].total) : 0;
};

/**
 * Ajoute un article au panier ou met à jour la quantité s'il existe déjà
 */
const AddToCartRequest = async (id_person, id_object, quantity) => {
    const query = {
        text: `
            INSERT INTO cart_item (id_person, id_object, quantity)
            VALUES ($1, $2, $3)
            ON CONFLICT (id_person, id_object) 
            DO UPDATE SET 
                quantity = cart_item.quantity + EXCLUDED.quantity
            RETURNING *;
        `,
        values: [id_person, id_object, quantity]
    };

    const { rows } = await pool.query(query);
    return rows[0];
};

/**
 * Récupère tous les articles du panier d'un utilisateur avec détails et image principale
 */
const GetCartItemsRequest = async (id_person) => {
    const query = {
        text: `
            SELECT 
                ci.id_object,
                ci.quantity as cart_quantity,
                obj.title,
                obj.description,
                obj.price,
                obj.discount_price,
                obj.stock_quantity,
                -- On récupère uniquement la photo principale
                (SELECT file_path 
                 FROM object_asset 
                 WHERE id_object = obj.id_object AND is_main_picture = true 
                 LIMIT 1) as main_picture
            FROM "cart_item" ci
            JOIN object obj ON ci.id_object = obj.id_object
            WHERE ci.id_person = $1
            ORDER BY ci.added_at DESC;
        `,
        values: [id_person]
    };

    const { rows } = await pool.query(query);
    return rows;
};

const DeleteCartItemRequest = async (id_cart_item, id_person) => {
    const query = {
        text: `
            DELETE FROM "cart_item" 
            WHERE id_cart_item = $1 AND id_person = $2
            RETURNING id_cart_item;
        `,
        values: [id_cart_item, id_person]
    };

    const { rows } = await pool.query(query);
    
    // Si rows est vide, c'est que l'ID n'existait pas ou n'appartenait pas à l'user
    return rows.length > 0;
};


export { GetCartItemCountRequest,  AddToCartRequest, GetCartItemsRequest, DeleteCartItemRequest };