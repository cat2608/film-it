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
          omdb.resource("GET", null, t: request.parameters.title).then (error, omdb) ->
            return response.json message: error.message, error.code if error
            movies = []
            movies.push
              title   : omdb.Title
              type    : omdb.Type
              year    : omdb.Year
              imdb    : omdb.imdbID
            response.json movies: movies
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
      Session(request, response).then (error, session) ->
        filter = imdbid: request.parameters.imdb
        Movie.search(filter, limit = 1).then (error, movie) ->
          if not movie
            query = i: request.parameters.imdb, plot: "full"
            omdb.resource("GET", null, query).then (error, imdb) ->
              return response.json message: error.message, error.code if error?
              parameters = {}
              parameters[key.toLowerCase()] = value for key, value of imdb when value isnt "N/A"

              Movie.register(parameters).then (error, result) ->
                return response.json message: error.message, error.code if error
                response.json movie: result.parse()
          else
            response.json movie: movie.parse()
