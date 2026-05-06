import express from "express";
import { CreateAddress, GetAddresses } from "../controllers/person_a.controller.mjs";

const routerPerson = express.Router();

routerPerson.post("/person/address", CreateAddress);
routerPerson.get("/person/address/list", GetAddresses);

export { routerPerson };