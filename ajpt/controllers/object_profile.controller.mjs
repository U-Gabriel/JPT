import {ObjectProfile, GetRequestObjectProfileResumeByPerson, GetRequestObjectProfileResumeFavorisByPerson, updateObjectProfile, GetRequestObjectProfiledetailsByOP } from "../models/object_profile.mjs";
import {ResponseApi} from "../models/response-api.mjs";


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
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateObjectProfileController = (body) => {
    return new Promise((resolve) => {
        if (!body) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            updateObjectProfile(body)
                .then((data) => {
                    resolve(new ResponseApi().InitOK(data));
                })
                .catch((e) => {
                    if (e.code === "23503") {
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


export {GetObjectProfileResumeByPerson, GetObjectProfileResumeFavorisByPerson, UpdateObjectProfileController, GetRequestObjectProfiledetailsByOPController }