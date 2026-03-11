import { GetRequestGroupPlantType, PatchAssignGroupRequestGroupPlantType, DeleteRequestGroupPlantType} from "../models/group_plant_type.mjs";
import {ResponseApi} from "../models/response-api.mjs";



/**
 * Display a plant type description by id
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetGroupPlantType = async (body) => {
    try {
        if (!body.id_person || !body.id_object_profile) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await GetRequestGroupPlantType(body);
        return new ResponseApi().InitOK(data);
        
    } catch (e) {
        console.error("Error in GetGroupPlantType:", e);
        return new ResponseApi().InitInternalServer(e.message);
    }
};

/**
 * Update a group plant assignation by id
 * @returns {Promise<unknown>}
 * @constructor
 */
const PatchAssignGroupPlantType = async (body) => {
    try {
        if (!body.id_person || !body.id_object_profile) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await PatchAssignGroupRequestGroupPlantType(body);
        return new ResponseApi().InitOK(data);
        
    } catch (e) {
        console.error("Error in GetGroupPlantType:", e);
        return new ResponseApi().InitInternalServer(e.message);
    }
};


/**
 * Delete a group plant type by id
 * @returns {Promise<unknown>}
 * @constructor
 */
const DeleteGroupPlantType = async (body) => {
    try {
        if (!body.id_person || !body.id_group_plant_type) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await DeleteRequestGroupPlantType(body);
        return new ResponseApi().InitOK(data);
        
    } catch (e) {
        console.error("Error in GetGroupPlantType:", e);
        return new ResponseApi().InitInternalServer(e.message);
    }
};


export {GetGroupPlantType, PatchAssignGroupPlantType, DeleteGroupPlantType}