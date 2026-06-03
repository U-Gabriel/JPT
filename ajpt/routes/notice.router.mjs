import { CreateNotice, GetAllNotices, UpdateNoticeStatus } from "../controllers/notice.controller.mjs";
import { checkRoles } from "../middlewares/auth_role.mjs";
import express from "express";

const routerNotice = express.Router();

// Utilisation d'une route sémantique
routerNotice.post("/notice/create", async (req, res) => {
    const response = await CreateNotice(req.body);
    res.status(response.code).send(response);
});

// Route GET : accès restreint aux rôles 2, 3, 4, 7
routerNotice.get("/notice/all", checkRoles([2, 3, 4, 7]), async (req, res) => {
    const response = await GetAllNotices();
    res.status(response.code).send(response);
});

// Route POST : mise à jour du status
routerNotice.post("/notice/update_status", checkRoles([2, 3, 4, 7]), async (req, res) => {
    const response = await UpdateNoticeStatus(req.body);
    res.status(response.code).send(response);
});

export { routerNotice };