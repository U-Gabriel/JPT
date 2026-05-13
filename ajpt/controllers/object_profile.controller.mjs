import {ObjectProfile, createObjectProfile, GetRequestObjectProfileResumeByPerson, GetRequestObjectProfileResumeFavorisByPerson, updateObjectProfile, GetRequestObjectProfiledetailsByOP, DeleteObjectProfile } from "../models/object_profile.mjs";
import {ResponseApi} from "../models/response-api.mjs";

/**
 * Create a new object_profile
 * @returns {Promise<unknown>}
 * @constructor
 */
const CreateRequestObjectProfile = async (req, res) => {
    try {
        // 1. Extraction de l'ID depuis le token (injecté par ton middleware)
        const id_person = req.data?.id_person;

        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("Utilisateur non identifié"));
        }

        // 2. On combine l'ID du token avec les données du formulaire (titre, type de plante, etc.)
        const profileData = {
            ...req.body,
            id_person: id_person
        };

        // 3. Appel de la fonction de création
        const response = await createObjectProfile(profileData);

        return res.status(200).send(new ResponseApi().InitOK(response));

    } catch (e) {
        if (e.code === "23503") {
            return res.status(400).send(new ResponseApi().InitBadRequest("Erreur de référence (ID plante ou objet invalide)"));
        }
        console.error("Erreur création profil:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e.message));
    }
};


/**
 * Display a resume object_profile by person
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetObjectProfileResumeByPerson = async (req, res) => {
    try {
        // 1. On extrait l'ID (Vérifie si c'est req.data ou req.user selon ton middleware)
        const id_person = req.data?.id_person; 

        // 2. Si l'ID est absent, on s'arrête ici avec une 401 ou 400
        if (!id_person) {
            console.error("ID Person manquant dans le token");
            return res.status(401).send(new ResponseApi().InitUnauthorized("Token invalide ou id_person manquant"));
        }

        // 3. On passe l'ID à la requête SQL
        const data = await GetRequestObjectProfileResumeByPerson(id_person);

        return res.status(200).send(
            new ResponseApi().InitOK(data)
        );
    } catch (e) {
        console.error("Erreur SQL:", e.message);
        return res.status(500).send(new ResponseApi().InitInternalServer(e.message));
    }
};

/**
 * Display a resume object_profile Favoris by person
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetObjectProfileResumeFavorisByPerson = async (req, res) => {
    try {
        const id_person = req.data?.id_person;

        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("Non autorisé"));
        }

        // On passe directement l'ID (sans accolades)
        const data = await GetRequestObjectProfileResumeFavorisByPerson(id_person);

        return res.status(200).send(
            new ResponseApi().InitOK(data)
        );
    } catch (e) {
        console.error("Error in GetObjectProfileResumeFavorisByPerson:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e.message));
    }
};

/**
 * Update an object_profile by id with dynamic fields
 * Requires id_person in the body to ensure ownership
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateObjectProfileController = async (req, res) => {
    try {
        const id_person = req.data?.id_person;
        const { id_object_profile, id_person: discardedPerson, ...updateFields } = req.body;

        // Vérification des paramètres essentiels
        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("Non autorisé"));
        }
        if (!id_object_profile) {
            return res.status(400).send(new ResponseApi().InitMissingParameters("id_object_profile est requis"));
        }
        if (Object.keys(updateFields).length === 0) {
            return res.status(400).send(new ResponseApi().InitBadRequest("Aucun champ à modifier"));
        }

        // Appel du modèle en passant séparément l'ID du profil, l'ID du proprio et les champs
        const updatedData = await updateObjectProfile(id_object_profile, id_person, updateFields);

        return res.status(200).send(new ResponseApi().InitOK(updatedData));

    } catch (e) {
        if (e.message === "NOT_FOUND") {
            return res.status(404).send(new ResponseApi().InitNotFound("Profil inexistant ou accès refusé"));
        }
        console.error("Erreur UpdateObjectProfile:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e.message));
    }
};

/**
 * Display a detail object_profile by id
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetRequestObjectProfiledetailsByOPController = (op) => {
    return new Promise((resolve) => {
        if (!op) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            GetRequestObjectProfiledetailsByOP(op)
                .then((data) => {
                    resolve(new ResponseApi().InitOK(data));
                    
                })
                .catch((e) => {
                    if (e.code === '23503') {
                        resolve(new ResponseApi().InitBadRequest(e.message));
                        return;
                    }
                    console.error(e);
                    resolve(new ResponseApi().InitInternalServer(e.message));
                });
        }
    });
};

const DeleteObjectProfileController = (body) => {
    return new Promise(async (resolve) => {
        // Destructuring pour être sûr de ce qu'on teste
        const { id_object_profile, id_person } = body || {};

        if (!id_object_profile || !id_person) {
            return resolve(new ResponseApi().InitMissingParameters());
        }

        try {
            const result = await DeleteObjectProfile({ id_object_profile, id_person });

            // On crée une réponse générique et on lui affecte le code et le message du résultat
            const response = new ResponseApi();
            response.code = result.status;
            response.status = result.status < 400 ? "OK" : "KO";
            response.message = result.message;
            response.data = result;

            resolve(response);
        } catch (e) {
            // Code 23503 = Violation de contrainte (clé étrangère)
            if (e.code === "23503") {
                return resolve(new ResponseApi().InitBadRequest("Impossible de supprimer : ce profil est encore utilisé par des groupes de plantes."));
            }
            
            if (e.message?.includes("not found") || e.message?.includes("denied")) {
                return resolve(new ResponseApi().InitBadRequest(e.message));
            }

            console.error("Erreur Delete Controller:", e);
            resolve(new ResponseApi().InitInternalServer(e.message));
        }
    });
};


export {CreateRequestObjectProfile, GetObjectProfileResumeByPerson, GetObjectProfileResumeFavorisByPerson, UpdateObjectProfileController, GetRequestObjectProfiledetailsByOPController, DeleteObjectProfileController }