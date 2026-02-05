import { pool } from "../middlewares/postgres.mjs";

class ObjectProfile {
    id_object_profile
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
    state_plant;
    is_water;
    activate;
}

/**
 * Crée un nouveau ObjectProfile
 * @param {Object} body - Champs nécessaires à la création
 * @returns {Promise<number>} - ID du profil créé
 */
const createObjectProfile = async (body) => {
  const {
    title,
    id_object,
    id_plant_type,
    id_person,
    activate = 0,
    is_water = false,
    is_favorite = false,
    is_light = false,
    is_working = true,
    is_automatic = true
  } = body;

  if (!title || !id_object || !id_plant_type || !id_person) {
    throw new Error("title, id_object, id_plant_type et id_person sont requis");
  }

  const query = {
    text: `
      INSERT INTO object_profile (
        title,
        id_object,
        id_plant_type,
        id_person,
        activate,
        is_water,
        is_favorite,
        is_light,
        is_working,
        is_automatic
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
      RETURNING id_object_profile;
    `,
    values: [
        title,
        id_object,
        id_plant_type,
        id_person,
        activate,
        is_water,
        is_favorite,
        is_light,
        is_working,
        is_automatic
    ]
  };

  const { rows } = await pool.query(query);

  return {
    success: true,
    id_object_profile: rows[0].id_object_profile
  };
};


