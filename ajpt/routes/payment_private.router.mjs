import express from "express";
import { CreatePaymentIntent, GetAllOrders, GetOrdersByStatus, UpdateOrderStatus } from "../controllers/payment_private.controller.mjs";
import authToken from "../middlewares/auth.mjs";
import { checkRoles } from "../middlewares/auth_role.mjs";

const routerPaymentPrivate = express.Router();

// Route sécurisée : nécessite le token pour id_person
routerPaymentPrivate.post("/payment/create-intent", CreatePaymentIntent);

routerPaymentPrivate.get("/orders/list", authToken, checkRoles([2, 3, 4, 5]), async (req, res) => {
    const response = await GetAllOrders();
    res.status(response.code).send(response);
});

routerPaymentPrivate.post("/orders/list-by-status", authToken, checkRoles([2, 3, 4, 5]), async (req, res) => {
    const response = await GetOrdersByStatus(req.body);
    res.status(response.code).send(response);
});

routerPaymentPrivate.post("/orders/update_status", authToken, checkRoles([2, 3, 4, 5]), async (req, res) => {
    const response = await UpdateOrderStatus(req.body);
    res.status(response.code).send(response);
});

export { routerPaymentPrivate };