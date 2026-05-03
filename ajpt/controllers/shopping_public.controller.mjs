import { GetAllProductsRequest, GetProductDetailsRequest } from "../models/shopping_public.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const GetCatalog = async (body) => {
    try {
        const { id_tag, title_search } = body || {}; 

        const data = await GetAllProductsRequest(id_tag, title_search);
        
        if (data) {
            return new ResponseApi().InitOK(data);
        } else {
            return new ResponseApi().InitNoContent();
        }
        
    } catch (e) {
        console.error("Error in GetCatalog:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};


const GetProductDetails = async (body) => {
    try {
        const { id_object } = body || {};

        if (!id_object) {
            // Utilise ta classe ResponseApi pour rester cohérent
            return { status: "Bad Request", code: 400, message: "id_object est requis" };
        }

        const data = await GetProductDetailsRequest(id_object);
        
        if (data) {
            return new ResponseApi().InitOK(data);
        } else {
            return { status: "Not Found", code: 404, message: "Produit non trouvé" };
        }
    } catch (e) {
        return new ResponseApi().InitInternalServer(e);
    }
};

export { GetCatalog, GetProductDetails };