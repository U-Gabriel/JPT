import express from "express";
import { CreatePaymentIntent, StripeWebhook } from "../controllers/payment.controller.mjs";

const routerPayment = express.Router();

// Route sécurisée : nécessite le token pour id_person
routerPayment.post("/payment/create-intent", CreatePaymentIntent);

routerPayment.post("/payment/webhook", express.raw({type: 'application/json'}), StripeWebhook);

export { routerPayment };