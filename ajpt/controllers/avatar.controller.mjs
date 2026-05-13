import { GetRequestAvatarsWithoutPlant } from "../models/avatar.mjs";
import {ResponseApi} from "../models/response-api.mjs";

export const GetAvatarsWithoutPlant = async (req, res) => {
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