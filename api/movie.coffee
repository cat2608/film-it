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
      omdb.proxy "GET", null, s: request.parameters.s
    ]).then (error, result) ->
      _handleOmdbResponse response, error, result


  server.get "/api/movie/info", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, session) ->
      omdb.proxy "GET", null, i: request.parameters.i
    ]).then (error, result) ->
      _handleOmdbResponse response, error, result


  server.post "/api/movie/fav", (request, response) ->
    Hope.shield([ ->
      Session request, response
    , (error, @session) =>
      Movie.findOrRegister imdbid: request.parameters.imdbid
    , (error, movie) =>
      User.favorite @session._id, movie._id
    ]).then (error, result) ->
      if error
        response.json message: error.code, error.message
      else
        response.ok()

# -- Private Methods -----------------------------------------------------------
_handleOmdbResponse = (response, error, result) ->
  if error? or result.Response is "False"
    response.json message: "500", "Internal Server Error"
  else
    response.json result
