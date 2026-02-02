import {pool} from "../middlewares/postgres.mjs"
import jwt from "jsonwebtoken"

class Person {
    id_person
    pseudo
    mail
    firstname
    surname
    number_phone
    id_role
    password
    last_connexion
}

/**
 * Ajoute une nouvelle personne si elle n'éxiste pas
 * @param person La nouvelle personne à ajouter
 * @returns {Promise<unknown>}
 * @constructor
 */
const Add = (person) => {
    return new Promise((resolve, reject) => {
        GetByPseudoOrMail(person).then((result) => {
            if (!result) {
                person.id_role = person.id_role ?? 1
                
                const request = {
                    text: 'INSERT INTO person(pseudo, password, mail, firstname, surname, number_phone, id_role, last_connexion) VALUES ($1, sha256($2), $3, $4, $5, $6, $7, $8) RETURNING *',
                    values: [person.pseudo, person.password, person.mail, person.firstname, person.surname, person.number_phone, person.id_role, person.last_connexion],
                }
                pool.query(request, (error, result) => {
                    if (error) {
                        reject(error)
                    } else {
                        let res = (result.rows.length > 0) ? result.rows[0] : null
                        resolve(res)
                        
                    }
                });
            } else {
                resolve(false)
            }
        }).catch((e) => {
            reject(e)
        });
    });
}

/**
 * Récupération d'une personne par son pseudo
 * @param pseudo
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetByPseudoOrMail = (person) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM person WHERE pseudo = $1 OR mail = $2',
            values: [person.pseudo, person.mail],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res)
            }
        });
    });
}



/**
 * Récupération d'une personne par son pseudo et son mot de passe
 * @param pseudo
 * @param password Le mot de passe
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetByIdAndPassword = (person) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: 'SELECT * FROM person WHERE (pseudo = $1 OR mail = $1) AND password::bytea = sha256($2)',
            values: [person.pseudo, person.password],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res)
            }
        });
    });
}

/**
 * Modification de la dernière connexiion de la personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const ModifyLastConnexion = (pseudo) => {

    let date_time = new Date();
    let year = date_time.getFullYear();
    let month = ("0" + (date_time.getMonth() + 1)).slice(-2);
    let date = ("0" + date_time.getDate()).slice(-2);
    let dateNow = year + "-" + month + "-" + date;


    return new Promise((resolve, reject) => {
        const request = {
            text: 'UPDATE person SET last_connexion = $1 WHERE pseudo = $2',
            values: [dateNow, pseudo],
        }
        pool.query(request, (error, result) => {
            if (error) {
                reject(error)
            } else {
                let res = (result.rows.length > 0) ? result.rows[0] : null
                resolve(res)
            }
        });
    });
}


/**
 * Génère le JWT token
 * @returns {*|null}
 * @constructor
 * @param person
 */
const GenerateToken = (person) => {
    if(!person) {
        return null
    }
    try{
        return jwt.sign(person, process.env.TOKEN, { expiresIn: "1d" })
    } catch(e) {
        console.log(e)
        throw e
    }
}

export {Person, Add, GetByIdAndPassword, ModifyLastConnexion, GenerateToken}