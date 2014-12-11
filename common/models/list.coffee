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

exports = module.exports = db.model "List", List
