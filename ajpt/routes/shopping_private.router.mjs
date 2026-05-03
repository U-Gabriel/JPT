import express from "express";
import { GetCartItemCount } from "../controllers/shopping_private.controller.mjs";

const routerShoppingPrivate = express.Router();

/**
 * Route pour récupérer le nombre d'articles dans le panier d'un utilisateur
 * Privé : Nécessite un Token JWT (fournit le id_person)
 */
routerShoppingPrivate.post("/shop/cart/count", GetCartItemCount);

export { routerShoppingPrivate };