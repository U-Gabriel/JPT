import { CreateAddressRequest, GetAddressesRequest } from "../models/person_a.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const CreateAddress = async (req, res) => {
    try {
        const id_person = req.data?.id_person;
        const { address_line1, postal_code, city } = req.body;

        // Validation sécurité et intégrité
        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized());
        }

        if (!address_line1 || !postal_code || !city) {
            return res.status(400).send(
                new ResponseApi().InitBadRequest("Les champs ligne 1, code postal et ville sont obligatoires")
            );
        }

        const newAddress = await CreateAddressRequest(id_person, req.body);

        return res.status(201).send(
            new ResponseApi().InitOK(newAddress)
        );

    } catch (e) {
        console.error("Error CreateAddress:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e));
    }
};

const GetAddresses = async (req, res) => {
    try {
        const id_person = req.data?.id_person;

        if (!id_person) {
            return res.status(401).send(new ResponseApi().InitUnauthorized());
        }

        const addresses = await GetAddressesRequest(id_person);

        return res.status(200).send(
            new ResponseApi().InitOK(addresses)
        );

    } catch (e) {
        console.error("Error GetAddresses:", e);
        return res.status(500).send(new ResponseApi().InitInternalServer(e));
    }
};

export { CreateAddress, GetAddresses };