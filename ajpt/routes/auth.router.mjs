import {Register, Authentication, SendMailForgotPassword, ConfimationSimpleForgotPassword, ModificationForgotPassword, RegisterSendMail, RegisterAccount, SearchPersons, GetMyProfile, RemoveUser} from '../controllers/auth.controller.mjs'


import express from "express"
import authToken from "../middlewares/auth.mjs"; // Ton middleware actuel
import { checkRoles } from "../middlewares/auth_role.mjs"; // Le nouveau middleware


const routerAuth = express.Router()


routerAuth.post("/register", async (req, res) => {
    const response = await Register(req.body)
    res.status(response.code).send(response)
});

routerAuth.patch("/register/send_mail", async (req, res) => {
    const response = await RegisterSendMail(req.body)
    res.status(response.code).send(response)
});

routerAuth.patch("/register/validate_account", async (req, res) => {
    const response = await RegisterAccount(req.body)
    res.status(response.code).send(response)
});

routerAuth.post("/login_app", async (req, res) => {
    const response = await Authentication(req.body)
    res.status(response.code).send(response)
});

routerAuth.patch("/login_app/forgot_password", async (req, res) => {
    const response = await SendMailForgotPassword(req.body)
    res.status(response.code).send(response)
});

routerAuth.post("/login_app/forgot_password/confirmation_simple", async (req, res) => {

    const response = await ConfimationSimpleForgotPassword(req.body)

    res.status(response.code).send(response)

});

routerAuth.patch("/login_app/forgot_password/modification", async (req, res) => {
    const response = await ModificationForgotPassword(req.body)
    res.status(response.code).send(response)
});

/**
 * Route pour rechercher des personnes via le body
 * Body attendu : { "searchText": "ton_texte" } ou { "searchText": "" } pour le défaut
 */
routerAuth.post("/persons/search", async (req, res) => {
    const response = await SearchPersons(req.body);
    res.status(response.code).send(response);
});

/**
 * Route : Récupération du profil
 * GET /me
 * Sécurisée par authToken (qui injecte req.user.id_person)
 */
routerAuth.get("/persons/me", authToken, async (req, res) => {
    // req.user est injecté par ton middleware d'authentification
    const response = await GetMyProfile(req.data.id_person);
    res.status(response.code).send(response);
});

/**
 * Route de suppression d'un utilisateur
 * Sécurisée par Token ET par Rôle Admin (3)
 */
routerAuth.post("/persons/delete", authToken, checkRoles([3]), async (req, res) => {
    const response = await RemoveUser(req.body);
    res.status(response.code).send(response);
});

export {routerAuth}