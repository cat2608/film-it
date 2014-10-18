"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _search ZENrequest.users[1], ZENrequest.movies[0]
  tasks.push _getDetails ZENrequest.users[1], ZENrequest.movies[0]
  tasks.push _favMovie ZENrequest.users[1], ZENrequest.movies[0]
  tasks


# Promises
_search = (user, movie) -> ->
  parameters = s : movie.s
  Test "GET", "api/movie/search", parameters, _setHeaderSession(user), "#{user.name} is looking for '#{movie.s}'", 200, (response) ->
    movie.imdbid = response.Search[0].imdbID

_getDetails = (user, movie) -> ->
  parameters = i : movie.imdbid
  Test "GET", "api/movie/info", parameters, _setHeaderSession(user), "#{user.name} get details of '#{movie.s}'", 200, (response) ->
    movie.imdb = response.imdbID

_favMovie = (user, movie) -> ->
  Test "POST", "api/movie/fav", movie, _setHeaderSession(user), "#{user.name} fav '#{movie.s}' to watch later", 200


# Private methods
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
