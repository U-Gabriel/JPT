import {pool} from "../middlewares/postgres.mjs"

class PlantType {
    id_plant_type
    title
    description
    height
    weight
    advise
    category
    scientist_name
    family_name
    type_name
    exposition_type
    ground_type
    saison_first
    saison_second
    saison_third
    saison_last
    number_good_saison
    plantation_saison
    humidity_ground
    ph_ground_sensor
    ph_min
    ph_max
    conductivity_electrique_fertility_sensor
    conductivity_electrique_fertility_min
    conductivity_electrique_fertility_max
    light_sensor
    temperature_sensor_ground
    temperature_sensor_estern
    humidity_air_sensor
    humidity_ground_sensor
    exposition_time_sun
    height_min
    height_max
}

const CreatePlantWithDetails = async (plantData, groupData, avatars = []) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        // 1. Insertion PlantType
        const plantQuery = `
            INSERT INTO plant_type (title, description, height_max, weight_max, advise, category, scientist_name, family_name, type_name, exposition_type, ground_type, saison_first, saison_second, saison_third, saison_last, number_good_saison, plantation_saison, humidity_ground, temperature_sensor_ground, exposition_time_sun)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20)
            RETURNING id_plant_type;
        `;
        const p = plantData;
        const plantValues = [p.title, p.description, p.height_max, p.weight_max, p.advise, p.category, p.scientist_name, p.family_name, p.type_name, p.exposition_type, p.ground_type, p.saison_first, p.saison_second, p.saison_third, p.saison_last, p.number_good_saison, p.plantation_saison, p.humidity_ground, p.temperature_sensor_ground, p.exposition_time_sun];
        const plantRes = await client.query(plantQuery, plantValues);
        const plantId = plantRes.rows[0].id_plant_type;

        // 2. Insertion GroupPlantType avec TOUS les champs
        const groupQuery = `
            INSERT INTO group_plant_type (
                title, description, id_plant_type, is_standard, is_active, 
                conductivity_electrique_fertility_sensor, temperature_sensor_ground, 
                temperature_sensor_extern, humidity_air_sensor, humidity_ground_sensor, 
                exposition_time_uv, watering_time, prority_plant, last_date_arrosage, watering_period_open
            )
            VALUES ($1, $2, $3, true, true, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            RETURNING id_group_plant_type;
        `;
        const g = groupData;
        const groupValues = [
            g.title, g.description, plantId, g.conductivity_elec, g.temp_ground, 
            g.temp_extern, g.humidity_air, g.humidity_ground, g.uv_time, 
            g.watering_time, g.priority, g.last_watering, g.watering_period
        ];
        await client.query(groupQuery, groupValues);

        // 3. Insertion Avatars
        for (const avatar of avatars) {
            await client.query(`
                INSERT INTO avatar (title, description, picture_path, id_plant_type, state)
                VALUES ($1, $2, $3, $4, 1)
            `, [avatar.title, avatar.description, avatar.picture_path, plantId]);
        }

        await client.query('COMMIT');
        return { id_plant_type: plantId };
    } catch (e) {
        await client.query('ROLLBACK');
        throw e;
    } finally {
        client.release();
    }
};

/**
 * Récupère toutes les plantes avec l'intégralité des champs 
 * de plant_type, group_plant_type et les avatars (state = 1)
 */
