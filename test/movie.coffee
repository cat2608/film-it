"use strict"

Test = require("zenrequest").Test

module.exports = ->
  user  = ZENrequest.users[1]
  movie = ZENrequest.movies[0]
  tasks = []
  tasks.push _search user, movie, i for movie, i in ZENrequest.movies
  tasks.push _getDetails user, movie for movie in ZENrequest.movies
  tasks.push _favMovie user, movie for movie in ZENrequest.movies
  tasks.push _removeFav user, ZENrequest.movies[1]
  tasks

# -- Promises ------------------------------------------------------------------
_search = (user, movie, i) -> ->
  parameters = title : movie.title
  Test "GET", "api/movie/search", parameters, _setHeaderSession(user), "#{user.name} is looking for '#{movie.title}'", 200, (response) ->
    movie.imdbid = response.Search[i].imdbID
    movie.title = response.Search[i].Title

_getDetails = (user, movie) -> ->
  parameters = imdbid : movie.imdbid
  Test "GET", "api/movie/info", parameters, _setHeaderSession(user), "#{user.name} get details of '#{movie.title}'", 200, (response) ->
    movie.imdbid = response.movie.imdbid
    movie.id = response.movie.id

_favMovie = (user, movie) -> ->
  Test "POST", "api/movie/fav", movie, _setHeaderSession(user), "#{user.name} fav '#{movie.title}' to watch later", 200

_removeFav = (user, movie) -> ->
  Test "DELETE", "api/movie/fav", movie: movie.id, _setHeaderSession(user), "#{user.name} removes '#{movie.title}' from list", 200

# -- Private methods -----------------------------------------------------------
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
