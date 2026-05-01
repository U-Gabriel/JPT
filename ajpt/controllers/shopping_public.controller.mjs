import { GetAllProductsRequest } from "../models/shopping_public.mjs";
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

export { GetCatalog };