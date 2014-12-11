"use strict"
Hope    = require("zenserver").Hope
omdb    = require "../common/lib/omdb"
# User    = require "../common/models/user"
# Movie   = require "../common/models/movie"
# Session = require "../common/session"


module.exports = (zen) ->

  zen.post "/login", (request, response) ->
    User.login(request.parameters).then (error, user) ->
      if user
        response.session user._id
        response.redirect "movies"
      else
        response.page "index"

  zen.post "/signup", (request, response) ->
    if request.required ['mail', 'password']
      User.login(request.parameters).then (error, result) ->
        if error
          response.json message: error.message, error.code
        else
          response.json result.parse()

  zen.get "/movies", (request, response) ->
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


  zen.get "/logout", (request, response) ->
    response.logout()
    response.redirect "/"


  zen.get "/", (request, response) ->
    bindings =
      page       : "landing"
      session    : undefined
      meta       : description: ""
    response.page "index", bindings, ["partial.landing"]






