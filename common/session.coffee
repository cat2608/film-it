"use strict"
Hope = require("zenserver").Hope
User = require "./models/user"


module.exports = (request, response, redirect = false) ->
  promise = new Hope.Promise()
  auth = request.session
  if not auth
    if redirect then promise.done true else response.unauthorized()
  else
    User.search(_id: auth, limit = 1).then (error, result) ->
      if result
        promise.done error, result
      else
        if redirect then promise.done true else response.unauthorized()
  promise
