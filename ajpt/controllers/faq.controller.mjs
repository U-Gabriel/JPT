import {CreateFaqRequest, GetAllFaqsCompleteRequest, GetFaqsByTagsRequest, GetFaqsByObjectRequest, DeleteFaqRequest } from "../models/faq.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const CreateFaq = async (body) => {
    try {
        const { question, answer, id_tag, id_object, order_view } = body;

        // Validation stricte
        if (!question || !answer) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await CreateFaqRequest(question, answer, id_tag, id_object, order_view);
        
        return new ResponseApi().InitCreated("FAQ créée avec succès.", data);
    } catch (e) {
        console.error("Error in CreateFaq:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

const GetAllFaqsComplete = async () => {
    try {
        const data = await GetAllFaqsCompleteRequest();
        
        if (data && data.length > 0) {
            return new ResponseApi().InitOKResponse("Liste complète des FAQ récupérée.", data);
        } else {
            return new ResponseApi().InitNoContent();
        }
    } catch (e) {
        console.error("Error in GetAllFaqsComplete:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

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

const DeleteFaq = async (body) => {
    try {
        const { id_faq } = body;

        if (!id_faq) {
            return new ResponseApi().InitMissingParameters();
        }

        const success = await DeleteFaqRequest(id_faq);
        
        if (success) {
            return new ResponseApi().InitOK("FAQ supprimée avec succès.", null);
        } else {
            return new ResponseApi().InitBadRequest("FAQ non trouvée.");
        }
    } catch (e) {
        console.error("Error in DeleteFaq:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

export { CreateFaq, GetAllFaqsComplete, GetFaqsByTags, GetFaqsByObject, DeleteFaq };