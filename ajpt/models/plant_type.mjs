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


export {PlantType, GetRequestPlantTypeSearchByTitle}