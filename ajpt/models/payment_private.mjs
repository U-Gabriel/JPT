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

        //totalAmount += (totalAmount < 50) ? 8.90 : 0;

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

const GetAllOrdersCompleteRequest = async () => {
    const query = {
        text: `
            SELECT 
                o.id_order, o.order_date, o.status, o.total_price, o.payment_ref,
                p.mail AS customer_mail, p.firstname, p.surname, SUM(oi.quantity) AS total_items,
                json_agg(
                    json_build_object(
                        'id_order_item', oi.id_order_item,
                        'quantity', oi.quantity,
                        'unit_price', oi.unit_price,
                        'object_title', obj.title,
                        'object_sku', obj.sku
                    )
                ) AS items
            FROM orders o
            JOIN person p ON o.id_person = p.id_person
            JOIN order_item oi ON o.id_order = oi.id_order
            JOIN object obj ON oi.id_object = obj.id_object
            GROUP BY o.id_order, p.id_person
            ORDER BY o.order_date ASC;
        `
    };
    const { rows } = await pool.query(query);
    return rows;
};

const GetOrdersByStatusRequest = async (status) => {
    const query = {
        text: `
            SELECT 
                o.id_order, o.order_date, o.status, o.total_price, o.payment_ref,
                p.mail AS customer_mail, p.firstname, p.surname,
                SUM(oi.quantity)::integer AS total_items, 
                json_agg(
                    json_build_object(
                        'id_order_item', oi.id_order_item,
                        'quantity', oi.quantity,
                        'unit_price', oi.unit_price,
                        'object_title', obj.title,
                        'object_sku', obj.sku
                    )
                ) AS items
            FROM orders o
            JOIN person p ON o.id_person = p.id_person
            JOIN order_item oi ON o.id_order = oi.id_order
            JOIN object obj ON oi.id_object = obj.id_object
            WHERE o.status = $1
            GROUP BY o.id_order, p.id_person
            ORDER BY o.order_date ASC;
        `,
        values: [status]
    };
    const { rows } = await pool.query(query);
    return rows;
};

const UpdateOrderStatusRequest = async (id_order, status) => {
    const query = {
        text: `
            UPDATE orders 
            SET status = $1 
            WHERE id_order = $2 
            RETURNING id_order, status;
        `,
        values: [status, id_order]
    };
    
    const { rowCount, rows } = await pool.query(query);
    return rowCount > 0 ? rows[0] : null;
}

export { UpdateCartAndGetTotal, GetUserMailById, GetAllOrdersCompleteRequest, GetOrdersByStatusRequest, UpdateOrderStatusRequest };