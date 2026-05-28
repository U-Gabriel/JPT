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
        is_automatic,
        path_picture
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, (SELECT picture_path 
         FROM avatar 
         WHERE state = 0
         ORDER BY RANDOM() 
         LIMIT 1))
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


const GetRequestObjectProfileResumeByPerson = async (id_person) => {
    if (!id_person) throw new Error("id_person is required");

    const query = `
        SELECT 
            op.id_object_profile,
            op.title AS op_title,
            op.is_automatic,
            op.is_water,
            op.state_plant,
            op.path_picture AS plant_path_picture,
            op.id_object,
            obj.id_category_type AS id_category_type_object,
            pt.id_plant_type AS id_plant_type,
            pt.title AS plant_title
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN object obj ON obj.id_object = op.id_object
        WHERE op.id_person = $1 AND op.activate = 1
        ORDER BY op.id_object_profile DESC;
    `;

    const { rows } = await pool.query(query, [id_person]);

    return rows.map(row => ({
        id_object_profile: row.id_object_profile,
        title: row.op_title,
        is_automatic: row.is_automatic,
        is_water: row.is_water,
        state: row.state_plant,
        path_picture: row.plant_path_picture,
        id_object: row.id_object,
        id_category_type_object: row.id_category_type_object,
        plant_type: {
            id_plant_type: row.id_plant_type,
            title: row.plant_title
        }
    }));
};


const GetRequestObjectProfileResumeFavorisByPerson = async (id_person) => {
    if (!id_person) throw new Error("id_person is required");

    const query = `
        SELECT 
            op.id_object_profile,
            op.title AS op_title,
            op.is_automatic,
            op.is_water,
            op.state_plant,
            op.path_picture AS op_path_picture,
            op.id_object,
            obj.id_category_type AS id_category_type_object,
            pt.id_plant_type AS id_plant_type,
            pt.title AS plant_title
        FROM object_profile op
        LEFT JOIN plant_type pt ON pt.id_plant_type = op.id_plant_type
        LEFT JOIN object obj ON obj.id_object = op.id_object
        WHERE op.id_person = $1 
          AND op.is_favorite = true 
          AND op.activate = 1
        ORDER BY op.id_object_profile DESC;
    `;

    const { rows } = await pool.query(query, [id_person]);

    return rows.map(row => ({
        id_object_profile: row.id_object_profile,
        title: row.op_title,
        is_automatic: row.is_automatic,
        is_water: row.is_water,
        state: row.state_plant,
        path_picture: row.op_path_picture,
        id_object: row.id_object,
        id_category_type_object: row.id_category_type_object,
        plant_type: {
            id_plant_type: row.id_plant_type,
            title: row.plant_title
        }
    }));
};

const updateObjectProfile = async (id_object_profile, id_person, fields) => {
    
    // Construction dynamique des clauses SET
    // On commence l'indexation à 1 pour les paramètres $1, $2, etc.
    const setClauses = Object.keys(fields).map(
        (key, index) => `${key} = $${index + 1}`
    );
    
    const values = Object.values(fields);
    
    // On ajoute les IDs à la fin des valeurs pour le WHERE
    const profileIdx = values.length + 1;
    const personIdx = values.length + 2;

    const query = {
        text: `
            UPDATE object_profile
            SET ${setClauses.join(", ")}
            WHERE id_object_profile = $${profileIdx} 
              AND id_person = $${personIdx}
            RETURNING *;
        `,
        values: [...values, id_object_profile, id_person],
    };

    const { rows } = await pool.query(query);

    if (rows.length === 0) {
        // Si aucune ligne n'est modifiée, soit l'ID n'existe pas, soit il n'appartient pas à l'user
        throw new Error("NOT_FOUND");
    }

    return rows[0];
};



