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

export { GetCartItemCountRequest };