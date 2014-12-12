"use strict"
Hope    = require("zenserver").Hope
List    = require "../common/models/list"
Session = require "../common/session"


module.exports = (server) ->

  server.get "/api/list", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      filter = user: session
      filter.state = request.parameters.state if request.parameters.state
      List.search filter, null, populate = "movie"
    ]).then (error, result) ->
      if error
        response.json message: error.message, error.code
      else
        response.json list: (movie.parse() for movie in result)
