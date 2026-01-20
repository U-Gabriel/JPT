import { GetRequestPlantTypeSearchByTitle} from "../models/plant_type.mjs";
import {ResponseApi} from "../models/response-api.mjs";


/**
 * Display a liste plant type search by title
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetPlantTypeSearchByTitle = (pt) => {
    return new Promise((resolve) => {
        if (!pt) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            GetRequestPlantTypeSearchByTitle(pt)
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

export {GetPlantTypeSearchByTitle}