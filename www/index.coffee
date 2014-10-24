"use strict"
Hope    = require("zenserver").Hope
omdb    = require "../common/lib/omdb"
User    = require "../common/models/user"
Movie   = require "../common/models/movie"
Session = require "../common/session"


module.exports = (server) ->

  server.post "/login", (request, response) ->
    User.login(request.parameters).then (error, user) ->
      if user
        response.session user._id
        response.redirect "movies"
      else
        response.page "index"

  server.post "/signup", (request, response) ->
    if request.required ['mail', 'password']
      User.login(request.parameters).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.json result.parse()

  server.get "/movies", (request, response) ->
    Session(request, response, redirect = true).then (error, session) ->
      unless session
        response.page "index"
      else
        Hope.shield([ ->
          Movie.search _id: $in: session.movies
        , (error, movies) ->
          promise = new Hope.Promise()
          values = []
          movies.forEach (movie) ->
            omdb.resource("GET", null, i: movie.imdbid).then (error, imdb) ->
              values.push imdb
              if values.length is movies.length then promise.done error, values
          promise
        ]).then (error, result) ->
          if result
            bindings =
              page    : "movies"
              movies  : result
              session : session.parse()
            response.page "movies", bindings


  server.get "/logout", (request, response) ->
    response.logout()
    response.redirect "/"


  server.get "/", (request, response) ->
    Session(request, response, redirect = true).then (error, session) ->
      if session
        response.redirect "movies"
      else
        response.page "index"








