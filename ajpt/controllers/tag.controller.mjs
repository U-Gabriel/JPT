import { GetAllTagRequest } from "../models/tag.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const GetAllTag = async () => {
    try {
        const data = await GetAllTagRequest();
        
        if (data && data.length > 0) {
            
            return new ResponseApi().InitOK(data);
        } else {
            return new ResponseApi().InitNoContent();
        }
    } catch (e) {
        return new ResponseApi().InitInternalServer(e);
    }
};

export { GetAllTag };