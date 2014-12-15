class Atoms.Organism.Film extends Atoms.Organism.Article

  @scaffold "assets/scaffold/film.json"

  constructor: ->
    super
    do @render

  # -- Instance methods --------------------------------------------------------
  show: (entity) ->
    parameters = imdbid: entity.imdbID
    __.proxy("GET", "movie/info", parameters).then (error, response) =>
      entity = __.Entity.Film.create response?.movie
      # Data
      @binding entity
      # Show
      Atoms.Url.path "film/info"

  # -- Children bubble events --------------------------------------------------
  onButtonTouch: (event, dispatcher, hierarchy...) ->
    # Your code...

  # -- Private events ----------------------------------------------------------
  binding: (entity) =>
    console.log "[entity]", entity
    @info.poster.el.style "background-image", "url(#{entity.poster})"
    @info.extra.title.el.html entity.title
    @info.extra.year_director.el.html "#{entity.year} - #{entity.director}"
    @info.extra.actors.el.html entity.actors
    @info.extra.summary.el.html entity.plot

new Atoms.Organism.Film()
