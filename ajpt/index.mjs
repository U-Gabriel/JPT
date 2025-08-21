import express from 'express'
import {config} from 'dotenv'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import cors from 'cors'
import authToken from './middlewares/auth.mjs'
import file from 'fs'
import swaggerUi from 'swagger-ui-express'
import {routerAuth} from './routes/auth.router.mjs'
import {routerObjectProfile} from './routes/object_profile.router.mjs'

const app = express()

config()
const port = process.env.PORT

// Body parser
app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json())
app.use(bodyParser.json({type: 'application/*+json'}))

// Console
app.use(morgan('dev'))

// CORS
app.use(cors());

// Swagger
const swagger = JSON.parse(file.readFileSync('./swagger/swagger_output.json', 'utf8'))
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swagger, {swaggerOptions: {persistAuthorization: true}}))


// Token JWT
app.use(authToken)

// Routers
app.use(routerAuth)
app.use(routerObjectProfile)

app.listen(port, () => {
    console.log(`Server listen on port ${port}`)
});