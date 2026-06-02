import express from "express";
import {AddCategoryType, AddObject, GetAllCategoriesWithProducts, GetCategoriesList } from "../controllers/category_type_object.controller.mjs";
import authToken from "../middlewares/auth.mjs";
import { upload } from "../middlewares/upload.mjs";
import { checkRoles } from "../middlewares/auth_role.mjs"; // Middleware pour vérifier les rôles

const routerCategoryObject = express.Router();

/**
 * Nouvelle Route : Création de catégorie
 * Accès restreint : Uniquement aux utilisateurs connectés ayant le rôle 3 OU 7
 * Body attendu : { "title": "...", "description": "...", "advise": "..." }
 */
routerCategoryObject.post(
    "/categories/create", 
    authToken, 
    checkRoles([3, 7]),
    async (req, res) => {
        const response = await AddCategoryType(req.body);
        res.status(response.code).send(response);
    }
);

/**
 * Route : Création d'un objet avec envoi de fichiers physiques (images)
 * POST /objects/create
 */
routerCategoryObject.post(
    "/objects/create",
    authToken,
    checkRoles([3, 7]),
    upload.array('images', 10), // Intercepte les fichiers du champ "images"
    async (req, res) => {
        // req.body contiendra tous les champs textes de l'objet
        // req.files contiendra le tableau des fichiers téléchargés
        const response = await AddObject(req.body, req.files);
        res.status(response.code).send(response);
    }
);

/**
 * Route permettant de récupérer l'ensemble des catégories avec leurs objets
 * GET /categories/catalog
 */
routerCategoryObject.get("/categories/catalog", async (req, res) => {
    const response = await GetAllCategoriesWithProducts();
    res.status(response.code).send(response);
});

/**
 * Nouvelle Route : Liste simplifiée des catégories (ID et Titre uniquement)
 * GET /categories/lookup
 */
routerCategoryObject.get("/categories/lookup", async (req, res) => {
    const response = await GetCategoriesList();
    res.status(response.code).send(response);
});

export { routerCategoryObject };