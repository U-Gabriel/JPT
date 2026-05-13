import express from "express";
import { GetAvatarsWithoutPlant } from "../controllers/avatar.controller.mjs";

const routerAvatar = express.Router();

// Route pour récupérer les avatars génériques (id_plant_type IS NULL)
routerAvatar.get("/avatar/get/list/state/null", GetAvatarsWithoutPlant);

export { routerAvatar };