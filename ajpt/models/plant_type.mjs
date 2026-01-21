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
            pt.height,
            pt.weight,
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
            pt.number_good_saison,
            pt.plantation_saison,
            pt.humidity_ground,
            pt.ph_ground_sensor,
            pt.ph_min,
            pt.ph_max,
            pt.conductivity_electrique_fertility_sensor,
            pt.conductivity_electrique_fertility_min,
            pt.conductivity_electrique_fertility_max,
            pt.light_sensor,
            pt.temperature_sensor_ground,
            pt.temperature_sensor_estern,
            pt.humidity_air_sensor,
            pt.humidity_ground_sensor,
            pt.exposition_time_sun,
            pt.height_min,
            pt.height_max,
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
        height: row.height,
        weight: row.weight,
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
        ph_ground_sensor: row.ph_ground_sensor,
        ph_min: row.ph_min,
        ph_max: row.ph_max,
        conductivity_electrique_fertility_sensor: row.conductivity_electrique_fertility_sensor,
        conductivity_electrique_fertility_min: row.conductivity_electrique_fertility_min,
        conductivity_electrique_fertility_max: row.conductivity_electrique_fertility_max,
        light_sensor: row.light_sensor,
        temperature_sensor_ground: row.temperature_sensor_ground,
        temperature_sensor_estern: row.temperature_sensor_estern,
        humidity_air_sensor: row.humidity_air_sensor,
        humidity_ground_sensor: row.humidity_ground_sensor,
        exposition_time_sun: row.exposition_time_sun,
        height_min: row.height_min,
        height_max: row.height_max,
        avatars: row.avatars // ← ici on renvoie le tableau complet d'Avatar
    };
};



export {PlantType, GetRequestPlantTypeSearchByTitle, GetRequestPlantTypeDescription}