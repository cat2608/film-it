"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _updateProfile ZENrequest.users[1]
  tasks


# -- Promises ------------------------------------------------------------------
_updateProfile = (user) -> ->
  parameters =
    username  : "teleject"
    avatar    : "https://s3.amazonaws.com/uifaces/faces/twitter/teleject/128.jpg"
  Test "PUT", "api/user", parameters, _setHeaderSession(user), "#{parameters.username} modified profile data", 200


# -- Private methods -----------------------------------------------------------
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
