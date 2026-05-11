import e from "express";
import { pool } from "../middlewares/postgres.mjs";

const FinalizeOrder = async (payment_intent_id, id_person, id_address_delivery, payment_intent_amount) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        // 1. Récupération et calcul de sécurité
        const cartRes = await client.query(
            `SELECT ci.id_object, ci.quantity, COALESCE(obj.discount_price, obj.price) as unit_price
             FROM cart_item ci
             JOIN object obj ON ci.id_object = obj.id_object
             WHERE ci.payment_intent_id = $1 AND ci.id_person = $2`,
            [payment_intent_id, id_person]
        );

        if (cartRes.rows.length === 0) throw new Error("Déjà traité.");

        let totalPrice = cartRes.rows.reduce((sum, i) => sum + (i.unit_price * i.quantity), 0);
        if (totalPrice < 50) totalPrice += 8.90;

        const serverTotalCentimes = Math.round(totalPrice * 100);
        if (serverTotalCentimes !== payment_intent_amount) {
            throw new Error("Discordance de prix : Fraude possible ou erreur de calcul.");
        }

        // 2. Création de la commande
        const orderRes = await client.query(
            `INSERT INTO orders (id_person, status, total_price, id_address_delivery, payment_ref)
             VALUES ($1, 'PAID', $2, $3, $4) RETURNING id_order`,
            [id_person, totalPrice, id_address_delivery, payment_intent_id]
        );
        const newOrderId = orderRes.rows[0].id_order;

        // 3. OPTIMISATION BULK : On fait tout d'un coup
        // A. Transfert vers order_item
        await client.query(
            `INSERT INTO order_item (id_order, id_object, quantity, unit_price)
             SELECT $1, id_object, quantity, COALESCE(discount_price, price)
             FROM cart_item ci JOIN object obj USING(id_object)
             WHERE payment_intent_id = $2`,
            [newOrderId, payment_intent_id]
        );

        // B. Décrémentation des stocks massive
        await client.query(
            `UPDATE object SET stock_quantity = object.stock_quantity - ci.quantity
             FROM cart_item ci
             WHERE object.id_object = ci.id_object AND ci.payment_intent_id = $1`,
            [payment_intent_id]
        );

        // 4. Nettoyage
        await client.query('DELETE FROM cart_item WHERE payment_intent_id = $1', [payment_intent_id]);

        await client.query('COMMIT');
        return true;
    } catch (e) {
        await client.query('ROLLBACK');
        throw e;
    } finally {
        client.release();
    }
};

export { FinalizeOrder };