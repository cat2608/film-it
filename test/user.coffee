"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _favMovie ZENrequest.users[1], movie for movie in ZENrequest.movies
  tasks.push _userMovies ZENrequest.users[1]
  tasks.push _userMovies ZENrequest.users[1], state = "ACTIVE"
  tasks.push _userMovies ZENrequest.users[1], state = "COMPLETED"
  tasks.push _removeFav ZENrequest.users[1], ZENrequest.movies[1]
  tasks

# -- Promises ------------------------------------------------------------------
_favMovie = (user, movie) -> ->
  Test "POST", "api/user/movie", movie, _setHeaderSession(user), "#{user.name} fav '#{movie.title}' to watch later", 200

_userMovies = (user, state = null) -> ->
  states = ["ACTIVE", "COMPLETED"]
  parameters = {}
  parameters.state = value for key, value in states when state? and key is state
  message = if state? then "gets movies #{state}" else "gets list of movies"
  Test "GET", "api/user/movies", parameters, _setHeaderSession(user), "#{user.name} " + message, 200

_removeFav = (user, movie) -> ->
  Test "DELETE", "api/user/movie", id: movie.id, _setHeaderSession(user), "#{user.name} removes '#{movie.title}' from list", 200

# -- Private methods -----------------------------------------------------------
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
