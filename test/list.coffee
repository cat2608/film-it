"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _list ZENrequest.users[1]
  tasks.push _list ZENrequest.users[1], state = "ACTIVE"
  tasks.push _list ZENrequest.users[1], state = "COMPLETED"
  tasks

# -- Promises ------------------------------------------------------------------
_list = (user, state = null) -> ->
  states = ["ACTIVE", "COMPLETED"]
  parameters = {}
  parameters.state = value for key, value in states when state? and key is state
  message = if state? then "gets movies #{state}" else "gets list of movies"

  Test "GET", "api/list", parameters, _setHeaderSession(user), "#{user.name} " + message, 200

# -- Private methods -----------------------------------------------------------
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
