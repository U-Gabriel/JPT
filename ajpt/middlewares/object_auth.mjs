const objectAuth = (req, res, next) => {
    const { object_key } = req.body

    if (!object_key) {
        return res.status(401).send({ message: "Missing object_key" })
    }

    if (object_key !== process.env.OBJECT_API_KEY) {
        return res.status(403).send({ message: "Invalid object_key" })
    }
    
    delete req.body.object_key

    next()
}

export default objectAuth
