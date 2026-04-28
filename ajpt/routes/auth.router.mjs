import {Register, Authentication, SendMailForgotPassword, ConfimationSimpleForgotPassword, ModificationForgotPassword} from '../controllers/auth.controller.mjs'
import express from "express"

const routerAuth = express.Router()


routerAuth.post("/register", async (req, res) => {
    const response = await Register(req.body)
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


export {routerAuth}