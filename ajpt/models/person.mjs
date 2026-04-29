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
    return new Promise(async (resolve, reject) => {
        try {
            // 1. On cherche d'abord par MAIL uniquement (Priorité)
            const userByMail = await GetByMail(person.mail);

            if (userByMail) {
                // CAS A : Le mail existe déjà et est vérifié -> On bloque (Sécurité)
                if (userByMail.is_verified) {
                    return resolve(false);
                }

                // CAS B : Le mail existe mais n'est pas vérifié -> On peut écraser
                // MAIS on doit vérifier que son "nouveau" pseudo n'est pas pris par un autre
                const pseudoTaken = await CheckPseudoAvailability(person.pseudo, userByMail.id_person);
                if (pseudoTaken) {
                    return reject({ code: '23505', message: "Ce pseudo est déjà réservé par un autre compte." });
                }

                return updateUnverifiedPerson(userByMail.id_person, person).then(resolve).catch(reject);
            }

            // CAS C : Le mail n'existe pas -> On veut créer
            // On vérifie quand même si le PSEUDO est pris par n'importe qui (fantôme ou pas)
            const pseudoTaken = await CheckPseudoAvailability(person.pseudo, null);
            if (pseudoTaken) {
                return reject({ code: '23505', message: "Ce pseudo est déjà utilisé." });
            }

            return insertNewPerson(person).then(resolve).catch(reject);

        } catch (error) {
            reject(error);
        }
    });
}

/**
 * Cherche un utilisateur par son mail uniquement
 */
const GetByMail = (mail) => {
    return pool.query('SELECT * FROM person WHERE mail = $1', [mail])
        .then(res => res.rows.length > 0 ? res.rows[0] : null);
};

/**
 * Vérifie si un pseudo est déjà utilisé par quelqu'un d'autre
 * @param {string} pseudo 
 * @param {number|null} excludeId - L'ID de l'utilisateur actuel (pour s'exclure soi-même)
 */
const CheckPseudoAvailability = (pseudo, excludeId) => {
    const query = excludeId 
        ? { text: 'SELECT 1 FROM person WHERE pseudo = $1 AND id_person != $2', values: [pseudo, excludeId] }
        : { text: 'SELECT 1 FROM person WHERE pseudo = $1', values: [pseudo] };
    
    return pool.query(query).then(res => res.rows.length > 0);
};

// Fonction pour un nouvel utilisateur
const insertNewPerson = (person) => {
    person.id_role = person.id_role ?? 1;
    const request = {
        text: `INSERT INTO person(pseudo, password, mail, firstname, surname, number_phone, id_role, last_connexion, is_verified) 
               VALUES ($1, encode(digest($2, 'sha256'), 'hex'), $3, $4, $5, $6, $7, $8, FALSE) RETURNING *`,
        values: [person.pseudo, person.password, person.mail, person.firstname, person.surname, person.number_phone, person.id_role, person.last_connexion],
    };
    return pool.query(request).then(res => res.rows[0]);
};

// Fonction pour écraser les données d'un compte non-validé
const updateUnverifiedPerson = (id, person) => {
    const request = {
        text: `UPDATE person 
               SET pseudo = $1, 
                   password = encode(digest($2, 'sha256'), 'hex'), 
                   mail = $3, 
                   firstname = $4, 
                   surname = $5, 
                   number_phone = $6, 
                   last_connexion = $7 
               WHERE id_person = $8 AND is_verified = FALSE
               RETURNING *`,
        values: [person.pseudo, person.password, person.mail, person.firstname, person.surname, person.number_phone, person.last_connexion, id],
    };
    return pool.query(request).then(res => res.rows[0]);
};

/**
 * Prépare la vérification d'email lors de l'inscription
 */
const SetRegisterVerification = (mail, code) => {
    return new Promise((resolve, reject) => {
        const query = {
            text: `UPDATE person 
                   SET reset_password_token = encode(digest($1, 'sha256'), 'hex'), 
                       reset_password_expires = NOW() + INTERVAL '24 hours' 
                   WHERE mail = $2 
                   RETURNING id_person, firstname`,
            values: [code, mail]
        };

        pool.query(query, (error, result) => {
            if (error) {
                // Ici c'est une VRAIE erreur (ex: syntaxe SQL, coupure réseau)
                return reject(error); 
            }
            // Si result.rows est vide, on renvoie null (pas d'erreur technique, juste pas de match)
            resolve(result.rows.length > 0 ? result.rows[0] : null);
        });
    });
};

const FinalizeAccount = (body) => {
    const { mail, pseudo, password, code } = body;

    return new Promise((resolve, reject) => {
        const query = {
            text: `UPDATE person 
                   SET is_verified = TRUE,
                       reset_password_token = NULL, 
                       reset_password_expires = NULL 
                   WHERE mail = $1 
                     AND pseudo = $2
                     -- On transforme le hash binaire en texte hexadécimal pour comparer avec le VARCHAR
                     AND password = encode(digest($3, 'sha256'), 'hex')
                     AND reset_password_token = encode(digest($4, 'sha256'), 'hex')
                     AND reset_password_expires > (NOW() AT TIME ZONE 'utc' AT TIME ZONE 'Europe/Paris')
                   RETURNING id_person, pseudo, mail, firstname, surname, number_phone, id_role, last_connexion`,
            values: [mail, pseudo, password, code]
        };

        pool.query(query, (error, result) => {
            if (error) {
                console.error("Erreur SQL détaillée:", error);
                return reject(error);
            }
            
            if (result.rows.length === 0) {
                return resolve(null);
            }

            resolve(result.rows[0]);
        });
    });
};


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
            // Utilisation des backticks pour éviter le conflit avec 'sha256' et 'hex'
            text: `SELECT * FROM person 
                   WHERE (pseudo = $1 OR mail = $1) 
                   AND password = encode(digest($2, 'sha256'), 'hex')`,
            values: [person.pseudo, person.password],
        }
        pool.query(request, (error, result) => {
            if (error) {
                console.error("Erreur Login SQL:", error);
                reject(error);
            } else {
                resolve(result.rows.length > 0 ? result.rows[0] : null);
            }
        });
    });
}

/**
 * Recherche stricte pour la Connexion (Login)
 */
const GetByIdAndPasswordVerified = (person) => {
    return new Promise((resolve, reject) => {
        const request = {
            text: `SELECT id_person, pseudo, mail, firstname, surname, id_role, is_verified 
                   FROM person 
                   WHERE (pseudo = $1 OR mail = $1) 
                   AND password = encode(digest($2, 'sha256'), 'hex') 
                   AND is_verified = TRUE`,
            values: [person.pseudo, person.password],
        }
        pool.query(request, (error, result) => {
            if (error) reject(error);
            else resolve(result.rows.length > 0 ? result.rows[0] : null);
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

            const updateQuery = {
                text: `UPDATE person 
                       SET password = encode(digest($1, 'sha256'), 'hex'), 
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

export {Person, Add, GetByIdAndPassword, GetByIdAndPasswordVerified, ModifyLastConnexion, GenerateToken, SetPasswordReset, CheckResetCode, UpdatePasswordWithCode, SetRegisterVerification, FinalizeAccount}