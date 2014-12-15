"use strict"

class Atoms.Organism.Session extends Atoms.Organism.Article

  @scaffold "assets/scaffold/session.json"

  render: ->
    super
    do @onShowLogin

  # -- Children Bubble Events --------------------------------------------------
  onFormChange: (event, form) ->
    value = form.value()
    button = @credentials.form.button_signup
    if value.password isnt "" and value.password is value.repassword
      button.el.removeAttr "disabled"
    else
      button.el.attr "disabled", true
    form.error.el.hide()

  onShowSignup: (event) ->
    @el.find(".login-context").hide()
    @el.find(".signup-context").show()
    @credentials.form.error.el.hide()

  onShowLogin: (event) ->
    @el.find(".signup-context").hide()
    @el.find(".login-context").show()
    return true
    @credentials.form.error.el.hide()

  onLogin: (event, button) ->
    button.el.addClass("loading")
    @_session "login", @credentials.form.value()

  onSignup: (event, button) ->
    button.el.addClass("loading")
    @_session "signup", @credentials.form.value()

  onClose: ->
    do @hide
    false

  # -- Private -----------------------------------------------------------------
  _session: (method, parameters) ->
    do @_disableForm
    __.proxy("POST", method, parameters).then (error, response) =>
      do @_enableForm
      if response
        __.session = response.id
        document.cookie = "filmit=#{__.session};path=/"
        Atoms.Url.path "main/films"
      else
        @credentials.form.error.el.html(error.message).show()

  _disableForm: ->
    @credentials.form.el.children().attr "disabled", true

  _enableForm: ->
    @credentials.form.el.children().removeAttr("disabled").removeClass "loading"
