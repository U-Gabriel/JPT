import {CreateTagRequest, GetAllTagRequest, DeleteTagRequest } from "../models/tag.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const CreateTag = async (body) => {
    try {
        const { title, color_code, description, lvl_page } = body;

        // Validation basique
        if (!title) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await CreateTagRequest(title, color_code || '#2ecc71', description, lvl_page);
        
        return new ResponseApi().InitCreated("Tag créé avec succès.", data);
    } catch (e) {
        console.error("Error in CreateTag:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};


const GetAllTag = async () => {
    try {
        const data = await GetAllTagRequest();
        
        if (data && data.length > 0) {
            
            return new ResponseApi().InitOK(data);
        } else {
            return new ResponseApi().InitNoContent();
        }
    } catch (e) {
        return new ResponseApi().InitInternalServer(e);
    }
};

const DeleteTag = async (body) => {
    try {
        const { id_tag } = body;

        // Contrôle du body ici
        if (!id_tag) {
            return new ResponseApi().InitBadRequest("L'ID du tag est manquant dans le body.");
        }

        const success = await DeleteTagRequest(id_tag);
        
        if (success) {
            return new ResponseApi().InitOK("Tag supprimé avec succès.", null);
        } else {
            return new ResponseApi().InitBadRequest("Tag non trouvé.");
        }
    } catch (e) {
        console.error("Error in DeleteTag:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};


export {CreateTag, GetAllTag, DeleteTag };