import { GetCartItemCountRequest } from "../models/shopping_private.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const GetCartItemCount = async (req, res) => {
    try {
        // On ne regarde QUE req.user (rempli par le middleware)
        const id_person = req.data?.id_person;

        if (!id_person) {
            return res.status(401).send(
                new ResponseApi().InitUnauthorized("Utilisateur non identifié via le token")
            );
        }

        const count = await GetCartItemCountRequest(id_person);
        
        return res.status(200).send(
            new ResponseApi().InitOK({ total_items: count })
        );
        
    } catch (e) {
        return res.status(500).send(new ResponseApi().InitInternalServer(e));
    }
};


export { GetCartItemCount };