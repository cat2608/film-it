"use strict"

__.proxy = (type, method, parameters = {}, background = false) ->
  promise = new Hope.Promise()
  unless background then do __.Dialog.Loading.show

  $$.ajax
    url         : "https://filmit.watch/api/#{method}"
    type        : type
    data        : parameters
    contentType : "application/x-www-form-urlencoded"
    dataType    : 'json'
    headers     : "Authorization": __.session or null
    success: (response, xhr) ->
      unless background then do __.Dialog.Loading.hide
      promise.done null, response
    error: (xhr, error) =>
      unless background then do __.Dialog.Loading.hide
      error = code: error.status, message: error.response
      console.error "__.proxy [ERROR #{error.code}]: #{error.message}"
      promise.done error, null
  promise
