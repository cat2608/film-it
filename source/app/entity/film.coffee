"use strict"

class __.Entity.Film extends Atoms.Class.Entity

  @fields "id", "imdbid", "imdbrating", "imdbvotes",
          "language", "metascore", "plot", "poster", "rated", "released",
          "actors", "country", "director", "genre", "runtime", "title",
          "type", "year"

  # actors: "Christian Bale, Michael Caine, Liam Neeson, Katie Holmes"
  # country: "USA, UK"
  # created_at: "2014-12-15T09:42:00.940Z"
  # director: "Christopher Nolan"
  # genre: "Action, Adventure"
  # metascore: "70"
  # plot: "After training with his mentor, Batman begins his war on crime to free the crime-ridden Gotham City from corruption that the Scarecrow and the League of Shadows have cast upon it."poster: "http://ia.media-imdb.com/images/M/MV5BNTM3OTc0MzM2OV5BMl5BanBnXkFtZTYwNzUwMTI3._V1_SX300.jpg"
  # rated: "PG-13"
  # released: "15 Jun 2005"
  # response: "True"
  # runtime: "140 min"
  # title: "Batman Begins"
  # type: "movie"
  # writer: "Bob Kane (characters), David S. Goyer (story), Christopher Nolan (screenplay), David S. Goyer (screenplay)"
  # year: 2005

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
