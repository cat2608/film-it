"use strict"

Hope    = require("zenserver").Hope
Schema  = require("zenserver").Mongoose.Schema
db      = require("zenserver").Mongo.connections.primary


Movie = new Schema
  imdbid      : type: String
  title       : type: String
  year        : type: Number
  rated       : type: String
  released    : type: String
  runtime     : type: String
  genre       : type: String
  director    : type: String
  writer      : type: String
  actors      : type: String
  plot        : type: String
  language    : type: String
  country     : type: String
  wards       : type: String
  poster      : type: String
  metascore   : type: String
  imdbrating  : type: Number
  imdbvotes   : type: String
  type        : type: String
  response    : type: String
  created_at  : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Movie.statics.searchOrRegister = (parameters) ->
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

# -- Instance methods ----------------------------------------------------------
Movie.methods.parse = ->
  id          : @_id
  imdbid      : @imdbid
  title       : @title
  year        : @year
  rated       : @rated
  released    : @released
  runtime     : @runtime
  genre       : @genre
  director    : @director
  writer      : @writer
  actors      : @actors
  plot        : @plot
  language    : @language
  country     : @country
  wards       : @wards
  poster      : @poster
  metascore   : @metascore
  imdbrating  : @imdbrating
  imdbvotes   : @imdbvotes
  type        : @type
  response    : @response
  created_at  : @created_at

exports = module.exports = db.model "Movie", Movie
