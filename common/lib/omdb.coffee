"use strict"

http = require "http"
Hope = require("zenserver").Hope
qs   = require "querystring"

omdb =
  protocol: "http"
  host    : "omdbapi.com"
  port    : 80

  resource: (method, url, parameters = {}, headers = {}) ->
    promise = new Hope.Promise()
    options =
      host    : @host
      port    : @port
      method  : method.toUpperCase()
      headers : headers
      agent   : false
    options.path = if url then "/#{url}" else "/"

    body = ""
    if parameters? and (options.method is "GET" or options.method is "DELETE")
      options.path += "?#{qs.stringify(parameters)}"
    else
      body = qs.stringify parameters
      options.headers["Content-Type"] = "application/x-www-form-urlencoded"
      options.headers["Content-Length"] = body.length

    client = http.request options, (response) =>
      body = ""
      response.setEncoding "utf8"
      response.on "data", (chunk) -> body += chunk
      response.on "end", ->
        body = JSON.parse body if body?
        if response.statusCode >= 400
          error = code: response.statusCode, message: body.message
          body = undefined
        promise.done error, body

    client.on "error", (error) ->
      error = code: error.statusCode, message: error.message
      promise.done error, undefined

    client.write body
    client.end()
    promise


module.exports = omdb

