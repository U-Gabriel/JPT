import sharp from "sharp";
import path from "path";
import fs from "fs";
import { GetRequestAvatarsWithoutPlant, UpdatePicturePathModel } from "../models/avatar.mjs";
import {ResponseApi} from "../models/response-api.mjs";

const GetAvatarsWithoutPlant = async (req, res) => {
    try {

        const avatars = await GetRequestAvatarsWithoutPlant();

        return res.status(200).send(
            new ResponseApi().InitOK(avatars)
        );
    } catch (e) {
        console.error("Error in GetAvatarsWithoutPlant:", e);
        return res.status(500).send(
            new ResponseApi().InitInternalServer(e.message)
        );
    }
};

const UploadObjectProfilePicture = async (req, res) => {
    try {
        const id_person = req.data?.id_person;
        const id_object_profile = req.body.id_object_profile;
        const file = req.file;

        if (!file) return res.status(400).send({ message: "Fichier manquant" });

        // 1. Définir le nom et le chemin
        const fileName = `${id_object_profile}.webp`; // On force le format .webp (plus léger)
        const uploadDir = "/var/www/html/dataset/user/object_profile";
        const fullPath = path.join(uploadDir, fileName);

        // 2. Traitement avec SHARP
        await sharp(file.buffer)
            .resize(800, 800, { // Redimensionne en max 800x800
                fit: 'inside', 
                withoutEnlargement: true // N'agrandit pas si l'image est petite
            })
            .webp({ quality: 80 }) // Convertit en WebP qualité 80% (top pour le web)
            .toFile(fullPath);

        // 3. Mise à jour DB avec le nouveau chemin
        const publicPath = `dataset/user/object_profile/${fileName}`;
        await UpdatePicturePathModel(id_object_profile, id_person, publicPath);

        return res.status(200).send({
            status: "OK",
            path: publicPath
        });

    } catch (e) {
        console.error(e);
        return res.status(500).send({ message: e.message });
    }
};

export { GetAvatarsWithoutPlant, UploadObjectProfilePicture };