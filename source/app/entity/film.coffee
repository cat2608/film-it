"use strict"

class __.Entity.Film extends Atoms.Class.Entity

  @fields "id", "imdbid", "imdbrating", "imdbvotes",
          "language", "metascore", "plot", "poster", "rated", "released",
          "actors", "country", "director", "genre", "runtime", "title",
          "type", "year"

  @create: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      super attributes

  parse: ->
    image       : @url
    icon        : "user" unless @url
    info        : @when
    text        : @name
    description : @description or new Date()
    style       : if @url then "thumb" else @style
