import { GetCartItemCountRequest, AddToCartRequest, GetCartItemsRequest } from "../models/shopping_private.mjs";
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

const AddToCart = async (req, res) => {
    try {
        const id_person = req.data?.id_person;
        const { id_object, object_quantity } = req.body;

        // Validation des entrées
        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("Non autorisé"));
        }
        if (!id_object || !object_quantity || object_quantity <= 0) {
            return res.status(400).send(new ResponseApi().InitBadRequest("id_object et object_quantity (positif) sont requis"));
        }

        // Appel au modèle
        const result = await AddToCartRequest(id_person, id_object, object_quantity);

        return res.status(200).send(
            new ResponseApi().InitOK({
                message: "Article ajouté au panier",
                item: result
            })
        );

    } catch (e) {
        console.error("Error in AddToCart:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e));
    }
};

const GetCartItems = async (req, res) => {
    try {
        const id_person = req.data?.id_person;

        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized("Non autorisé"));
        }

        const items = await GetCartItemsRequest(id_person);

        return res.status(200).send(
            new ResponseApi().InitOK(items)
        );
    } catch (e) {
        console.error("Error in GetCartItems:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e));
    }
};

export { GetCartItemCount, AddToCart, GetCartItems };