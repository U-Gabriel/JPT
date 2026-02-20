import {updateObjectProfileObj, updateIsAutomaticObjectProfileObj, updateCheckAndResetIsWaterObj} from "../models/object_iot.mjs";
import {ResponseApi} from "../models/response-api.mjs";


/**
 * Update an object_profile by id with dynamic fields
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateObjectProfileObjController = (op) => {
    return new Promise((resolve) => {
        // Vérifie que body, id_object_profile et id_person sont présents
        if (!op || !op.id_object_profile) {
            resolve(new ResponseApi().InitMissingParameters());
            return;
        }

        // Appelle la fonction update avec le body complet
        updateObjectProfileObj(op)
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
    });
};

/**
 * Update an object_profile by id for is_automatic
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateIsAutomaticObjectProfileObjController = (op) => {
    return new Promise((resolve) => {
        // Vérifie que body, id_object_profile et id_person sont présents
        if (!op || !op.id_object_profile) {
            resolve(new ResponseApi().InitMissingParameters());
            return;
        }

        // Appelle la fonction update avec le body complet
        updateIsAutomaticObjectProfileObj(op)
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
    });
};

/**
 * Update an object_profile by id for the motor
 * @returns {Promise<unknown>}
 * @constructor
 */
const UpdateIsMotorObjectProfileObjController = (op) => {
    return new Promise((resolve) => {
        // Vérifie que body, id_object_profile et id_person sont présents
        if (!op || !op.id_object_profile) {
            resolve(new ResponseApi().InitMissingParameters());
            return;
        }

        // Appelle la fonction update avec le body complet
        updateCheckAndResetIsWaterObj(op)
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
    });
};


export { UpdateObjectProfileObjController, UpdateIsAutomaticObjectProfileObjController, UpdateIsMotorObjectProfileObjController }