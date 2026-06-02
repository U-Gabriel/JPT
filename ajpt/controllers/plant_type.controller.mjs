import {CreatePlantWithDetails, GetAllPlants, GetRequestPlantTypeSearchByTitle, GetRequestPlantTypeDescription} from "../models/plant_type.mjs";
import {ResponseApi} from "../models/response-api.mjs";



const AddPlant = async (req, res) => {
    try {
        // 1. Validation : vérifier si les données sont bien présentes
        if (!req.body.plantData || !req.body.groupData) {
            return res.status(400).json({ status: "KO", message: "Données manquantes (plantData ou groupData)" });
        }

        const plantData = JSON.parse(req.body.plantData);
        const groupData = JSON.parse(req.body.groupData);
        
        // 2. Sécurité : vérifier si des fichiers ont bien été envoyés
        if (!req.files || req.files.length === 0) {
            return res.status(400).json({ status: "KO", message: "Au moins une image est requise" });
        }

        // 3. Construction des avatars
        const avatars = req.files.map((file, index) => ({
            title: `Avatar ${index + 1}`,
            description: "Image de plante",
            picture_path: `/dataset/data_plant/${file.filename}`
        }));

        // 4. Appel du modèle
        await CreatePlantWithDetails(plantData, groupData, avatars);
        
        res.status(201).json({ status: "OK", message: "Plante créée avec succès" });

    } catch (e) {
        // 5. Distinction entre erreur de parsing JSON et erreur serveur
        if (e instanceof SyntaxError) {
            return res.status(400).json({ status: "KO", message: "Format JSON invalide" });
        }
        
        console.error("Erreur création plante:", e);
        res.status(500).json({ status: "KO", message: "Erreur lors de la création en base de données" });
    }
};

const GetAllPlantsController = async (req, res) => {
    try {
        const plants = await GetAllPlants();
        res.status(200).json({ status: "OK", data: plants });
    } catch (e) {
        console.error("Erreur récupération plantes:", e);
        res.status(500).json({ status: "KO", message: "Erreur serveur" });
    }
};

/**
 * Display a liste plant type search by title
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetPlantTypeSearchByTitle = (pt) => {
    return new Promise((resolve) => {
        if (!pt) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            GetRequestPlantTypeSearchByTitle(pt)
                .then((data) => {
                    resolve(new ResponseApi().InitOK(data));
                    
                })
                .catch((e) => {
                    if (e.code === '23503') {
                        resolve(new ResponseApi().InitBadRequest(e.message));
                        return;
                    }
                    console.error(e);
                    resolve(new ResponseApi().InitInternalServer(e.message));
                });
        }
    });
};

/**
 * Display a plant type description by id
 * @returns {Promise<unknown>}
 * @constructor
 */
const GetPlantTypeDescription = (id) => {
    return new Promise((resolve) => {
        if (!id) {
            resolve(new ResponseApi().InitMissingParameters());
        } else {
            GetRequestPlantTypeDescription(id)
                .then((data) => {
                    resolve(new ResponseApi().InitOK(data));
                    
                })
                .catch((e) => {
                    if (e.code === '23503') {
                        resolve(new ResponseApi().InitBadRequest(e.message));
                        return;
                    }
                    console.error(e);
                    resolve(new ResponseApi().InitInternalServer(e.message));
                });
        }
    });
};

export {GetPlantTypeSearchByTitle, GetPlantTypeDescription, AddPlant, GetAllPlantsController}