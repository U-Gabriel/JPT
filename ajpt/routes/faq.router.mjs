import { GetFaqsByTags, GetFaqsByObject } from "../controllers/faq.controller.mjs";
import express from "express";

const routerFaq = express.Router();

routerFaq.post("/faqs/tag", async (req, res) => {
    const response = await GetFaqsByTags(req.body);
    res.status(response.code).send(response);
});

routerFaq.post("/faqs/object", async (req, res) => {
    const response = await GetFaqsByObject(req.body);
    res.status(response.code).send(response);
});

export { routerFaq };