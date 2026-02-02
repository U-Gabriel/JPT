import {Register, Authentication} from '../controllers/auth.controller.mjs'
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

export {routerAuth}