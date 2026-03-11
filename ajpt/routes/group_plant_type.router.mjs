import {CreateAndAssignGroup, GetGroupPlantType, PatchAssignGroupPlantType, DeleteGroupPlantType} from "../controllers/group_plant_type.controller.mjs";
import express from "express"

const routerGroupPlantType = express.Router()

routerGroupPlantType.post("/group_plant_type/create/byid", async (req, res) => {
    const response = await CreateAndAssignGroup(req.body)
    res.status(response.code).send(response)
});

routerGroupPlantType.post("/group_plant_type/resume", async (req, res) => {
    const response = await GetGroupPlantType(req.body)
    res.status(response.code).send(response)
});

routerGroupPlantType.patch("/group_plant_type/patch/assignation/byid", async (req, res) => {
    const response = await PatchAssignGroupPlantType(req.body)
    res.status(response.code).send(response)
});


routerGroupPlantType.delete("/group_plant_type/delete/byid", async (req, res) => {
    const response = await DeleteGroupPlantType(req.body)
    res.status(response.code).send(response)
});


export {routerGroupPlantType}