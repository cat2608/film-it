"use strict"

Hope    = require("zenserver").Hope
C       = require "../common/constants"
List    = require "../common/models/list"
Movie   = require "../common/models/movie"
omdb    = require "../common/lib/omdb"
Session = require "../common/session"
User    = require "../common/models/user"

module.exports = (server) ->

  server.get "/api/movie/search", (request, response) ->
    if request.required ["title"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        omdb.resource "GET", null, s: request.parameters.title
      ]).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          movies = []
          for movie in result.Search
            movies.push
              title   : movie.Title
              type    : movie.Type
              year    : movie.Year
              imdb    : movie.imdbID
          response.json movies: movies

  server.get "/api/movie/info", (request, response) ->
    if request.required ["imdb"]
      Hope.shield([ ->
        Session request, response
      , (error, session) ->
        omdb.resource "GET", null, i: request.parameters.imdb
      , (error, movie) ->
        parameters = {}
        parameters[key.toLowerCase()] = value for key, value of movie
        Movie.searchOrRegister parameters
      ]).then (error, movie) ->
        if error
          response.badRequest()
        else
          response.json movie: movie.parse()
