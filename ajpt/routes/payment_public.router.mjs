import express from "express";
import { StripeWebhook } from "../controllers/payment_public.controller.mjs";

const routerPaymentPublic = express.Router();

routerPaymentPublic.post("/payment/webhook", express.raw({type: 'application/json'}), StripeWebhook);

export { routerPaymentPublic };