"use strict"

Test = require("zenrequest").Test

module.exports = ->
  session = ZENrequest.users[1]
  tasks = []
  tasks.push _updateProfile session
  tasks.push _getProfile session
  tasks.push _getProfile session, ZENrequest.users[0]
  tasks.push _deleteAccount ZENrequest.users[3]
  tasks


# -- Promises ------------------------------------------------------------------
_updateProfile = (user) -> ->
  parameters =
    username  : "teleject"
    avatar    : "https://s3.amazonaws.com/uifaces/faces/twitter/teleject/128.jpg"
  Test "PUT", "api/user", parameters, _setHeaderSession(user), "#{parameters.username} modified profile data", 200

_getProfile = (user, friend = null) -> ->
  parameters = {}
  parameters.id = friend.id if friend?
  message = if friend then "#{user.name} gets details of #{friend.name}" else "#{user.name} checks profile data"
  Test "GET", "api/user", parameters, _setHeaderSession(user), message, 200

_deleteAccount = (user) -> ->
  Test "DELETE", "api/user", null, _setHeaderSession(user), "#{user.name} removes account", 200


# -- Private methods -----------------------------------------------------------
_setHeaderSession = (user) ->
  data =
    "user-agent"    : "Mozilla/9.0 (Macintosh; Intel Mac OS X 10_8_5)"
    "authorization" : user.id
