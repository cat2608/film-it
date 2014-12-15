"use strict"

class __.Entity.FilmIMDB extends Atoms.Class.Entity

  @fields "title", "type", "year", "imdbID"

  parse: ->
    info        : @Year
    text        : @Title
    style       : @Type
