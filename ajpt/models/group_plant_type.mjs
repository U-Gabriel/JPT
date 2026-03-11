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

const PatchAssignGroupRequestGroupPlantType = async ({ id_person, id_group_plant_type, id_object_profile, is_standard }) => {
    // 1. Validation de base
    if (!id_person || !id_object_profile) {
        throw new Error("Missing parameters: id_person, id_group_plant_type, and id_object_profile are required");
    }

    try {
        // 2. SI STANDARD : On désactive juste les liens personnalisés
        if (is_standard === true) {
            const queryStandard = `
                UPDATE lnk_person_op_group
                SET is_active = false
                WHERE id_person = $1 AND id_object_profile = $2;
            `;
            await pool.query(queryStandard, [id_person, id_object_profile]);
            
            return { 
                success: true, 
                active_group_id: id_group_plant_type,
                message: "Retour au mode standard" 
            };
        }

        // 3. SI PERSO (ou si is_standard est absent/false) : On fait l'Upsert
        const query = `
            WITH deactivate_all AS (
                UPDATE lnk_person_op_group
                SET is_active = false
                WHERE id_person = $1 AND id_object_profile = $3
                RETURNING id_person
            ),
            upsert_active AS (
                INSERT INTO lnk_person_op_group (id_person, id_group_plant_type, id_object_profile, is_active)
                VALUES ($1, $2, $3, true)
                ON CONFLICT (id_person, id_group_plant_type, id_object_profile) 
                DO UPDATE SET is_active = true
                RETURNING id_group_plant_type
            )
            SELECT id_group_plant_type FROM upsert_active;
        `;

        const { rows } = await pool.query(query, [id_person, id_group_plant_type, id_object_profile]);
        
        return {
            success: true,
            active_group_id: rows[0]?.id_group_plant_type,
            message: "Group assignment updated successfully"
        };

    } catch (error) {
        // Capturera les erreurs pour les DEUX types de requêtes
        console.error("Error in PatchAssignGroup:", error.message);
        throw error;
    }
};

const DeleteRequestGroupPlantType = async ({ id_person, id_group_plant_type }) => {
    if (!id_person || !id_group_plant_type) {
        throw new Error("id_person and id_group_plant_type are required");
    }

    const query = `
        WITH verify_ownership AS (
            -- On vérifie d'abord si l'utilisateur est lié à ce groupe
            -- et que ce n'est PAS un groupe standard (on ne veut pas que l'user supprime les réglages par défaut)
            SELECT id_group_plant_type 
            FROM lnk_person_op_group 
            WHERE id_person = $1 AND id_group_plant_type = $2
            LIMIT 1
        ),
        delete_lnk AS (
            -- 1. Supprimer toutes les lignes de liaison pour ce groupe (pour TOUS les objets de cet user)
            DELETE FROM lnk_person_op_group
            WHERE id_group_plant_type IN (SELECT id_group_plant_type FROM verify_ownership)
        )
        -- 2. Supprimer le groupe lui-même
        DELETE FROM group_plant_type
        WHERE id_group_plant_type IN (SELECT id_group_plant_type FROM verify_ownership)
        AND is_standard = false
        RETURNING id_group_plant_type;
    `;

    try {
        const { rows } = await pool.query(query, [id_person, id_group_plant_type]);

        if (rows.length === 0) {
            throw new Error("Suppression impossible : groupe introuvable, déjà supprimé ou vous n'avez pas les droits.");
        }

        return { success: true, deleted_id: rows[0].id_group_plant_type };
    } catch (error) {
        console.error("Error in DeleteGroupPlantType:", error.message);
        throw error;
    }
};

export { GetRequestGroupPlantType, PatchAssignGroupRequestGroupPlantType, DeleteRequestGroupPlantType };