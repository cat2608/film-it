"use strict"

module.exports = (zen) ->

  zen.get "/", (request, response) ->
    bindings =
      page       : "landing"
      session    : undefined
      meta       : description: ""
    response.page "index", bindings