const GetRequestObjectProfiledetailsByOP = async ({ id_object_profile }) => {
    if (!id_object_profile) throw new Error("id_object_profile is required");

    const query = `
        SELECT 
            op.*, -- Toutes les infos de object_profile
            op.modify_op,
            op.title AS op_title,
            op.path_picture AS op_path_picture,
            -- Infos du groupe (Cibles)
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
        -- JOINTURE AVEC LES GROUPES (La partie qui posait souci)
        LEFT JOIN group_plant_type gpt ON (
            -- Soit c'est le groupe lié via la table de liaison
            gpt.id_group_plant_type = (
                SELECT id_group_plant_type 
                FROM lnk_person_op_group 
                WHERE id_object_profile = op.id_object_profile 
                AND is_active = true 
                LIMIT 1
            )
            OR 
            -- Soit c'est le groupe standard par défaut s'il n'y a pas de lien actif
            (gpt.id_plant_type = op.id_plant_type AND gpt.is_standard = true)
        )
        -- JOINTURE AVEC L'AVATAR (Ta logique de paliers que l'on a vu au début)
        LEFT JOIN avatar a 
            ON a.id_plant_type = pt.id_plant_type
            AND (a.evolution_number = op.state_plant OR a.evolution_number = 0)
        WHERE op.id_object_profile = $1
        ORDER BY 
            -- Priorité 1 : Le groupe qui n'est pas standard (donc personnalisé par l'user)
            gpt.is_standard ASC, 
            -- Priorité 2 : L'avatar le plus proche (pour ton image)
            a.evolution_number DESC
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
        path_picture: row.op_path_picture,
        description: row.description,
        advise: row.advise,
        state: row.state_plant, // Ton score de santé 1-4
        advice_realtime: advice_realtime,
        is_automatic: row.is_automatic,
        is_water: row.is_water,
        is_favorite: row.is_favorite,
        last_watering: row.last_watering_date,
        last_update: row.modify_op,
        
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

const DeleteObjectProfile = async ({ id_object_profile, id_person }) => {
  const client = await pool.connect();
  try {
    // On commence la transaction DIRECTEMENT ici
    await client.query('BEGIN');

    // 1. On vérifie l'existence et l'état
    const checkRes = await client.query(
      `SELECT is_automatic, 
       (modify_op >= NOW() - INTERVAL '24 hours') as is_stable
       FROM object_profile 
       WHERE id_object_profile = $1 AND id_person = $2`,
      [id_object_profile, id_person]
    );

    if (checkRes.rows.length === 0) {
      await client.query('ROLLBACK'); // Toujours rollback avant de quitter
      return { status: 404, message: "Profil introuvable ou accès refusé." };
    }

    const { is_automatic, is_stable } = checkRes.rows[0];

    // 2. Logique de blocage Sécurisée
    if (is_automatic && is_stable) {
      await client.query('ROLLBACK');
      return { status: 403, message: "BLOCK_AUTO" };
    }

    const successCode = (is_automatic && !is_stable) ? 202 : 200;

    // 3. Suppression dans l'ordre des contraintes
    await client.query(
      `DELETE FROM lnk_person_op_group WHERE id_object_profile = $1`, 
      [id_object_profile]
    );

    await client.query(
      `DELETE FROM object_profile WHERE id_object_profile = $1 AND id_person = $2`, 
      [id_object_profile, id_person]
    );

    await client.query('COMMIT');

    return { 
      status: successCode, 
      message: successCode === 202 ? "OFFLINE_FORCE_DELETE" : "SUCCESS_DELETE" 
    };

  } catch (error) {
    if (client) await client.query('ROLLBACK');
    console.error("ERREUR SQL:", error);
    return { status: 500, message: "Erreur base de données : " + error.message };
  } finally {
    client.release();
  }
};

export { ObjectProfile, createObjectProfile, GetRequestObjectProfileResumeByPerson, GetRequestObjectProfileResumeFavorisByPerson, updateObjectProfile, GetRequestObjectProfiledetailsByOP, DeleteObjectProfile };
