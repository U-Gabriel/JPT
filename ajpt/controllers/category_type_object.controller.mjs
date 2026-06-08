import {CreateCategoryType, CreateObjectWithAssets, GetCategoriesWithObjects, GetCategoriesLightweight, GetObjectsLightweight, GetUserCategoriesWithProfiles, GetUserFavoriteCategoriesWithProfiles, IncrementObjectStock } from "../models/category_type_object.mjs";
import { ResponseApi } from "../models/response-api.mjs";


/**
 * Contrôleur pour la création d'une catégorie
 */
const AddCategoryType = async (body = {}) => {
    const { title, description, advise } = body;

    // Le titre est obligatoire pour créer une catégorie
    if (!title) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        const newCategory = await CreateCategoryType({ title, description, advise });
        return new ResponseApi().InitCreated("Catégorie créée avec succès.", newCategory);
    } catch (error) {
        console.error("Erreur contrôleur AddCategoryType :", error);
        return new ResponseApi().InitInternalServer("Une erreur technique est survenue lors de la création.");
    }
};

const AddObject = async (body = {}, files = []) => {
    const { title, sku, id_category_type } = body;

    if (!title || !sku || !id_category_type) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        // 1. On transforme les fichiers reçus par Multer en structure "assets" pour le modèle
        const assets = files.map((file, index) => {
            return {
                // Le chemin d'accès HTTP pour le client (sans le mot "public" car il est statique)
                file_path: `/dataset/object/${file.filename}`,
                // On définit la première image comme image principale par défaut
                is_main_picture: index === 0, 
                order_view: index + 1
            };
        });

        const bodySanitized = {
            ...body,
            is_available: body.is_available === 'true' || body.is_available === true,
            is_active: body.is_active === 'true' || body.is_active === true,
        };

        // 2. On passe les données textuelles ET les chemins d'images générés au modèle
        const fullNewProduct = await CreateObjectWithAssets(bodySanitized, assets);
        
        return new ResponseApi().InitCreated("Objet et fichiers stockés avec succès.", fullNewProduct);
    } catch (error) {
        if (error.code === '23505') {
            return new ResponseApi().InitBadRequest("Le code SKU spécifié est déjà utilisé.");
        }

        console.error("Erreur contrôleur AddObject :", error);
        return new ResponseApi().InitInternalServer("Une erreur est survenue lors de la création.");
    }
};

/**
 * Gère la récupération globale de l'arborescence Catégories -> Objets
 */
const GetAllCategoriesWithProducts = async () => {
    try {
        const data = await GetCategoriesWithObjects();
        return new ResponseApi().InitOK(data);
    } catch (error) {
        console.error("Erreur contrôleur GetAllCategoriesWithProducts :", error);
        return new ResponseApi().InitInternalServer("Impossible de récupérer le catalogue pour le moment.");
    }
};

/**
 * Contrôleur pour récupérer la liste simplifiée (ID + Titre) des catégories
 */
const GetCategoriesList = async () => {
    try {
        const data = await GetCategoriesLightweight();
        return new ResponseApi().InitOK(data);
    } catch (error) {
        console.error("Erreur contrôleur GetCategoriesList :", error);
        return new ResponseApi().InitInternalServer("Impossible de récupérer la liste des catégories.");
    }
};

const GetObjectsList = async () => {
    try {
        const data = await GetObjectsLightweight();
        return new ResponseApi().InitOK(data);
    } catch (error) {
        console.error("Erreur contrôleur GetObjectsList :", error);
        return new ResponseApi().InitInternalServer("Impossible de récupérer la liste des objets.");
    }
};


const GetMyCategoriesAndProfiles = async (req, res) => {
    try {
        const data = await GetUserCategoriesWithProfiles(req.data.id_person);
        // On utilise res.send() pour envoyer le résultat
        res.status(200).send(new ResponseApi().InitOK(data));
    } catch (error) {
        console.error("Erreur GetMyCategoriesAndProfiles :", error);
        // On utilise res.status().send() ici aussi
        res.status(500).send(new ResponseApi().InitInternalServer("Erreur lors de la récupération de vos objets."));
    }
};

const GetMyFavoriteCategoriesAndProfiles = async (req, res) => {
    try {
        const data = await GetUserFavoriteCategoriesWithProfiles(req.data.id_person);
        res.status(200).send(new ResponseApi().InitOK(data));
    } catch (error) {
        // AJOUTE CETTE LIGNE :
        console.error("DÉTAIL ERREUR SQL :", error.message); 
        res.status(500).send(new ResponseApi().InitInternalServer("Erreur lors de la récupération des favoris."));
    }
};


const UpdateObjectStock = async (body) => {
    const { id_object, quantity_add } = body;

    // Validation
    if (!id_object || quantity_add === undefined) {
        return new ResponseApi().InitMissingParameters();
    }

    try {
        const updatedObject = await IncrementObjectStock(id_object, parseInt(quantity_add));
        
        if (updatedObject) {
            return new ResponseApi().InitOK("Stock mis à jour avec succès.", updatedObject);
        } else {
            return new ResponseApi().InitBadRequest("Objet introuvable.");
        }
    } catch (error) {
        console.error("Erreur contrôleur UpdateObjectStock :", error);
        return new ResponseApi().InitInternalServer("Une erreur est survenue lors de la mise à jour du stock.");
    }
};

export {AddCategoryType, AddObject, GetAllCategoriesWithProducts, GetCategoriesList, GetObjectsList, GetMyCategoriesAndProfiles, GetMyFavoriteCategoriesAndProfiles, UpdateObjectStock };