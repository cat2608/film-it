"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _signup(user) for user in ZENrequest.users
  tasks.push _login(user) for user in ZENrequest.users
  tasks.push _incorrectCredentials ZENrequest.users[1]
  tasks


# Promises
_signup = (user) -> ->
  Test "POST", "api/signup", user, null, "Signup #{user.name}", 400

_login = (user) -> ->
  Test "POST", "api/login", user, null, "Login #{user.name}", 200, (response) ->
    user.id = response.id

_incorrectCredentials = (user) -> ->
  data =
    mail    : ZENrequest.users[1].mail
    password: "Wow"
  Test "POST", "api/login", data, null, "#{user.name} entered wrong password when logging", 403
