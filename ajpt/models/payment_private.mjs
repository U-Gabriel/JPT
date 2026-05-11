import e from "express";
import { pool } from "../middlewares/postgres.mjs";

const UpdateCartAndGetTotal = async (id_person, items, payment_intent_id) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        let totalAmount = 0;

        // Reset des anciens marquages
        await client.query(
            'UPDATE cart_item SET payment_intent_id = NULL WHERE id_person = $1',
            [id_person]
        );

        for (const item of items) {
            const stockRes = await client.query(
                `SELECT obj.id_object, obj.stock_quantity, obj.price, obj.discount_price 
                 FROM cart_item ci
                 JOIN object obj ON ci.id_object = obj.id_object
                 WHERE ci.id_cart_item = $1 AND ci.id_person = $2`,
                [item.id_cart_item, id_person]
            );

            if (stockRes.rows.length === 0) throw new Error(`Article introuvable`);
            const product = stockRes.rows[0];

            if (product.stock_quantity < item.quantity) {
                throw new Error(`Stock insuffisant pour ${product.id_object}`);
            }

            await client.query(
                `UPDATE cart_item SET quantity = $1, payment_intent_id = $2 
                 WHERE id_cart_item = $3 AND id_person = $4`,
                [item.quantity, payment_intent_id, item.id_cart_item, id_person]
            );

            totalAmount += (product.discount_price || product.price) * item.quantity;
        }

        totalAmount += (totalAmount < 50) ? 8.90 : 0;

        await client.query('COMMIT');
        return totalAmount;
    } catch (e) {
        await client.query('ROLLBACK');
        throw e;
    } finally {
        client.release();
    }
};

/**
 * Récupère le mail d'une personne par son ID
 */
const GetUserMailById = async (id_person) => {
    const res = await pool.query('SELECT mail FROM person WHERE id_person = $1', [id_person]);
    return res.rows.length > 0 ? res.rows[0].mail : null;
};


export { UpdateCartAndGetTotal, GetUserMailById };