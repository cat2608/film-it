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
      Session(request, response).then (error, session) ->
        filter = imdbid: request.parameters.imdb
        Movie.search(filter, limit = 1).then (error, movie) ->
          if not movie
            Hope.shield([ ->
              omdb.resource "GET", null, i: request.parameters.imdb
            , (error, imdb) ->
              parameters = {}
              parameters[key.toLowerCase()] = value for key, value of imdb when value isnt "N/A"
              Movie.register parameters
            , (error, movie) ->
              List.register
                user  : session
                movie : movie._id
                state : request.parameters.state
            ]).then (error, result) ->
              if error
                response.json message: error.message, error.code
              else
                  response.ok()
          else
            List.register(
              user  : session
              movie : movie._id
              state : request.parameters.state
            ).then (error, result) ->
              if error
                response.json message: error.message, error.code
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
