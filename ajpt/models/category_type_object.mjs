import { pool } from "../middlewares/postgres.mjs";

class CategoryType {
    id_category_type;
    title;
    description;
    advise;
}

class ObjectProduct { // Renommé pour éviter le conflit avec le mot-clé global 'Object' de JS
    id_object;
    title;
    description;
    value_return;
    height;
    weight;
    advise;
    preference_number;
    id_category_type;
    is_available;
    price;
    stock_quantity;
    sku;
    brand;
    is_active;
    discount_price;
    created_at;
    id_tag;
    short_description;
    features;
    technical_details;
    warranty_info;
    installation_guide_url;
}

/**
 * Crée une nouvelle catégorie dans la base de données
 * @param {object} categoryData 
 */
const CreateCategoryType = async (categoryData) => {
    const { title, description, advise } = categoryData;
    
    const query = `
        INSERT INTO category_type (title, description, advise)
        VALUES ($1, $2, $3)
        RETURNING id_category_type, title, description, advise;
    `;
    
    const { rows } = await pool.query(query, [title, description, advise]);
    return rows[0];
};

/**
 * Crée un objet ET ses assets associés dans une seule transaction SQL sécurisée
 * @param {object} o - Données de l'objet
 * @param {Array} assets - Tableau d'objets contenant { file_path, is_main_picture, order_view }
 */
const CreateObjectWithAssets = async (o, assets = []) => {
    // 1. On récupère un client du pool pour piloter la transaction
    const client = await pool.connect();

    try {
        // 2. On démarre la transaction
        await client.query('BEGIN');

        // 3. Insertion de l'objet
        const objectQuery = `
            INSERT INTO object (
                title, description, value_return, height, weight, advise, 
                preference_number, id_category_type, is_available, price, 
                stock_quantity, sku, brand, is_active, discount_price, 
                id_tag, short_description, features, technical_details, 
                warranty_info, installation_guide_url
            ) VALUES (
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21
            ) RETURNING id_object;
        `;

        const objectValues = [
            o.title, o.description, o.value_return, o.height, o.weight, o.advise,
            o.preference_number || null, o.id_category_type, o.is_available ?? false, o.price,
            o.stock_quantity || 0, o.sku, o.brand, o.is_active ?? true, o.discount_price || null,
            o.id_tag || null, o.short_description, o.features, o.technical_details,
            o.warranty_info || 'Garantie constructeur', o.installation_guide_url
        ];

        const objectResult = await client.query(objectQuery, objectValues);
        const newObjectId = objectResult.rows[0].id_object;

        // 4. Insertion des lignes dans object_asset s'il y en a
        const insertedAssets = [];
        if (assets && assets.length > 0) {
            const assetQuery = `
                INSERT INTO object_asset (id_object, file_path, is_main_picture, order_view)
                VALUES ($1, $2, $3, $4)
                RETURNING *;
            `;

            for (const asset of assets) {
                const assetValues = [
                    newObjectId,
                    asset.file_path,
                    asset.is_main_picture ?? false,
                    asset.order_view || 0
                ];
                const assetResult = await client.query(assetQuery, assetValues);
                insertedAssets.push(assetResult.rows[0]);
            }
        }

        // 5. Tout est bon, on valide en BDD !
        await client.query('COMMIT');

        // On renvoie l'ID généré et la liste des assets créés pour la réponse API
        return {
            id_object: newObjectId,
            ...o,
            assets: insertedAssets
        };

    } catch (error) {
        // 🛑 En cas de problème, on annule TOUT (Rollback)
        await client.query('ROLLBACK');
        throw error;
    } finally {
        // Toujours libérer le client pour le remettre dans le pool
        client.release();
    }
};


/**
 * Récupère toutes les catégories avec les objets, le nom du tag,
 * et la liste complète des assets (images) associés à chaque objet.
 */
const GetCategoriesWithObjects = async () => {
    const query = `
        SELECT 
            c.id_category_type,
            c.title AS category_title,
            c.description AS category_description,
            c.advise AS category_advise,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id_object', o.id_object,
                        'title', o.title,
                        'description', o.description,
                        'value_return', o.value_return,
                        'height', o.height,
                        'weight', o.weight,
                        'advise', o.advise,
                        'preference_number', o.preference_number,
                        'is_available', o.is_available,
                        'price', o.price,
                        'stock_quantity', o.stock_quantity,
                        'sku', o.sku,
                        'brand', o.brand,
                        'is_active', o.is_active,
                        'discount_price', o.discount_price,
                        'created_at', o.created_at,
                        'tag_name', t.title,
                        'short_description', o.short_description,
                        'features', o.features,
                        'technical_details', o.technical_details,
                        'warranty_info', o.warranty_info,
                        'installation_guide_url', o.installation_guide_url,
                        'images', (
                            SELECT COALESCE(json_agg(
                                json_build_object(
                                    'id_asset', oa.id_asset,
                                    'file_path', oa.file_path,
                                    'is_main_picture', oa.is_main_picture
                                ) ORDER BY oa.order_view ASC
                            ), '[]'::json)
                            FROM object_asset oa
                            WHERE oa.id_object = o.id_object
                        )
                    ) ORDER BY o.title ASC
                ) FILTER (WHERE o.id_object IS NOT NULL), '[]'::json
            ) AS objects
        FROM category_type c
        LEFT JOIN object o ON c.id_category_type = o.id_category_type
        LEFT JOIN tag t ON o.id_tag = t.id_tag
        GROUP BY c.id_category_type
        ORDER BY c.title ASC;
    `;

    const { rows } = await pool.query(query);
    return rows;
};

/**
 * Récupère uniquement les ID et Titres de toutes les catégories
 * Idéal pour les sélecteurs et la correspondance d'ID côté Front-End
 */
const GetCategoriesLightweight = async () => {
    const query = `
        SELECT id_category_type, title 
        FROM category_type 
        ORDER BY title ASC;
    `;

    const { rows } = await pool.query(query);
    return rows;
};

/**
 * Récupère uniquement les ID et Titres de tous les objets
 */
const GetObjectsLightweight = async () => {
    const query = `
        SELECT id_object, title 
        FROM object 
        WHERE is_active = true 
        ORDER BY title ASC;
    `;
    const { rows } = await pool.query(query);
    return rows;
};

export { CategoryType, ObjectProduct, CreateCategoryType, CreateObjectWithAssets, GetCategoriesWithObjects, GetCategoriesLightweight, GetObjectsLightweight };