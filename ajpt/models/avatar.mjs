import {pool} from "../middlewares/postgres.mjs"

class Avatar {
    id_avatar
    title
    description
    picture_path
    evolution_number
    state
    id_plant_type
}

/**
 * Récupère la liste des avatars n'étant liés à aucun type de plante spécifique
 * @returns {Promise<Array>}
 */
const GetRequestAvatarsWithoutPlant = async () => {
    const query = `
        SELECT 
            id_avatar,
            title,
            description,
            picture_path,
            evolution_number,
            state
        FROM avatar
        WHERE id_plant_type IS NULL
        ORDER BY evolution_number ASC, title ASC;
    `;

    const { rows } = await pool.query(query);

    // On mappe les données pour renvoyer un format propre
    return rows.map(row => ({
        id_avatar: row.id_avatar,
        title: row.title,
        description: row.description,
        path_picture: row.picture_path,
        evolution: row.evolution_number,
        state: row.state
    }));
};

const UpdatePicturePathModel = async (id_profile, id_person, path) => {
    const query = {
        text: `
            UPDATE object_profile 
            SET path_picture = $1 
            WHERE id_object_profile = $2 AND id_person = $3
            RETURNING id_object_profile;
        `,
        values: [path, id_profile, id_person]
    };

    const { rows } = await pool.query(query);

    if (rows.length === 0) {
        throw new Error("NOT_FOUND");
    }
    return rows[0];
};

export {GetRequestAvatarsWithoutPlant, UpdatePicturePathModel}