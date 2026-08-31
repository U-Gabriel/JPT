import { CreateNoticeRequest, CountUserNotices, GetAllNoticesRequest, GetNoticesByPersonRequest,  UpdateNoticeStatusRequest, DeleteNoticeByPersonRequest } from "../models/notice.mjs";
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

        // --- AJOUT DE LA LIMITE ---
        const noticeCount = await CountUserNotices(id_person);
        
        if (noticeCount >= 5) {
            return new ResponseApi().InitBadRequest("Limite de 5 remarques atteinte. Merci de patienter que nos équipes traitent vos demandes actuelles.");
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

/**
 * Récupération de toutes les remarques
 */
const GetAllNotices = async () => {
    try {
        const data = await GetAllNoticesRequest();
        return new ResponseApi().InitOKResponse("Liste des remarques récupérée.", data);
    } catch (e) {
        console.error("Error in GetAllNotices:", e);
        return new ResponseApi().InitInternalServer("Erreur lors de la récupération des remarques.");
    }
};

/**
 * Récupération des remarques d'un utilisateur spécifique
 */
const GetNoticesByPerson = async (req, res) => {
    try {
        const id_person = req.data?.id_person;

        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("data is required"));
        }

        const data = await GetNoticesByPersonRequest(id_person);
        return res.status(200).send(new ResponseApi().InitOKResponse("Liste des remarques de l'utilisateur récupérée.", data));
    } catch (e) {
        console.error("Error in GetNoticesByPerson:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer("Erreur lors de la récupération des remarques."));
    }
};

const UpdateNoticeStatus = async (body) => {
    try {
        const { id_notice, status } = body;

        if (!id_notice || !status) {
            return new ResponseApi().InitMissingParameters();
        }

        const result = await UpdateNoticeStatusRequest(id_notice, status);
        
        if (result.action === 'deleted') {
            return new ResponseApi().InitOK("Notice résolue et supprimée.", null);
        } else {
            return new ResponseApi().InitOK("Status de la notice mis à jour.", result.data);
        }
    } catch (e) {
        console.error("Error in UpdateNoticeStatus:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

/**
 * Suppression d'une remarque par son propriétaire
 */
const DeleteNoticeByPerson = async (req, res) => {
    try {
        const id_person = req.data?.id_person;
        const { id_notice } = req.body;

        if (!id_person || id_person == null) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("Data error"));
        }

        if (!id_notice || id_notice == null) {
            return res.status(400).send(new ResponseApi().InitMissingParameters("Data error"));
        }

        const deletedNotice = await DeleteNoticeByPersonRequest(id_notice, id_person);

        if (!deletedNotice) {
            return res.status(404).send(new ResponseApi().InitBadRequest("Data error"));
        }

        return res.status(200).send(new ResponseApi().InitOK("La remarque a bien été supprimée.", null));
    } catch (e) {
        console.error("Error in DeleteNoticeByPerson:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer("Erreur lors de la suppression de la remarque."));
    }
};

export { CreateNotice, GetAllNotices, GetNoticesByPerson, UpdateNoticeStatus, DeleteNoticeByPerson };