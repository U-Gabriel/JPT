import { AddPlant, GetAllPlantsController, GetPlantTypeSearchByTitle, GetPlantTypeDescription} from "../controllers/plant_type.controller.mjs";
import { uploadPlant } from "../middlewares/upload_plant.mjs";
import { checkRoles } from "../middlewares/auth_role.mjs";
import express from "express"

const routerPlantType = express.Router()

routerPlantType.post(
    "/plants/create", 
    checkRoles([2, 3]), 
    uploadPlant.array('images', 10), 
    AddPlant
);

routerPlantType.get("/plants/all", checkRoles([2, 3]), GetAllPlantsController);

routerPlantType.post("/plant_type/search/bytitle", async (req, res) => {
    const response = await GetPlantTypeSearchByTitle(req.body)
    res.status(response.code).send(response)
});

routerPlantType.post("/plant_type/description/byid", async (req, res) => {
    const response = await GetPlantTypeDescription(req.body)
    res.status(response.code).send(response)
});



export {routerPlantType}