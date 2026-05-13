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
        const id_person = req.data?.id_person; // Récupéré du token
        const id_object_profile = req.body.id_object_profile;
        const file = req.file;

        if (!id_person) return res.status(401).send(new ResponseApi().InitUnauthorized());
        if (!req.file) return res.status(400).send(new ResponseApi().InitBadRequest("Fichier manquant"));

        // Chemin relatif pour la base de données (ce qui sera lu par l'URL HTTP)
        const publicPath = `dataset/user/object_profile/${file.filename}`;

        // Mise à jour en base de données
        await UpdatePicturePathModel(id_object_profile, id_person, publicPath);

        return res.status(200).send(new ResponseApi().InitOK({
            message: "Image téléchargée avec succès",
            path: publicPath
        }));

    } catch (e) {
        if (e.message === "NOT_FOUND") {
            return res.status(404).send(new ResponseApi().InitNotFound("Profil non trouvé"));
        }
        console.error(e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e.message));
    }
};

export { GetAvatarsWithoutPlant, UploadObjectProfilePicture };