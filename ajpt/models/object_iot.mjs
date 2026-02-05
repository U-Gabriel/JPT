import { pool } from "../middlewares/postgres.mjs";


const updateObjectProfileObj = async (body) => {
    const { id_object_profile, ...fields } = body;

    if (!id_object_profile) {
        throw new Error("id_object_profile is required");
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
            WHERE id_object_profile = $${values.length + 1}
            RETURNING *;
        `,
        values: [...values, id_object_profile],
    };

    const { rows } = await pool.query(query);

    if (rows.length === 0) {
        throw new Error(`ObjectProfile with id ${id_object_profile} not found or does not belong to this user`);
    }

    return rows[0];
};



export { updateObjectProfileObj };
