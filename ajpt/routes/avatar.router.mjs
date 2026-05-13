import express from "express";
import multer from "multer";
import path from "path";
import fs from "fs";
import { GetAvatarsWithoutPlant, UploadObjectProfilePicture } from "../controllers/avatar.controller.mjs";

const routerAvatar = express.Router();

// Route pour récupérer les avatars génériques (id_plant_type IS NULL)
routerAvatar.get("/avatar/get/list/state/null", GetAvatarsWithoutPlant);

// 1. Définir le chemin de manière plus flexible
// 'process.cwd()' récupère la racine de ton projet
const uploadDir = "/var/www/html/dataset/user/object_profile";

// 2. Créer le dossier s'il n'existe pas (évite l'erreur ENOENT)
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.memoryStorage();
const upload = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 } // On peut accepter plus gros car on va réduire
});

routerAvatar.post("/avatar/upload/object_profile", upload.single("picture"), UploadObjectProfilePicture);


export { routerAvatar };