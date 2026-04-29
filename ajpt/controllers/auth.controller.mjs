import {Add, GetByIdAndPassword, GetByIdAndPasswordVerified, GenerateToken, ModifyLastConnexion, SetPasswordReset, CheckResetCode, UpdatePasswordWithCode, SetRegisterVerification, FinalizeAccount} from '../models/person.mjs'
import { getForgotEmailHtml } from "../templates/forgot_mail_template.mjs";
import { getRegisterEmailHtml } from "../templates/register_mail_template.mjs";
import { getAlreadyRegisteredEmailHtml } from "../templates/already_registered_mail_template.mjs";
import { getWelcomeEmailHtml } from "../templates/welcome_mail_template.mjs";
import {ResponseApi} from "../models/response-api.mjs";
import crypto from 'crypto';
import transporter from '../services/mail_service.mjs';


/**
 * Enregistre une nouvelle personne
 * @returns {Promise<unknown>}
 * @constructor
 */
const Register = async (person) => {
    // On extrait explicitement pour être sûr d'avoir les valeurs
    const { pseudo, mail, password } = person;

    if (!pseudo || !mail || !password) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        const res = await Add(person);
        if (res) {
            res.token = GenerateToken(res);
            // On utilise la variable "mail" extraite plus haut
            RegisterSendMail({ mail: mail }); 
            return new ResponseApi().InitCreated("Compte prêt. Veuillez vérifier vos mails.", res);
        } else {
            // Ici aussi, on utilise la variable "mail" extraite
            sendAlreadyRegisteredMail(mail); 

            return new ResponseApi().InitCreated("Si ce compte existe, un mail de validation a été envoyé.");
        }
    } catch (e) {
        if(e.code === '23505') return new ResponseApi().InitBadRequest("Ce pseudo est déjà utilisé.");
        console.error(e);
        return new ResponseApi().InitInternalServer(e);
    }
}

/**
 * Fonction interne pour envoyer le mail d'alerte
 */
const sendAlreadyRegisteredMail = async (mail) => {
    // Sécurité : si le mail est manquant, on stoppe tout de suite
    if (!mail) {
        console.error("Erreur : Impossible d'envoyer le mail d'alerte, l'adresse est vide.");
        return;
    }

    try {
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: mail, // On s'assure que cette variable contient bien l'email
            subject: 'Tentative d’inscription sur votre compte GDOME App',
            html: getAlreadyRegisteredEmailHtml("ATTENTION") 
        };

        await transporter.sendMail(mailOptions);
        console.log(`✅ Mail d'alerte envoyé à : ${mail}`);
    } catch (error) {
        console.error("Erreur envoi mail compte déjà existant:", error);
    }
};

const RegisterSendMail = async (body) => {
    const { mail } = body;
    if (!mail) return new ResponseApi().InitMissingParameters();

    try {
        const registerCode = Math.floor(100000 + Math.random() * 900000).toString();

        // 1. On tente la mise à jour en BDD
        const user = await SetRegisterVerification(mail, registerCode);

        // 2. Si l'utilisateur existe, on envoie le mail
        if (user) {
            const mailOptions = {
                from: process.env.EMAIL_USER,
                to: mail,
                subject: 'Activez votre compte Plante App',
                html: getRegisterEmailHtml(user.mail, registerCode)
            };
            
            // On n'attend pas forcément l'envoi pour répondre OK, 
            // ou on l'attend mais on ne change pas la réponse client.
            await transporter.sendMail(mailOptions);
        }

        // 3. DANS TOUS LES CAS (que l'user existe ou non), on renvoie 200
        // Sauf si une exception a été jetée avant (direction le catch)
        return new ResponseApi().InitOK({ 
            message: "Si ce compte existe, un mail de validation a été envoyé." 
        });

    } catch (error) {
        // SEULEMENT ici on renvoie une 500 car c'est une erreur imprévue
        console.error("Erreur critique Register Mail:", error);
        return new ResponseApi().InitInternalServer("Une erreur technique est survenue.");
    }
};

const RegisterAccount = async (body) => {
    const { pseudo, mail, password, code } = body;

    if (!pseudo || !mail || !password || !code) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        const updatedUser = await FinalizeAccount(body);

        if (!updatedUser) {
            return new ResponseApi().InitBadRequest("Le code de validation est incorrect ou a expiré.");
        }

        sendWelcomeMail(updatedUser.mail);

        return new ResponseApi().InitOK({ 
            message: "Compte validé et profil mis à jour avec succès !",
            user: {
                pseudo: updatedUser.pseudo,
                mail: updatedUser.mail
            }
        });

    } catch (error) {
        // Gestion de l'erreur si le nouveau pseudo ou mail est déjà pris (contrainte UNIQUE)
        if (error.code === '23505') {
            return new ResponseApi().InitBadRequest("Ce pseudo ou cet email est déjà utilisé par un autre compte.");
        }
        
        console.error("Erreur Validation Compte:", error);
        return new ResponseApi().InitInternalServer("Une erreur est survenue lors de la validation.");
    }
};

const sendWelcomeMail = async (mail) => {
    try {
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: mail,
            subject: 'Bienvenue chez GDOME - Compte validé !',
            html: getWelcomeEmailHtml(mail)
        };
        await transporter.sendMail(mailOptions);
        console.log(`✅ Mail de bienvenue envoyé à : ${mail}`);
    } catch (error) {
        console.error("Erreur envoi mail de bienvenue:", error);
    }
};

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
            const res = await GetByIdAndPasswordVerified(person);
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

export {Register, Authentication, SendMailForgotPassword, ConfimationSimpleForgotPassword, ModificationForgotPassword, RegisterSendMail, RegisterAccount}