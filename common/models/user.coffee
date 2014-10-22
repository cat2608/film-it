"use strict"

Hope    = require("zenserver").Hope
Schema  = require("zenserver").Mongoose.Schema
db      = require("zenserver").Mongo.connections.primary
crypto  = require "crypto"


User = new Schema
  movies    : [type: Schema.ObjectId, ref: "Movie"]
  username  : type: String
  mail      : type: String, unique: true, required: true
  avatar    : type: String, default: "http://appnima.com/img/avatar.jpg"
  password  : type: String
  created_at: type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
User.statics.signup = (attributes) ->
  promise = new Hope.Promise()
  @findOne mail: attributes.mail, (error, user) ->
    if user
      error = code: 400, message: "Mail already registered."
      promise.done error, null
    else
      attributes.password = crypto.createHash("sha256")
        .update(attributes.password)
        .digest('base64')
      user = db.model "User", User
      new user(attributes).save (error, result) ->
        promise.done error, result
  promise

User.statics.login = (attributes) ->
  promise = new Hope.Promise()
  @findOne mail: attributes.mail, (error, user) ->
    hash = crypto.createHash("sha256")
          .update(attributes.password).digest("base64")
    if user and user.password is hash
      promise.done null, user
    else
      error = code: 403, message: "Incorrect credentials."
      promise.done error, null
  promise

User.statics.favorite = (user_id, movie_id) ->
  promise = new Hope.Promise()
  movie = $addToSet: movies: movie_id
  @findOneAndUpdate _id: user_id, movie, (error, result) ->
    promise.done error, result
  promise

# -- Instance methods ----------------------------------------------------------
User.methods.updateAttributes = (attributes) ->
  promise = new Hope.Promise()
  @update attributes, (error, result) -> promise.done error, result
  promise

User.methods.parse = ->
  id        : @_id
  username  : @username
  mail      : @mail
  avatar    : @avatar
  movies    : @movies
  created_at: @created_at


exports = module.exports = db.model "User", User
