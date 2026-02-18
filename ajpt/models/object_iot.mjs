import { pool } from "../middlewares/postgres.mjs";

const SHARED_OBJECT_KEY = "bhjl651165b5454516erjkfblaf4g56456g4654fg65q4e65g4qe64g6e4g5e4";

const updateObjectProfileObj = async (body) => {
    const { 
        id_object_profile, 
        last_time_arrosage, 
        sensor_data, 
        last_watering_date,  
    } = body;

    // 2. VALIDATIONS DES DONNÉES
    if (!id_object_profile) throw new Error("id_object_profile is required");
    if (!sensor_data || !sensor_data.length) throw new Error("sensor_data is required");

    
    const [latestUV, latestTemp, latestHum, latestArid] = sensor_data[sensor_data.length - 1];
    const count = sensor_data.length;
    
    const sums = sensor_data.reduce((acc, curr) => [
        acc[0] + curr[0], acc[1] + curr[1], acc[2] + curr[2], acc[3] + curr[3]
    ], [0, 0, 0, 0]);

    const averages = {
        uv: parseFloat((sums[0] / count).toFixed(2)),
        temp: parseFloat((sums[1] / count).toFixed(2)),
        hum: parseFloat((sums[2] / count).toFixed(2)),
        arid: parseFloat((sums[3] / count).toFixed(2))
    };

    // --- ÉTAPE 2 : REQUÊTE SQL ATOMIQUE (CTE) ---
    const query = {
        text: `
            WITH updated_op AS (
                UPDATE object_profile
                SET 
                    uv_sensor = $1,
                    temperature_air_sensor = $2,
                    humidity_air_sensor = $3,
                    conductivity_elec_sensor = $4,
                    uv_sensor_average = $5,
                    temperature_air_sensor_average = $6,
                    humidity_air_sensor_average = $7,
                    conductivity_elec_sensor_average = $8,
                    modify_op = COALESCE($9, NOW()),
                    last_watering_date = COALESCE($11, last_watering_date),
                    is_water = false
                WHERE id_object_profile = $10
                RETURNING id_object_profile, id_plant_type
            )
            SELECT 
                g.conductivity_electrique_fertility_sensor,
                g.temperature_sensor_extern,
                g.humidity_air_sensor,
                g.exposition_time_uv,
                g.watering_time,
                g.prority_plant,
                true AS is_activate
            FROM updated_op up
            LEFT JOIN group_plant_type g ON (
                (g.id_object_profile = up.id_object_profile AND g.is_active = true)
                OR 
                (g.id_plant_type = up.id_plant_type AND g.is_standard = true)
            )
            ORDER BY (g.id_object_profile IS NOT NULL) DESC, g.is_standard DESC
            LIMIT 1;
        `,
        values: [
            latestUV, latestTemp, latestHum, latestArid,              // $1 à $4
            averages.uv, averages.temp, averages.hum, averages.arid,  // $5 à $8
            last_time_arrosage || null,                               // $9
            id_object_profile,                                        // $10
            last_watering_date || null                                // $11
        ]
    };

    const { rows } = await pool.query(query);

    if (rows.length === 0) {
        throw new Error("Update failed: Object profile not found");
    }

    return rows[0];
};

export { updateObjectProfileObj };