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

/**
 * Vérifie l'existence d'un utilisateur par mail et enregistre le code de reset
 * @param {string} mail 
 * @param {string} code 
 * @returns {Promise<object|null>} L'utilisateur si trouvé, sinon null
 */
const SetPasswordReset = (mail, code) => {
    return new Promise((resolve, reject) => {
        // On récupère d'abord l'utilisateur pour vérifier s'il existe et avoir son prénom
        const queryCheck = {
            text: 'SELECT id_person, firstname FROM person WHERE mail = $1',
            values: [mail]
        };

        pool.query(queryCheck, (error, result) => {
            if (error) return reject(error);
            if (result.rows.length === 0) return resolve(null);

            const user = result.rows[0];

            // On met à jour le token et l'expiration
            const queryUpdate = {
                text: `UPDATE person 
                       SET reset_password_token = encode(digest($1, 'sha256'), 'hex'), 
                            reset_password_expires = (NOW() AT TIME ZONE 'utc' AT TIME ZONE 'Europe/Paris') + INTERVAL '15 minutes'
                       WHERE id_person = $2 
                       RETURNING id_person, firstname`,
                values: [code, user.id_person]
            };

            pool.query(queryUpdate, (error, updateResult) => {
                if (error) return reject(error);
                resolve(updateResult.rows[0]);
            });
        });
    });
};

/**
 * Vérifie si le code de récupération est valide sans modifier le mot de passe
 * @param {string} mail 
 * @param {string} code 
 * @returns {Promise<boolean>}
 */
const CheckResetCode = (mail, code) => {
    return new Promise((resolve, reject) => {
        const query = {
            text: `SELECT id_person FROM person 
                   WHERE mail = $1 
                   AND reset_password_token = encode(digest($2, 'sha256'), 'hex')
                   AND reset_password_expires > (NOW() AT TIME ZONE 'utc' AT TIME ZONE 'Europe/Paris')`,
            values: [mail, code]
        };

        pool.query(query, (error, result) => {
            if (error) return reject(error);
            // Si on trouve une ligne, c'est que le code est bon et valide
            resolve(result.rows.length > 0);
        });
    });
};

/**
 * Modifie le mot de passe après validation finale du code
 */
const UpdatePasswordWithCode = (mail, code, newPassword) => {
    return new Promise((resolve, reject) => {
        // 1. On vérifie d'abord si le code est toujours valide
        const checkQuery = {
            text: `SELECT id_person FROM person 
                   WHERE mail = $1 
                   AND reset_password_token = encode(digest($2, 'sha256'), 'hex')
                   AND reset_password_expires > (NOW() AT TIME ZONE 'utc' AT TIME ZONE 'Europe/Paris')`,
            values: [mail, code]
        };

        pool.query(checkQuery, (error, result) => {
            if (error) return reject(error);
            if (result.rows.length === 0) return resolve(null);

            const id_person = result.rows[0].id_person;

            // 2. Mise à jour du mot de passe + Nettoyage des champs de récupération
            const updateQuery = {
                text: `UPDATE person 
                       SET password = sha256($1), 
                           reset_password_token = NULL, 
                           reset_password_expires = NULL 
                       WHERE id_person = $2 
                       RETURNING id_person`,
                values: [newPassword, id_person]
            };

            pool.query(updateQuery, (err, resUpdate) => {
                if (err) return reject(err);
                resolve(resUpdate.rows[0]);
            });
        });
    });
};

export {Person, Add, GetByIdAndPassword, ModifyLastConnexion, GenerateToken, SetPasswordReset, CheckResetCode, UpdatePasswordWithCode}