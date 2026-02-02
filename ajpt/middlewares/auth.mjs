import jwt from 'jsonwebtoken'

const WHITE_ROUTES = [
    '/register',
    '/login_app'
]

const authToken = (req, res, next) => {
    // Vérifie si la route est sans token ou pas

    let urlDecompose = req.url.split('/')
    const url =  (urlDecompose <= 1) ? "/" : `/${urlDecompose[1]}`
    if (WHITE_ROUTES.some((r) => r === url)) {
        next()
        return
    }

    // Vérifie la présence du header "Authorization"
    const authHeader = req.headers['authorization']
    if (!authHeader) return res.sendStatus(401)

    // Vérifie la présence du token
    const token = authHeader.split(' ')[1]
    if (token == null) return res.sendStatus(402)

    // Test la validité du token
    jwt.verify(token, process.env.TOKEN, (err, data) => {
        // Le token est mauvais
        if (err) {
            return res.sendStatus(403)
        }

        // utilisateur reconnu
        req.data = data
        next()
    })
}

export default authToken