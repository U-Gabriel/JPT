import { pool } from "../middlewares/postgres.mjs";

class ObjectProfile {
    title;
    description;
    advise;
    strenght;
    is_working;
    is_automatic;
    id_object;
    id_plant_type;
    id_person;
    humidity_ground_sensor;
    ph_ground_sensor;
    conductivity_elec_sensor;
    uv_sensor;
    is_light;
    is_favorite;
    temperature_ground_sensor;
    temperature_air_sensor;
    humidity_air_sensor;
    exposition_time_sun;
}

const GetRequestObjectProfileResumeByPerson = async ({ id_person }) => {
    if (!id_person) throw new Error("id_person is required");

    const query = `
        SELECT DISTINCT ON (op.id_object_profile)
            op.id_object_profile,
            op.title AS op_title,
            op.is_automatic,
            op.is_water,
            pt.title AS plant_title,
            a.title AS avatar_title,
            a.picture_path AS path_picture
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_person = $1
        ORDER BY op.id_object_profile, 
                 CASE 
                    WHEN a.evolution_number = op.state_plant THEN 1 
                    WHEN a.evolution_number = 0 THEN 2
                    ELSE 3 
                 END;
    `;

    const { rows } = await pool.query(query, [id_person]);

    return rows.map(row => ({
        id_object_profile: row.id_object_profile,
        title: row.op_title,
        is_automatic: row.is_automatic,
        is_water: row.is_water,
        plant_type: {
            title: row.plant_title,
            avatar: row.avatar_title ? {
                title: row.avatar_title,
                path_picture: row.path_picture
            } : null
        }
    }));
};


const GetRequestObjectProfileResumeFavorisByPerson = async ({ id_person }) => {
    if (!id_person) throw new Error("id_person is required");

    const query = `
        SELECT DISTINCT ON (op.id_object_profile)
            op.id_object_profile,
            op.title AS op_title,
            op.is_automatic,
            op.is_water,
            pt.title AS plant_title,
            a.title AS avatar_title,
            a.picture_path AS path_picture
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_person = $1 AND op.is_favorite = true
        ORDER BY op.id_object_profile, 
                 CASE 
                    WHEN a.evolution_number = op.state_plant THEN 1 
                    WHEN a.evolution_number = 0 THEN 2
                    ELSE 3 
                 END;
    `;

    const { rows } = await pool.query(query, [id_person]);

    return rows.map(row => ({
        id_object_profile: row.id_object_profile,
        title: row.op_title,
        is_automatic: row.is_automatic,
        is_water: row.is_water,
        plant_type: {
            title: row.plant_title,
            avatar: row.avatar_title ? {
                title: row.avatar_title,
                path_picture: row.path_picture
            } : null
        }
    }));
};


export { ObjectProfile, GetRequestObjectProfileResumeByPerson, GetRequestObjectProfileResumeFavorisByPerson };
