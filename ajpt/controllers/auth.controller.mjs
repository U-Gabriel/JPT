import {Add, GetByIdAndPassword, GenerateToken, ModifyLastConnexion} from '../models/person.mjs'
import {ResponseApi} from "../models/response-api.mjs";


/**
 * Enregistre une nouvelle personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Register = (person) => {
    return new Promise((resolve, _) => {
        if (person == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else if (person.pseudo == null || person.password == null) {
            resolve(new ResponseApi().InitMissingParameters())
        } else {
            Add(person).then((res) => {
                if (res) {
                    resolve(new ResponseApi().InitCreated("Person has been created."))
                } else {
                    resolve(new ResponseApi().InitBadRequest("This person already existed."))
                }
            }).catch((e) => {
                if(e.code === '23503') {
                    resolve(new ResponseApi().InitBadRequest(e.message))
                    return
                }
                console.error(e)
                resolve(new ResponseApi().InitInternalServer(e))
            })
        }
    });
}

/**
 * Authentification d'un utilisateur
 * @param pseudo
 * @param password Le mot de passe
 * @returns {Promise<unknown>}
 * @constructor
 */
const Authentication = async (person) => {
    return new Promise(async (resolve, _) => {
        if(person.pseudo == null || person.password == null) {
            resolve(new ResponseApi().InitMissingParameters())
            return
        }
        try{
            const res = await GetByIdAndPassword(person);
            if(!res) {
                resolve(new ResponseApi().InitUnauthorized("This pseudo and password not matching."))
                return
            }
            const modifyDateNow = ModifyLastConnexion(person.pseudo)
            res.token = GenerateToken(res)
            console.log(res.token)
            resolve(new ResponseApi().InitOK(res))
        } catch(error) {
            resolve(new ResponseApi().InitInternalServer(error))
        }
    });
}



export {Register, Authentication}