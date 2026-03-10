import {GetGroupPlantType} from "../controllers/group_plant_type.controller.mjs";
import express from "express"

const routerGroupPlantType = express.Router()

routerGroupPlantType.post("/group_plant_type/resume", async (req, res) => {
    const response = await GetGroupPlantType(req.body)
    res.status(response.code).send(response)
});


export {routerGroupPlantType}