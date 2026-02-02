import swaggerAutogen from 'swagger-autogen'
import models from './models.mjs'

const doc = {
    info: {
        version: "1.0.0", title: "JPT", description: "Documentation for JackPote API."
    },
    host: "51.77.141.175",
    basePath: "/",
    schemes: ['https', 'http'],
    produces: ['application/json'],
    definitions: {
        ...models
    },
    securityDefinitions: {
        Bearer: {
            type: "apiKey",
            in: "header",
            name: "Authorization",
            description: "Rentrez un token valide dans le format **Bearer &lt;token>**",
        },
    }
}

const autogen = swaggerAutogen()
const outputFile = './swagger/swagger_output.json'
const endpointsFiles = [
    './routes/auth.router.mjs'
]

autogen(outputFile, endpointsFiles, doc)
