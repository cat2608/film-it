"use strict"

class __.Entity.FilmIMDB extends Atoms.Class.Entity

  @fields "title", "type", "year", "imdb"

  parse: ->
    info        : @year
    text        : @title
    style       : @type
