import {CreateFaq, GetAllFaqsComplete, GetFaqsByTags, GetFaqsByObject, DeleteFaq } from "../controllers/faq.controller.mjs";
import authToken from "../middlewares/auth.mjs";
import { checkRoles } from "../middlewares/auth_role.mjs";
import express from "express";

const routerFaq = express.Router();

routerFaq.post("/faq/create", authToken, checkRoles([2, 3]), async (req, res) => {
    const response = await CreateFaq(req.body);
    res.status(response.code).send(response);
});

routerFaq.get("/faqs/all", authToken, checkRoles([2, 3]), async (req, res) => {
    const response = await GetAllFaqsComplete();
    res.status(response.code).send(response);
});

routerFaq.post("/faqs/tag", async (req, res) => {
    const response = await GetFaqsByTags(req.body);
    res.status(response.code).send(response);
});

routerFaq.post("/faqs/object", async (req, res) => {
    const response = await GetFaqsByObject(req.body);
    res.status(response.code).send(response);
});

routerFaq.post("/faq/delete", authToken, checkRoles([2, 3]), async (req, res) => {
    const response = await DeleteFaq(req.body);
    res.status(response.code).send(response);
});

export { routerFaq };