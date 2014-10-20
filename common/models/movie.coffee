"use strict"

Hope    = require("zenserver").Hope
Schema  = require("zenserver").Mongoose.Schema
db      = require("zenserver").Mongo.connections.primary


Movie = new Schema
  imdbid    : type: String
  created_at: type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Movie.statics.findOrRegister = (parameters) ->
  promise = new Hope.Promise()
  @findOne imdbid: parameters.imdbid, (error, result) ->
    if result or error
      promise.done error, result
    else
      movie = db.model "Movie", Movie
      new movie(parameters).save (error, value) -> promise.done error, value
  promise

Movie.statics.search = (query, limit = 0) ->
  promise = new Hope.Promise()
  @find(query).limit(limit).exec (error, result) ->
    if limit is 1 and not error
      error = code: 402, message: "Movie not found." if result.length is 0
      value = result[0] if result.length isnt 0
    promise.done error, result
  promise

exports = module.exports = db.model "Movie", Movie
