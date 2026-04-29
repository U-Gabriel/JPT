import { CreateNotice } from "../controllers/notice.controller.mjs";
import express from "express";

const routerNotice = express.Router();

// Utilisation d'une route sémantique
routerNotice.post("/notice/create", async (req, res) => {
    const response = await CreateNotice(req.body);
    res.status(response.code).send(response);
});

export { routerNotice };