const GetAllPlants = async () => {
    const query = `
        SELECT 
            pt.*,
            json_build_object(
                'id_group_plant_type', gpt.id_group_plant_type,
                'title', gpt.title,
                'description', gpt.description,
                'conductivity_electrique_fertility_sensor', gpt.conductivity_electrique_fertility_sensor,
                'temperature_sensor_ground', gpt.temperature_sensor_ground,
                'temperature_sensor_extern', gpt.temperature_sensor_extern,
                'humidity_air_sensor', gpt.humidity_air_sensor,
                'humidity_ground_sensor', gpt.humidity_ground_sensor,
                'exposition_time_uv', gpt.exposition_time_uv,
                'is_active', gpt.is_active,
                'is_standard', gpt.is_standard,
                'watering_time', gpt.watering_time,
                'prority_plant', gpt.prority_plant,
                'last_date_arrosage', gpt.last_date_arrosage,
                'watering_period_open', gpt.watering_period_open
            ) AS group_info,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id_avatar', a.id_avatar,
                        'title', a.title,
                        'description', a.description,
                        'picture_path', a.picture_path,
                        'evolution_number', a.evolution_number,
                        'state', a.state
                    ) ORDER BY a.evolution_number ASC
                ) FILTER (WHERE a.id_avatar IS NOT NULL AND a.state = 1), '[]'::json
            ) AS avatars
        FROM plant_type pt
        LEFT JOIN group_plant_type gpt ON pt.id_plant_type = gpt.id_plant_type AND gpt.is_standard = true
        LEFT JOIN avatar a ON pt.id_plant_type = a.id_plant_type
        GROUP BY pt.id_plant_type, gpt.id_group_plant_type
        ORDER BY pt.title ASC;
    `;
    const { rows } = await pool.query(query);
    return rows;
};

const GetRequestPlantTypeSearchByTitle = async ({ title }) => {
    if (!title) throw new Error("title is required");

    const query = `
        SELECT pt.id_plant_type, pt.title, pt.description, av.picture_path
            FROM plant_type pt
            LEFT JOIN LATERAL (
                SELECT a.picture_path
                FROM avatar a
                WHERE a.id_plant_type = pt.id_plant_type AND a.state = 1
                ORDER BY a.id_avatar
                LIMIT 1
            ) av ON TRUE
            WHERE pt.title ILIKE '%' || $1 || '%'
            ORDER BY pt.title
            LIMIT 20;
    `;

    const { rows } = await pool.query(query, [title]);

    return rows.map(row => ({
        id_plant_type: row.id_plant_type,
        title: row.title,
        description: row.description,
        picture_path: row.picture_path
    }));
};

const GetRequestPlantTypeDescription = async ({ id }) => {
    if (!id) throw new Error("id is required");

    const query = `
        SELECT 
            pt.id_plant_type,
            pt.title,
            pt.description,
            pt.height_max,
            pt.weight_max,
            pt.advise,
            pt.category,
            pt.scientist_name,
            pt.family_name,
            pt.type_name,
            pt.exposition_type,
            pt.ground_type,
            pt.saison_first,
            pt.saison_second,
            pt.saison_third,
            pt.saison_last,
            pt.plantation_saison,
            pt.humidity_ground,
            pt.temperature_sensor_ground,
            pt.exposition_time_sun,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id_avatar', a.id_avatar,
                        'title', a.title,
                        'description', a.description,
                        'picture_path', a.picture_path,
                        'evolution_number', a.evolution_number,
                        'state', a.state,
                        'id_plant_type', a.id_plant_type
                    )
                    ORDER BY a.id_avatar
                ) FILTER (WHERE a.id_avatar IS NOT NULL),
                '[]'
            ) AS avatars
        FROM plant_type pt
        LEFT JOIN avatar a
            ON a.id_plant_type = pt.id_plant_type
            AND a.state = 1
        WHERE pt.id_plant_type = $1
        GROUP BY pt.id_plant_type;
    `;

    const { rows } = await pool.query(query, [id]);

    if (rows.length === 0) return null;

    const row = rows[0];

    return {
        id_plant_type: row.id_plant_type,
        title: row.title,
        description: row.description,
        height: row.height_max,
        weight: row.weight_max,
        advise: row.advise,
        category: row.category,
        scientist_name: row.scientist_name,
        family_name: row.family_name,
        type_name: row.type_name,
        exposition_type: row.exposition_type,
        ground_type: row.ground_type,
        saison_first: row.saison_first,
        saison_second: row.saison_second,
        saison_third: row.saison_third,
        saison_last: row.saison_last,
        number_good_saison: row.number_good_saison,
        plantation_saison: row.plantation_saison,
        humidity_ground: row.humidity_ground,
        temperature_sensor_ground: row.temperature_sensor_ground,
        exposition_time_sun: row.exposition_time_sun,
        avatars: row.avatars 
    };
};



export {PlantType, CreatePlantWithDetails, GetAllPlants, GetRequestPlantTypeSearchByTitle, GetRequestPlantTypeDescription}