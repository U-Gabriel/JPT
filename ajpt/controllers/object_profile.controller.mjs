import {ObjectProfile, GetRequestObjectProfileResumeByPerson} from "../models/object_profile.mjs";
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




export {GetObjectProfileResumeByPerson}