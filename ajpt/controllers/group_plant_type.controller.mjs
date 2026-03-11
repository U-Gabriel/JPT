import {CreateAndAssignCustomGroup, GetRequestGroupPlantType, PatchAssignGroupRequestGroupPlantType, DeleteRequestGroupPlantType} from "../models/group_plant_type.mjs";
import {ResponseApi} from "../models/response-api.mjs";



/**
 * Display a plant type description by id
 * @returns {Promise<unknown>}
 * @constructor
 */
const CreateAndAssignGroup = async (body) => {
    try {
        const { id_person, id_object_profile, id_plant_type, title } = body;

        // 2. On vérifie les variables locales qu'on vient de créer
        if (!id_person || !id_object_profile || !id_plant_type || !title) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await CreateAndAssignCustomGroup(body);
        return new ResponseApi().InitOK(data);
        
    } catch (e) {
        console.error("Error in CreateAndAssignGroup:", e);
        return new ResponseApi().InitInternalServer(e.message);
    }
};


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
        console.error("Error in PatchAssignGroupPlantType:", e);
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
        console.error("Error in DeleteGroupPlantType:", e);
        return new ResponseApi().InitInternalServer(e.message);
    }
};


export {CreateAndAssignGroup, GetGroupPlantType, PatchAssignGroupPlantType, DeleteGroupPlantType}