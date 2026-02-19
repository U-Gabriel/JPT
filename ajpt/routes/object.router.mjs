import express from 'express'
import objectAuth from '../middlewares/object_auth.mjs'
import { UpdateObjectProfileObjController, UpdateIsAutomaticObjectProfileObjController} from '../controllers/object.controller.mjs'

const routerObject = express.Router()

routerObject.patch('/object/4f5d6g4s65g4/object_profile/update/byobjectprofile', objectAuth, async (req, res) => {
        const response = await UpdateObjectProfileObjController(req.body)
        res.status(response.code).send(response)
    }
)

routerObject.patch('/object/4f5d6g4s65g4/object_profile/update/byobjectprofile/is_automatic', objectAuth, async (req, res) => {
        const response = await UpdateIsAutomaticObjectProfileObjController(req.body)
        res.status(response.code).send(response)
    }
)

export { routerObject }
