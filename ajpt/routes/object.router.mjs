import express from 'express'
import objectAuth from '../middlewares/object_auth.mjs'
import { UpdateObjectProfileObjController } from '../controllers/object.controller.mjs'

const routerObject = express.Router()

routerObject.patch('/object/4f5d6g4s65g4/object_profile/update/byobjectprofile', objectAuth, async (req, res) => {
        const response = await UpdateObjectProfileObjController(req.body)
        res.status(response.code).send(response)
    }
)

export { routerObject }
