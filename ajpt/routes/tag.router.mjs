import { GetAllTag } from "../controllers/tag.controller.mjs";
import express from "express";

const routerTag = express.Router();

routerTag.get("/tags", async (req, res) => {
    const response = await GetAllTag();
    res.status(response.code).send(response);
});

export { routerTag };