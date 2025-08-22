import {GetObjectProfileResumeByPerson, GetObjectProfileResumeFavorisByPerson} from "../controllers/object_profile.controller.mjs";
import express from "express"


const routerObjectProfile = express.Router()

routerObjectProfile.post("/object_profile/resume/byperson", async (req, res) => {
    const response = await GetObjectProfileResumeByPerson(req.body)
    res.status(response.code).send(response)
});

routerObjectProfile.post("/object_profile/resume/favoris/byperson", async (req, res) => {
    const response = await GetObjectProfileResumeFavorisByPerson(req.body)
    res.status(response.code).send(response)
});


export {routerObjectProfile}