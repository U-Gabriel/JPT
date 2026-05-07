import e from "express";
import { pool } from "../middlewares/postgres.mjs";

/**
 * Met à jour les quantités, vérifie les stocks et marque les articles avec l'ID Stripe.
 * @param {number} id_person - ID de l'utilisateur (issu du token)
 * @param {Array} items - Liste des articles [{id_cart_item, quantity}]
 * @param {string} payment_intent_id - L'ID unique généré par Stripe (pi_...)
 * @returns {number} totalAmount - Le montant total calculé par le serveur
 */
const UpdateCartAndGetTotal = async (id_person, items, payment_intent_id) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        let totalAmount = 0;

        // On reset d'abord les anciens marquages de cet utilisateur 
        // (au cas où il aurait annulé un paiement précédent pour recommencer)
        await client.query(
            'UPDATE cart_item SET payment_intent_id = NULL WHERE id_person = $1',
            [id_person]
        );

        for (const item of items) {
            // 1. Vérification du stock et récupération du prix
            const stockRes = await client.query(
                `SELECT obj.stock_quantity, obj.price, obj.discount_price 
                 FROM cart_item ci
                 JOIN object obj ON ci.id_object = obj.id_object
                 WHERE ci.id_cart_item = $1 AND ci.id_person = $2`,
                [item.id_cart_item, id_person]
            );

            if (stockRes.rows.length === 0) {
                throw new Error(`Article ${item.id_cart_item} introuvable dans votre panier`);
            }

            const product = stockRes.rows[0];

            if (product.stock_quantity < item.quantity) {
                throw new Error(`Stock insuffisant pour l'article ${item.id_cart_item} (Disponible: ${product.stock_quantity})`);
            }

            // 2. Mise à jour : Quantité + Marquage avec l'ID Stripe
            await client.query(
                `UPDATE cart_item 
                 SET quantity = $1, payment_intent_id = $2 
                 WHERE id_cart_item = $3 AND id_person = $4`,
                [item.quantity, payment_intent_id, item.id_cart_item, id_person]
            );

            // 3. Calcul du prix (on privilégie le prix promo si disponible)
            const unitPrice = product.discount_price || product.price;
            totalAmount += unitPrice * item.quantity;
        }

        // 4. Gestion des frais de livraison (Logique JackPote)
        let shippingFees = 0.50; 
        if (totalAmount > 50) shippingFees = 0; 
        
        totalAmount += shippingFees;

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
 * Finalise la commande de façon ultra-sécurisée
 * @param {string} payment_intent_id - L'ID Stripe confirmé
 * @param {number} id_person - L'ID de l'utilisateur (récupéré des metadata Stripe)
 */
const FinalizeOrder = async (payment_intent_id, id_person) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        // DOUBLE VÉRIFICATION : 
        // On ne supprime que si l'ID de paiement ET l'ID de l'utilisateur correspondent.
        const deleteRes = await client.query(
            `DELETE FROM cart_item 
             WHERE payment_intent_id = $1 
             AND id_person = $2 
             RETURNING *`,
            [payment_intent_id, id_person]
        );

        if (deleteRes.rowCount === 0) {
            // Si on arrive ici, c'est soit que le paiement a déjà été traité,
            // soit qu'il y a une tentative de fraude avec un mauvais id_person.
            throw new Error("Action non autorisée ou déjà traitée.");
        }

        // C'est ici qu'on insèrerait la ligne dans la table 'orders'
        // car on a maintenant la certitude du paiement et de l'identité.

        await client.query('COMMIT');
        return true;
    } catch (e) {
        await client.query('ROLLBACK');
        console.error("Sécurité Webhook - Échec de finalisation:", e.message);
        throw e;
    } finally {
        client.release();
    }
};

export { UpdateCartAndGetTotal, FinalizeOrder };