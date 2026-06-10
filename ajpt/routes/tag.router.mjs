import {CreateTag, GetAllTag, GetLvlOneTag, DeleteTag } from "../controllers/tag.controller.mjs";
import authToken from "../middlewares/auth.mjs";
import { checkRoles } from "../middlewares/auth_role.mjs";
import express from "express";

const routerTag = express.Router();

// Route POST pour créer un tag, protégée par les rôles 2 et 3
routerTag.post("/tag/create", authToken, checkRoles([2, 3]), async (req, res) => {
    const response = await CreateTag(req.body);
    res.status(response.code).send(response);
});

routerTag.get("/tags", async (req, res) => {
    const response = await GetAllTag();
    res.status(response.code).send(response);
});

routerTag.get("/tags/lvl/1", async (req, res) => {
    const response = await GetLvlOneTag();
    res.status(response.code).send(response);
});


routerTag.post("/tag/delete", authToken, checkRoles([2, 3]), async (req, res) => {
    const response = await DeleteTag(req.body);
    res.status(response.code).send(response);
});

export { routerTag };