"use strict"

Hope    = require("zenserver").Hope
C       = require "../common/constants"
List    = require "../common/models/list"
Movie   = require "../common/models/movie"
omdb    = require "../common/lib/omdb"
Session = require "../common/session"
User    = require "../common/models/user"

module.exports = (server) ->

  server.get "/api/user/movies", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      filter = user: session
      filter.state = request.parameters.state if request.parameters.state
      List.search filter, null, populate = "movie"
    ]).then (error, list) ->
      if error
        response.json message: error.message, error.code
      else
        response.json movies: (item.movie.parse() for item in list)

  server.post "/api/user/movie", (request, response) ->
    if request.required ["imdb"]
      Hope.shield([ ->
        Session request, response
      , (error, @session) =>
        Movie.search imdbid: request.parameters.imdb, limit = 1
      , (error, movie) =>
        List.register user: @session, movie: movie._id, state: C.STATE.ACTIVE
      ]).then (error, result) ->
        if error
          response.json message: error.code, error.message
        else
          response.ok()

  server.put "/api/user/movie", (request, response) ->
    if request.required ["id", "state"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        filter =
          user  : session
          movie : request.parameters.id
        List.updateAttributes filter, state: request.parameters.state
      ]).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.ok()

  server.delete "/api/user/movie", (request, response) ->
    if request.required ["id"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        List.delete user: session, movie: request.parameters.id
      ]).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.ok()
