import {ObjectProfile, createObjectProfile, GetRequestObjectProfileResumeByPerson, GetRequestObjectProfileResumeFavorisByPerson, updateObjectProfile, GetRequestObjectProfiledetailsByOP, DeleteObjectProfile } from "../models/object_profile.mjs";
import {ResponseApi} from "../models/response-api.mjs";

/**
 * Create a new object_profile
 * @returns {Promise<unknown>}
 * @constructor
 */
const CreateRequestObjectProfile = (body) => {
  return new Promise((resolve) => {
    if (!body) {
      resolve(new ResponseApi().InitMissingParameters());
    } else {
      createObjectProfile(body)
        .then((data) => {
          resolve(new ResponseApi().InitOK(data));
        })
        .catch((e) => {
          if (e.code === "23503") {
            // Foreign key violation
            resolve(new ResponseApi().InitBadRequest(e.message));
            return;
          }
          if (e.code === "23505") {
            // Unique violation (au cas où tu ajoutes une contrainte unique plus tard)
            resolve(new ResponseApi().InitBadRequest(e.message));
            return;
          }
          console.error(e);
          resolve(new ResponseApi().InitInternalServer(e.message));
        });
    }
  });
};


/**
 * Display a resume object_profile by person
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetObjectProfileResumeByPerson = (op) => {
    return new Promise((resolve) => {
        if (!op) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            GetRequestObjectProfileResumeByPerson(op)
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

/**
 * Display a resume object_profile Favoris by person
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetObjectProfileResumeFavorisByPerson = (op) => {
    return new Promise((resolve) => {
        if (!op) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            GetRequestObjectProfileResumeFavorisByPerson(op)
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

/**
 * Update an object_profile by id with dynamic fields
 * Requires id_person in the body to ensure ownership
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateObjectProfileController = (op) => {
    return new Promise((resolve) => {
        // Vérifie que body, id_object_profile et id_person sont présents
        if (!op || !op.id_object_profile || !op.id_person) {
            resolve(new ResponseApi().InitMissingParameters());
            return;
        }

        // Appelle la fonction update avec le body complet
        updateObjectProfile(op)
            .then((data) => {
                // Vérifie que le profil appartient bien à l'utilisateur
                if (data.id_person !== op.id_person) {
                    resolve(new ResponseApi().InitBadRequest(
                        "You cannot update this ObjectProfile because it does not belong to you."
                    ));
                    return;
                }

                resolve(new ResponseApi().InitOK(data));
            })
            .catch((e) => {
                if (e.message === "NOT_FOUND") {
                    // C'est ce 404 qui fera dire "-1" à l'ESP32
                    return resolve(new ResponseApi().InitNotFound("Profil inexistant"));
                }
                if (e.code === "23503") {
                    resolve(new ResponseApi().InitBadRequest(e.message));
                    return;
                }
                console.error(e);
                resolve(new ResponseApi().InitInternalServer(e.message));
            });
    });
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