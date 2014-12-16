"use strict"

class __.Entity.Film extends Atoms.Class.Entity

  @fields "id", "imdb", "imdbrating", "imdbvotes",
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
    image       : @poster or null
    info        : @year
    text        : @title
    description : @director
    style       : "film"
