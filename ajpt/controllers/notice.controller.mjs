import { CreateNoticeRequest } from "../models/notice.mjs";
import { ResponseApi } from "../models/response-api.mjs";

/**
 * Création d'une remarque utilisateur
 */
const CreateNotice = async (body) => {
    try {
        const { id_person, title, content } = body;

        // Validation stricte des paramètres obligatoires
        if (!id_person || !title || !content) {
            return new ResponseApi().InitMissingParameters();
        }

        const data = await CreateNoticeRequest(body);
        
        if (data) {
            return new ResponseApi().InitCreated("Votre remarque a bien été enregistrée.", data);
        } else {
            return new ResponseApi().InitBadRequest("Impossible d'enregistrer la remarque.");
        }
        
    } catch (e) {
        console.error("Error in CreateNotice:", e);
        // On vérifie si c'est une erreur de clé étrangère (ex: id_person n'existe pas)
        if (e.code === '23503') {
            return new ResponseApi().InitBadRequest("L'utilisateur, l'object_profile ou le tag spécifié n'existe pas.");
        }
        return new ResponseApi().InitInternalServer(e.message);
    }
};

export { CreateNotice };