const GetRequestObjectProfileResumeByPerson = async ({ id_person }) => {
    if (!id_person) throw new Error("id_person is required");

    const query = `
        SELECT DISTINCT ON (op.id_object_profile)
            op.id_object_profile,
            op.title AS op_title,
            op.is_automatic,
            op.is_water,
            op.state_plant,
            pt.id_plant_type AS id_plant_type,
            pt.title AS plant_title,
            a.title AS avatar_title,
            a.picture_path AS path_picture
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_person = $1 AND activate = 1
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
        state: row.state_plant,
        plant_type: {
            id_plant_type: row.id_plant_type,
            title: row.plant_title,
            path_picture: row.path_picture,
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
            op.state_plant,
            pt.id_plant_type AS id_plant_type,
            pt.title AS plant_title,
            a.title AS avatar_title,
            a.picture_path AS path_picture
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_person = $1 AND op.is_favorite = true AND op.activate = 1
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
        state: row.state_plant,
        plant_type: {
            id_plant_type: row.id_plant_type,
            title: row.plant_title,
            path_picture: row.path_picture,
            avatar: row.avatar_title ? {
                title: row.avatar_title,
                path_picture: row.path_picture
            } : null
        }
    }));
};

const updateObjectProfile = async (body) => {
    const { id_object_profile, id_person, ...fields } = body;

    if (!id_object_profile) {
        throw new Error("id_object_profile is required");
    }
    if (!id_person) {
        throw new Error("id_person is required");
    }
    if (Object.keys(fields).length === 0) {
        throw new Error("No fields to update");
    }

    const setClauses = Object.keys(fields).map(
        (key, index) => `${key} = $${index + 1}`
    );
    const values = Object.values(fields);

    const query = {
        text: `
            UPDATE object_profile
            SET ${setClauses.join(", ")}
            WHERE id_object_profile = $${values.length + 1} AND id_person = $${values.length + 2}
            RETURNING *;
        `,
        values: [...values, id_object_profile, id_person],
    };

    const { rows } = await pool.query(query);

    if (rows.length === 0) {
        throw new Error(`ObjectProfile with id ${id_object_profile} not found or does not belong to this user`);
    }

    return rows[0];
};



const GetRequestObjectProfiledetailsByOP = async ({ id_object_profile }) => {
    if (!id_object_profile) throw new Error("id_object_profile is required");

    const query = `
        SELECT DISTINCT ON (op.id_object_profile)
            op.id_object_profile,
            op.title AS op_title,
            op.description,
            op.advise,
            op.strenght,
            op.is_working,
            op.is_automatic,
            op.id_object,
            op.id_person,
            op.humidity_ground_sensor,
            op.ph_ground_sensor,
            op.conductivity_elec_sensor,
            op.uv_sensor,
            op.is_light,
            op.is_favorite,
            op.temperature_ground_sensor,
            op.temperature_air_sensor,
            op.humidity_air_sensor,
            op.exposition_time_sun,
            op.state_plant,
            op.is_water,
            pt.id_plant_type AS id_plant_type,
            pt.title AS plant_title,
            gpt.id_group_plant_type AS gpt_id_group_plant_type,
            gpt.title AS gpt_title,
            gpt.description AS gpt_description,
            gpt.height AS gpt_height,
            gpt.weight AS gpt_weight,
            gpt.advise AS gpt_advise,
            gpt.category AS gpt_category,
            gpt.scientist_name AS gpt_scientist_name,
            gpt.family_name AS gpt_family_name,
            gpt.type_name AS gpt_type_name,
            gpt.exposition_type AS gpt_exposition_type,
            gpt.ground_type AS gpt_ground_type,
            gpt.saison_first AS gpt_saison_first,
            gpt.saison_second AS gpt_saison_second,
            gpt.saison_third AS gpt_saison_third,
            gpt.saison_last AS gpt_saison_last,
            gpt.number_good_saison AS gpt_number_good_saison,
            gpt.plantation_saison AS gpt_plantation_saison,
            gpt.humidity_ground AS gpt_humidity_ground,
            gpt.ph_ground_sensor AS gpt_ph_ground_sensor,
            gpt.ph_min AS gpt_ph_min,
            gpt.ph_max AS gpt_ph_max,
            gpt.conductivity_electrique_fertility_sensor AS gpt_conductivity_electrique_fertility_sensor,
            gpt.conductivity_electrique_fertility_min AS gpt_conductivity_electrique_fertility_min,
            gpt.conductivity_electrique_fertility_max AS gpt_conductivity_electrique_fertility_max,
            gpt.light_sensor AS gpt_light_sensor,
            gpt.temperature_sensor_ground AS gpt_temperature_sensor_ground,
            gpt.temperature_sensor_estern AS gpt_temperature_sensor_estern,
            gpt.humidity_air_sensor AS gpt_humidity_air_sensor,
            gpt.humidity_ground_sensor AS gpt_humidity_ground_sensor,
            gpt.exposition_time_sun AS gpt_exposition_time_sun,
            gpt.height_min AS gpt_height_min,
            gpt.height_max AS gpt_height_max,
            gpt.id_plant_type AS gpt_id_plant_type,
            gpt.id_object_profile AS gpt_id_object_profile,
            a.title AS avatar_title,
            a.picture_path AS path_picture
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN group_plant_type gpt ON gpt.id_object_profile = op.id_object_profile AND gpt.is_active = true
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_object_profile = $1;
        `;

    const { rows } = await pool.query(query, [id_object_profile]);

    return rows.map(row => ({
        id_object_profile: row.id_object_profile,
        title: row.op_title,
        description : row.description,
        advise : row.advise,
        strenght : row.strenght,
        is_working : row.is_working,
        is_automatic : row.is_automatic,
        id_object : row.id_object,
        id_person : row.id_person,
        humidity_ground_sensor : row.humidity_ground_sensor,
        ph_ground_sensor : row.ph_ground_sensor,
        conductivity_elec_sensor : row.conductivity_elec_sensor,
        uv_sensor : row.uv_sensor,
        is_light : row.is_light,
        is_favorite : row.is_favorite,
        temperature_ground_sensor : row.temperature_ground_sensor,
        temperature_air_sensor : row.temperature_air_sensor,
        humidity_air_sensor : row.humidity_air_sensor,
        exposition_time_sun : row.exposition_time_sun,
        state : row.state_plant,
        is_water : row.is_water,
        plant_type: {
            id_plant_type: row.id_plant_type,
            title: row.plant_title,
            path_picture: row.path_picture,
            avatar: row.avatar_title ? {
                title: row.avatar_title,
                path_picture: row.path_picture
            } : null
        },
        group_plant_type: {
            id_group_plant_types_gpt: row.gpt_id_group_plant_type,
            title_gpt: row.gpt_title,
            description_gpt: row.gpt_description,
            height_gpt: row.gpt_height,
            weight_gpt:  row.gpt_weight,
            advise_gpt: row.gpt_advise,
            category_gpt: row.gpt_category,
            scientist_name_gpt: row.gpt_scientist_name,
            family_name_gpt: row.gpt_family_name,
            type_name_gpt: row.gpt_type_name,
            exposition_type_gpt: row.gpt_exposition_type,
            ground_type_gpt: row.gpt_ground_type,
            saison_first_gpt: row.gpt_saison_first,
            saison_second_gpt: row.gpt_saison_second,
            saison_third_gpt: row.gpt_saison_third,
            saison_last_gpt: row.gpt_saison_last,
            number_good_saison_gpt: row.gpt_number_good_saison,
            plantation_saison_gpt: row.gpt_plantation_saison,
            humidity_ground_gpt: row.gpt_humidity_ground,
            ph_ground_sensor_gpt: row.gpt_ph_ground_sensor,
            ph_min_gpt: row.gpt_ph_min,
            ph_max_gpt: row.gpt_ph_max,
            conductivity_electrique_fertility_sensor_gpt: row.gpt_conductivity_electrique_fertility_sensor,
            conductivity_electrique_fertility_min_gpt: row.gpt_conductivity_electrique_fertility_min,
            conductivity_electrique_fertility_max_gpt: row.gpt_conductivity_electrique_fertility_max,
            light_sensor_gpt: row.gpt_light_sensor,
            temperature_sensor_ground_gpt: row.gpt_temperature_sensor_ground,
            temperature_sensor_estern_gpt: row.gpt_temperature_sensor_estern,
            humidity_air_sensor_gpt: row.gpt_humidity_air_sensor,
            humidity_ground_sensor_gpt: row.gpt_humidity_ground_sensor,
            exposition_time_sun_gpt: row.gpt_exposition_time_sun,
            height_min_gpt: row.gpt_height_min,
            height_max_gpt: row.gpt_height_max,
            id_plant_type_gpt: row.gpt_id_plant_type,
            id_object_profile_gpt: row.gpt_id_object_profile,
            
        }
    }));
};

const DeleteObjectProfile = async (op) => {
  if (!op.id_object_profile) throw new Error("id_object_profile is required");
  if (!op.id_person) throw new Error("id_person is required");

  const query = {
    text: `
      DELETE FROM object_profile
      WHERE id_object_profile = $1 AND id_person = $2
      RETURNING id_object_profile;
    `,
    values: [op.id_object_profile, op.id_person],
  };

  const { rows } = await pool.query(query);

  if (rows.length === 0) {
    throw new Error(`ObjectProfile with id ${op.id_object_profile} not found or does not belong to this user`);
  }

  return {
    success: true,
    deleted_id: rows[0].id_object_profile,
  };
};


export { ObjectProfile, createObjectProfile, GetRequestObjectProfileResumeByPerson, GetRequestObjectProfileResumeFavorisByPerson, updateObjectProfile, GetRequestObjectProfiledetailsByOP, DeleteObjectProfile };
