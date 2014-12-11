"use strict"
Hope    = require("zenserver").Hope
omdb    = require "../common/lib/omdb"
Session = require "../common/session"
Movie   = require "../common/models/movie"
User    = require "../common/models/user"


module.exports = (server) ->

  server.get "/api/movie/search", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      omdb.resource "GET", null, s: request.parameters.s
    ]).then (error, result) ->
      if error
        response.json message: error.message, error.code
      else
        response.json result


  server.get "/api/movie/info", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      omdb.resource "GET", null, i: request.parameters.i
    , (error, movie) ->
      parameters = {}
      parameters[key.toLowerCase()] = value for key, value of movie
      Movie.searchOrRegister parameters
    ]).then (error, result) ->
      if error
        response.badRequest()
      else
        response.json movie: result.parse()


  server.post "/api/movie/fav", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, @session) =>
      Movie.searchOrRegister imdbid: request.parameters.imdbid
    , (error, movie) =>
      User.favorite @session._id, movie._id
    ]).then (error, result) ->
      if error
        response.json message: error.code, error.message
      else
        response.ok()


  server.get "/api/movies", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      filter = _id: $in: session.movies
      Movie.search filter
    , (error, movies) ->
      promise = new Hope.Promise()
      values = []
      movies.forEach (movie) ->
        omdb.resource("GET", null, i: movie.imdbid).then (error, imdb) ->
          values.push imdb
          if values.length is movies.length then promise.done error, values
      promise
    ]).then (error, result) ->
      if error
        response.json message: error.message, error.code
      else
        response.json result
