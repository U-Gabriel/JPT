class ResponseApi {
    status = "OK"
    message = null
    code
    data = null
}

ResponseApi.prototype.InitError = function(code, ex) {
    this.status = "KO"
    this.message = ex.message
    this.data = ex
    this.code = code
    return this
}

ResponseApi.prototype.InitBadRequest = function(message) {
    this.status = "KO"
    this.message = message
    this.code = 400
    return this
}

ResponseApi.prototype.InitMissingParameters = function() {
    this.status = "KO"
    this.message = "Missing parameters"
    this.code = 400
    return this
}

ResponseApi.prototype.InitInternalServer = function(ex) {
    this.status = "KO"
    this.message = ex.message
    this.data = ex
    this.code = 500
    return this
}

ResponseApi.prototype.InitCreated = function(message) {
    this.status = "OK"
    this.message = message
    this.code = 201
    return this
}

ResponseApi.prototype.InitNoContent = function() {
    this.status = "OK"
    this.message = "No data"
    this.code = 204
    return this
}

ResponseApi.prototype.InitOK = function(data) {
    this.status = "OK"
    this.data = data
    this.code = 200
    return this
}

ResponseApi.prototype.InitData = function(data) {
    this.status = "OK"
    this.data = data
    this.code = (data) ? 200 : 204
    return this
}

ResponseApi.prototype.InitUnauthorized = function(message) {
    this.status = "KO"
    this.message = message
    this.code = 401
    return this
}

export {ResponseApi}