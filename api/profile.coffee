"use strict"
Hope    = require("zenserver").Hope
Session = require "../common/session"

module.exports = (server) ->

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
