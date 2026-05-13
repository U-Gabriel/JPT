import {CreateRequestObjectProfile, GetObjectProfileResumeByPerson, GetObjectProfileResumeFavorisByPerson, UpdateObjectProfileController, GetRequestObjectProfiledetailsByOPController, DeleteObjectProfileController } from "../controllers/object_profile.controller.mjs";
import objectAuth from "../middlewares/object_auth.mjs"
import express from "express"


const routerObjectProfile = express.Router()

// Assure-toi que le middleware (ex: authToken) est présent avant le contrôleur
routerObjectProfile.post("/object_profile/create/init", CreateRequestObjectProfile);


routerObjectProfile.get("/object_profile/resume/byperson", GetObjectProfileResumeByPerson);

routerObjectProfile.get("/object_profile/resume/favoris/byperson", GetObjectProfileResumeFavorisByPerson);

routerObjectProfile.patch("/object_profile/update/byobjectprofile", UpdateObjectProfileController);


routerObjectProfile.post("/object_profile/detail/byop", async (req, res) => {
    const response = await GetRequestObjectProfiledetailsByOPController(req.body)
    res.status(response.code).send(response)
});

routerObjectProfile.post("/object_profile/delete/byobjectprofile", async (req, res) => {
    const response = await DeleteObjectProfileController(req.body);
    res.status(response.code).send(response);
});

routerObjectProfile.delete("/object_profile/delete/byobjectprofile", async (req, res) => {
    const response = await DeleteObjectProfileController(req.body);
    res.status(response.code).json(response);
});

routerObjectProfile.patch("/object/object_profile/update/byobjectprofile", objectAuth, async (req, res) => {
    const response = await UpdateObjectProfileController(req.body)
    res.status(response.code).send(response)
});



export {routerObjectProfile}