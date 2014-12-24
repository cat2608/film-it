"use strict"

Test = require("zenrequest").Test

module.exports = ->
  user = ZENrequest.users[1]
  tasks = []
  tasks.push _search user, movie, i for movie, i in ZENrequest.movies
  tasks.push _getDetails user, movie for movie in ZENrequest.movies
  tasks

# -- Promises ------------------------------------------------------------------
_search = (user, movie, i) -> ->
  parameters = title : movie.title
  Test "GET", "api/movie/search", parameters, _setHeaderSession(user), "#{user.name} is looking for '#{movie.title}'", 200, (response) ->
    movie.imdb = response.movies[i].imdb
    movie.title = response.movies[i].title

_getDetails = (user, movie) -> ->
  parameters = imdb : movie.imdb
  Test "GET", "api/movie/info", parameters, _setHeaderSession(user), "#{user.name} get details of '#{movie.title}'", 200, (response) ->
    movie.imdb = response.movie.imdb
    movie.id = response.movie.id

# -- Private methods -----------------------------------------------------------
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
