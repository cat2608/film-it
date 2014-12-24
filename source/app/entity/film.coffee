"use strict"

class __.Entity.Film extends Atoms.Class.Entity

  @fields "id", "imdb", "imdbrating", "imdbvotes",
          "language", "metascore", "plot", "poster", "rated", "released",
          "actors", "country", "director", "genre", "runtime", "title",
          "type", "year", "state"

  STATE =
    PENDING: 0
    VIEWED : 1

  @create: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      super attributes

  @pending: -> @select (entity) -> entity if entity.state is STATE.PENDING

  @viewed: -> @select (entity) -> entity if entity.state is STATE.VIEWED

  parse: ->
    image       : @poster or "https://cdn4.iconfinder.com/data/icons/eldorado-multimedia/40/movie_1-512.png"
    info        : @year
    text        : @title
    description : @director
    style       : "film"
