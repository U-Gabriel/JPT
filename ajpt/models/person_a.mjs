import { pool } from "../middlewares/postgres.mjs";

const CreateAddressRequest = async (id_person, addressData) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN'); // Début de la transaction

        const { title, address_line1, address_line2, postal_code, city, country, is_default } = addressData;

        // 1. Si la nouvelle adresse est par défaut, on reset les autres
        if (is_default === true) {
            await client.query(
                'UPDATE address SET is_default = false WHERE id_person = $1',
                [id_person]
            );
        }

        // 2. Insertion de la nouvelle adresse
        const insertQuery = {
            text: `
                INSERT INTO address (id_person, title, address_line1, address_line2, postal_code, city, country, is_default)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                RETURNING *
            `,
            values: [id_person, title, address_line1, address_line2, postal_code, city, country, is_default || false]
        };

        const { rows } = await client.query(insertQuery);
        
        await client.query('COMMIT'); // Validation des changements
        return rows[0];

    } catch (e) {
        await client.query('ROLLBACK'); // Annulation en cas d'erreur
        throw e;
    } finally {
        client.release(); // Libération du client
    }
};

/**
 * Récupère la liste des adresses d'un utilisateur
 * Triée par adresse par défaut d'abord, puis par ID
 */
const GetAddressesRequest = async (id_person) => {
    const query = {
        text: `
            SELECT 
                id_address,
                id_person,
                title,
                address_line1,
                address_line2,
                postal_code,
                city,
                country,
                is_default
            FROM address
            WHERE id_person = $1
            ORDER BY is_default DESC, id_address ASC
        `,
        values: [id_person]
    };

    const { rows } = await pool.query(query);
    return rows;
};

export { CreateAddressRequest, GetAddressesRequest};