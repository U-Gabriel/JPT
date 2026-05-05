import express from "express";
import { GetCartItemCount, AddToCart, GetCartItems, DeleteCartItem } from "../controllers/shopping_private.controller.mjs";

const routerShoppingPrivate = express.Router();

/**
 * Route pour récupérer le nombre d'articles dans le panier d'un utilisateur
 * Privé : Nécessite un Token JWT (fournit le id_person)
 */
routerShoppingPrivate.post("/shop/cart/count", GetCartItemCount);
routerShoppingPrivate.post("/shop/cart/add", AddToCart);
routerShoppingPrivate.get("/shop/cart/list", GetCartItems);
routerShoppingPrivate.post("/shop/cart/delete", DeleteCartItem);

export { routerShoppingPrivate };