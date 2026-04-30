import { GetFaqsByTagsRequest, GetFaqsByObjectRequest } from "../models/faq.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const GetFaqsByTags = async (body) => {
    try {
        const { id_tag, title_search } = body || {}; 

        // On passe les deux paramètres au modèle
        const data = await GetFaqsByTagsRequest(id_tag, title_search);
        
        if (data) {
            return new ResponseApi().InitOK(data);
        } else {
            return new ResponseApi().InitBadRequest("Erreur lors de la récupération de la FAQ.");
        }
        
    } catch (e) {
        console.error("Error in GetFaqsByTags:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

const GetFaqsByObject = async (body) => {
    try {
        // On vérifie si le body existe et contient id_object
        if (!body || body.id_object === undefined) {
            return new ResponseApi().InitMissingParameters();
        }

        const { id_object } = body;
        const data = await GetFaqsByObjectRequest(id_object);
        
        if (data && data.length > 0) {
            return new ResponseApi().InitOK(data);
        } else {
            // Si l'objet existe mais n'a pas de FAQ dédiée
            return new ResponseApi().InitNoContent();
        }
        
    } catch (e) {
        console.error("Error in GetFaqsByObject:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

export { GetFaqsByTags, GetFaqsByObject };