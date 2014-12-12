"use strict"

Hope    = require("zenserver").Hope
Schema  = require("zenserver").Mongoose.Schema
db      = require("zenserver").Mongo.connections.primary
C       = require "../constants"


List = new Schema
  user      : type: Schema.ObjectId, ref: "User"
  movie     : type: Schema.ObjectId, ref: "Movie"
  state     : type: Number, default: C.STATE.ACTIVE
  updated_at: type: Date
  created_at: type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
List.statics.register = (parameters) ->
  promise = new Hope.Promise()
  @findOne parameters, (error, result) ->
    if error or result
      promise.done error, result
    else
      list = db.model "List", List
      new list(parameters).save (error, value) -> promise.done error, value
  promise

List.statics.search = (query, limit = 0, populate = "") ->
  promise = new Hope.Promise()
  @find(query).populate(populate).limit(limit).exec (error, value) ->
    if limit is 1 and not error
      error = code: 402, message: "List not found." if value.length is 0
      value = value[0] if value.length isnt 0
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
List.methods.parse = ->
  id        : @_id
  user      : @user
  movie     : if @movie?._id then @movie.parse() else @movie
  state     : @state
  updated_at: @updated_at
  created_at: @created_at

exports = module.exports = db.model "List", List
