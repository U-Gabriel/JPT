import {Add, GetByIdAndPassword, GenerateToken, ModifyLastConnexion, SetPasswordReset, CheckResetCode, UpdatePasswordWithCode} from '../models/person.mjs'
import { getForgotEmailHtml } from "../templates/forgot_mail_template.mjs";
import {ResponseApi} from "../models/response-api.mjs";
import crypto from 'crypto';
import transporter from '../services/mail_service.mjs';


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
                    res.token = GenerateToken(res)
                    resolve(new ResponseApi().InitCreated("Person has been created.", res))
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
        if(( person.pseudo == null && person.mail == null) || person.password == null) {
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

const SendMailForgotPassword = async (body) => {
    const { mail } = body;

    if (!mail) return new ResponseApi().InitMissingParameters();

    try {
        // 1. Génération du code
        const resetCode = Math.floor(100000 + Math.random() * 900000).toString();

        // 2. Appel de la logique DB (Compartimentée)
        const user = await SetPasswordReset(mail, resetCode);
        
        if (!user) {
            // Sécurité : on ne dit pas que le mail n'existe pas
            return new ResponseApi().InitOK({ message: "Si ce compte existe, un mail a été envoyé." });
        }

        // 3. Envoi du mail
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: mail,
            subject: 'Réinitialisation de votre mot de passe',
            html: getForgotEmailHtml(user.firstname, resetCode)
        };

        await transporter.sendMail(mailOptions);

        return new ResponseApi().InitOK({ message: "Si ce compte existe, un mail a été envoyé." });

    } catch (error) {
        console.error("Erreur Forgot Password:", error);
        return new ResponseApi().InitInternalServer("Une erreur est survenue.");
    }
};

const ConfimationSimpleForgotPassword = async (body) => {
    const { mail, code } = body;

    if (!mail || !code) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        const isValid = await CheckResetCode(mail, code);

        if (isValid) {
            return new ResponseApi().InitOK({ 
                valid: true, 
                message: "Code vérifié avec succès." 
            });
        } else {
            return new ResponseApi().InitBadRequest("Le code est invalide ou a expiré.");
        }

    } catch (error) {
        console.error("Erreur Confirmation Code:", error);
        return new ResponseApi().InitInternalServer("Une erreur est survenue lors de la vérification.");
    }
};

const ModificationForgotPassword = async (body) => {
    const { mail, code, password } = body;

    // Contrôles de présence
    if (!mail || !code || !password) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        // Appel de la fonction de mise à jour
        const updatedUser = await UpdatePasswordWithCode(mail, code, password);

        if (!updatedUser) {
            // Soit le code a expiré entre temps, soit il est faux
            return new ResponseApi().InitBadRequest("Le code est invalide ou a expiré. Veuillez recommencer la procédure.");
        }

        return new ResponseApi().InitOK({ 
            message: "Votre mot de passe a été modifié avec succès. Vous pouvez maintenant vous connecter." 
        });

    } catch (error) {
        console.error("Erreur Modification Password:", error);
        return new ResponseApi().InitInternalServer("Une erreur est survenue lors de la modification du mot de passe.");
    }
};

export {Register, Authentication, SendMailForgotPassword, ConfimationSimpleForgotPassword, ModificationForgotPassword}