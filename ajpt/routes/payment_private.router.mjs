import express from "express";
import { CreatePaymentIntent } from "../controllers/payment_private.controller.mjs";

const routerPaymentPrivate = express.Router();

// Route sécurisée : nécessite le token pour id_person
routerPaymentPrivate.post("/payment/create-intent", CreatePaymentIntent);

export { routerPaymentPrivate };