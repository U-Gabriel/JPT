import {pool} from "../middlewares/postgres.mjs"

class GroupPlantType {
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
    temperature_sensor_extern
    humidity_air_sensor
    humidity_ground_sensor
    exposition_time_sun
    height_min
    height_max
    id_plant_type
    id_object_profile
}

const GetRequestGroupPlantType = async ({ id_person, id_object_profile }) => {
    if (!id_person || !id_object_profile) throw new Error("Missing parameters");

    const query = `
        SELECT 
            gpt.id_group_plant_type,
            gpt.title,
            gpt.is_standard,
            -- On vérifie si ce groupe est l'actif dans la table de liaison
            COALESCE(lnk.is_active, false) AS is_currently_active,
            gpt.conductivity_electrique_fertility_sensor,
            gpt.temperature_sensor_extern AS temperature,
            gpt.humidity_air_sensor AS humidity_extern,
            gpt.humidity_ground_sensor AS humidity_ground,
            gpt.watering_time,
            gpt.prority_plant AS priority_plant
        FROM group_plant_type gpt
        -- Jointure pour connaître le type de plante de l'objet actuel
        INNER JOIN object_profile op ON op.id_object_profile = $2
        -- Jointure avec la table de liaison pour l'utilisateur et l'objet précis
        LEFT JOIN lnk_person_op_group lnk ON (
            lnk.id_group_plant_type = gpt.id_group_plant_type 
            AND lnk.id_object_profile = $2 
            AND lnk.id_person = $1
        )
        WHERE 
            -- On prend les groupes qui ont un lien avec cet utilisateur dans la table lnk
            gpt.id_group_plant_type IN (
                SELECT id_group_plant_type 
                FROM lnk_person_op_group 
                WHERE id_person = $1
            )
            -- OU les groupes standards qui correspondent au type de plante de l'objet
            OR (
                gpt.is_standard = true 
                AND gpt.id_plant_type = op.id_plant_type
            )
        ORDER BY 
            is_currently_active DESC, -- L'actif en premier
            gpt.is_standard DESC,      -- Les standards ensuite
            gpt.title ASC;
    `;

    const { rows } = await pool.query(query, [id_person, id_object_profile]);

    return rows.map(row => ({
        id_group: row.id_group_plant_type,
        title: row.title,
        is_active: row.is_currently_active,
        is_standard: row.is_standard,
        details: {
            fertility: row.conductivity_electrique_fertility_sensor,
            temperature: row.temperature,
            humidity_air: row.humidity_extern,
            humidity_ground: row.humidity_ground,
            watering_time: row.watering_time,
            priority: row.priority_plant
        }
    }));
};

export { GetRequestGroupPlantType };