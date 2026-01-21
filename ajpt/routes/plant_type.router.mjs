import { GetPlantTypeSearchByTitle, GetPlantTypeDescription} from "../controllers/plant_type.controller.mjs";
import express from "express"

const routerPlantType = express.Router()

routerPlantType.post("/plant_type/search/bytitle", async (req, res) => {
    const response = await GetPlantTypeSearchByTitle(req.body)
    res.status(response.code).send(response)
});

routerPlantType.post("/plant_type/description/byid", async (req, res) => {
    const response = await GetPlantTypeDescription(req.body)
    res.status(response.code).send(response)
});



export {routerPlantType}