"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _signup user for user in ZENrequest.users[0..2]
  tasks.push _signup ZENrequest.users[3], new_user = true
  tasks.push _login user for user in ZENrequest.users
  tasks.push _incorrectCredentials ZENrequest.users[1]
  tasks


# -- Promises ------------------------------------------------------------------
_signup = (user, new_user = null) -> ->
  code = if new_user is true then 200 else 400
  Test "POST", "api/signup", user, null, "Signup #{user.name} with mail #{user.mail}", code

_login = (user) -> ->
  Test "POST", "api/login", user, null, "Login #{user.name} with mail #{user.mail}", 200, (response) ->
    user.id = response.id

_incorrectCredentials = (user) -> ->
  data =
    mail    : ZENrequest.users[1].mail
    password: "Wow"
  Test "POST", "api/login", data, null, "#{user.name} entered wrong password when login", 403
