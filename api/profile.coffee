"use strict"
Hope    = require("zenserver").Hope
Session = require "../common/session"
User    = require "../common/models/user"


module.exports = (server) ->

  server.get "/api/user", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      id = request.parameters.id or session._id
      User.search _id: id, limit = 1
    ]).then (error, result) ->
      if error
        response.badRequest()
      else
        response.json result

  server.put "/api/user", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      parameters = {}
      for key in ["username", "avatar"] when request.parameters[key]?
        parameters[key] = request.parameters[key]
      session.updateAttributes parameters
    ]).then (error, result) ->
      if error
        response.badRequest()
      else
        response.ok()
