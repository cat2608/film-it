"use strict"
Hope = require("zenserver").Hope
User = require "./models/user"


module.exports = (request, response) ->
  promise = new Hope.Promise()
  auth = request.session
  if not auth
    response.unauthorized()
  else
    User.findOne _id: auth, (error, result) ->
      if result
        promise.done error, result
      else
        response.unauthorized()
  promise
