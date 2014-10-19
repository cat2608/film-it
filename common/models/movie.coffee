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


exports = module.exports = db.model "Movie", Movie
