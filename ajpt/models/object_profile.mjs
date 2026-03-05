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
            -- On ouvre le JOIN pour permettre à SQL de voir toutes les photos dispo pour cette plante
            LEFT JOIN avatar a ON a.id_plant_type = pt.id_plant_type
            WHERE op.id_person = $1 AND op.activate = 1
            ORDER BY op.id_object_profile, 
                    CASE 
                        -- PRIORITÉ 0 : L'image exacte de l'état (ex: state 3 -> photo 3)
                        WHEN a.evolution_number = op.state_plant THEN 0
                        
                        -- PRIORITÉ 1 : Si l'état est 3 ou 4, on cherche la photo 3
                        WHEN op.state_plant IN (3, 4) AND a.evolution_number = 3 THEN 1
                        
                        -- PRIORITÉ 2 : Si l'état est 0, 1 ou 2, on cherche la photo 0
                        WHEN op.state_plant IN (0, 1, 2) AND a.evolution_number = 0 THEN 2
                        
                        -- PRIORITÉ 3 : Sécurité, on prend l'avatar le plus élevé qui ne dépasse pas l'état
                        WHEN a.evolution_number < op.state_plant THEN 3
                        
                        ELSE 4
                    END ASC,
                    -- En cas d'égalité sur la priorité, on prend l'évolution la plus haute
                    a.evolution_number DESC;
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
            a.picture_path AS path_picture,
            a.evolution_number
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN avatar a ON a.id_plant_type = pt.id_plant_type
        WHERE op.id_person = $1 
        AND op.is_favorite = true 
        AND op.activate = 1
        ORDER BY op.id_object_profile, 
                CASE 
                    -- 1. Si la photo exacte existe, c'est le top priorité
                    WHEN a.evolution_number = op.state_plant THEN 0
                    
                    -- 2. Gestion du palier [3, 4] -> on cherche la photo 3
                    WHEN op.state_plant IN (3, 4) AND a.evolution_number = 3 THEN 1
                    
                    -- 3. Gestion du palier [0, 1, 2] -> on cherche la photo 0
                    WHEN op.state_plant IN (0, 1, 2) AND a.evolution_number = 0 THEN 1
                    
                    -- 4. Pour tout le reste (ex: state 5), on prend l'avatar le plus élevé qui ne dépasse pas le state
                    WHEN a.evolution_number < op.state_plant THEN 2
                    
                    ELSE 3
                END ASC,
                -- Si plusieurs photos sont dans la même priorité, on prend la plus grande
                a.evolution_number DESC;
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
        SELECT 
            -- Infos de base de l'objet
            op.id_object_profile, op.title AS op_title, op.description, op.advise, 
            op.strenght, op.is_working, op.is_automatic, op.id_object, op.id_person,
            op.is_light, op.is_favorite, op.state_plant, op.is_water, 
            op.last_watering_date, op.modify_op,
            -- Capteurs Temps Réel
            op.humidity_ground_sensor, op.temperature_air_sensor, 
            op.humidity_air_sensor, op.uv_sensor, op.conductivity_elec_sensor,
            -- Capteurs Moyennes (Historique récent)
            op.humidity_ground_sensor_average, op.temperature_air_sensor_average,
            op.humidity_air_sensor_average, op.uv_sensor_average, op.conductivity_elec_sensor_average,
            -- Seuils Cibles (Priorité Profile Actif > Standard)
            gpt.temperature_sensor_extern AS target_temp,
            gpt.humidity_air_sensor AS target_hum_air,
            gpt.humidity_ground_sensor AS target_hum_sol,
            gpt.conductivity_electrique_fertility_sensor AS target_fertility,
            gpt.exposition_time_uv AS target_uv,
            gpt.title AS gpt_title,
            -- Infos Plante et Avatar
            pt.id_plant_type, pt.title AS plant_title,
            a.title AS avatar_title, a.picture_path AS path_picture
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN group_plant_type gpt ON (
            (gpt.id_object_profile = op.id_object_profile AND gpt.is_active = true)
            OR 
            (gpt.id_plant_type = op.id_plant_type AND gpt.is_standard = true)
        )
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_object_profile = $1
        ORDER BY (gpt.id_object_profile IS NOT NULL) DESC, gpt.is_standard DESC
        LIMIT 1;
    `;

    const { rows } = await pool.query(query, [id_object_profile]);
    if (rows.length === 0) return null;

    const row = rows[0];
    const issues = [];

    // --- ANALYSE DES ÉCARTS (Sur les moyennes) ---
    
    // Température
    if (row.temperature_air_sensor_average > (row.target_temp + 5)) {
        issues.push("La température est trop élevée, je risque de surchauffer.");
    } else if (row.temperature_air_sensor_average < (row.target_temp - 5)) {
        issues.push("Il fait trop froid ici, je me sens toute engourdie.");
    }

    if (row.conductivity_elec_sensor_average <  (row.target_fertility - 15)) {
        issues.push("La terre est trop sèche, mes racines ont soif.");
    } else if (row.conductivity_elec_sensor_average >  (row.target_fertility + 15)) {
        issues.push("Le sol est trop humide, attention à ne pas noyer mes racines.");
    }

    // 3. Conductivité / Fertilité (LES NUTRIMENTS)
    if (row.conductivity_elec_sensor_average < (row.target_fertility - 15)) {
        issues.push("La terre s'épuise, un peu d'engrais me ferait du bien.");
    }

    // Humidité Air
    if (row.humidity_air_sensor_average < (row.target_hum_air - 15)) {
        issues.push("L'air est trop sec pour mes feuilles.");
    } else if (row.humidity_air_sensor_average > (row.target_hum_air + 15)) {
        issues.push("L'air est très saturé en humidité, surveillez la moisissure.");
    }

    const advice_realtime = issues.length > 0 ? issues.join(" ") : "Toutes les conditions sont idéales !";

    // --- MAPPING POUR FLUTTER ---
    return {
        id_object_profile: row.id_object_profile,
        title: row.op_title,
        description: row.description,
        advise: row.advise,
        state: row.state_plant, // Ton score de santé 1-4
        advice_realtime: advice_realtime,
        is_automatic: row.is_automatic,
        is_water: row.is_water,
        is_favorite: row.is_favorite,
        last_watering: row.last_watering_date,
        
        // Données capteurs groupées
        sensors: {
            current: {
                temp: row.temperature_air_sensor,
                hum_air: row.humidity_air_sensor,
                hum_sol: row.humidity_ground_sensor,
                uv: row.uv_sensor,
                fertility: row.conductivity_elec_sensor
            },
            averages: {
                temp: row.temperature_air_sensor_average,
                hum_air: row.humidity_air_sensor_average,
                hum_sol: row.humidity_ground_sensor_average,
                uv: row.uv_sensor_average,
                fertility: row.conductivity_elec_sensor_average
            },
            targets: {
                temp: row.target_temp,
                hum_air: row.target_hum_air,
                hum_sol: row.target_hum_sol,
                uv: row.target_uv,
                fertility: row.target_fertility
            }
        },

        plant_details: {
            type_id: row.id_plant_type,
            type_title: row.plant_title,
            group_title: row.gpt_title,
            avatar_title: row.avatar_title,
            image_path: row.path_picture
        }
    };
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
