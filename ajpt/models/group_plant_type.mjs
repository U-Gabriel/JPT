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
    temperature_sensor_estern
    humidity_air_sensor
    humidity_ground_sensor
    exposition_time_sun
    height_min
    height_max
    id_plant_type
    id_object_profile
}



export {GroupPlantType}