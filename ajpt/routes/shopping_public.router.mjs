import { GetCatalog } from "../controllers/shopping_public.controller.mjs";
import express from "express";

const routerShoppingPublic = express.Router();

/**
 * Route pour afficher le catalogue de la boutique
 * Accessible sans forcément être connecté (Public)
 */
routerShoppingPublic.post("/shop/catalog", async (req, res) => {
    const response = await GetCatalog(req.body);
    res.status(response.code).send(response);
});

export { routerShoppingPublic };