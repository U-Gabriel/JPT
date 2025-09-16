import {GetObjectProfileResumeByPerson, GetObjectProfileResumeFavorisByPerson, UpdateObjectProfileController, GetRequestObjectProfiledetailsByOPController } from "../controllers/object_profile.controller.mjs";
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


routerObjectProfile.patch("/object_profile/update/byobjectprofile", async (req, res) => {
    const response = await UpdateObjectProfileController(req.body)
    res.status(response.code).send(response)
});

routerObjectProfile.post("/object_profile/detail/byop", async (req, res) => {
    const response = await GetRequestObjectProfiledetailsByOPController(req.body)
    res.status(response.code).send(response)
});

export {routerObjectProfile}