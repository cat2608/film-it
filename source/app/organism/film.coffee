class Atoms.Organism.Film extends Atoms.Organism.Article

  @scaffold "assets/scaffold/film.json"

  constructor: ->
    super
    do @render

  # -- Instance methods --------------------------------------------------------
  search: (entity) ->
    parameters = imdb: entity.imdb
    __.proxy("GET", "movie/info", parameters).then (error, response) =>
      @show __.Entity.Film.create response?.movie

  # -- Children bubble events --------------------------------------------------
  onAction: (event, atom) ->
    state = value for key, value in ["fav", "view"] when key is atom.attributes.action
    parameters = imdb: @entity.imdb, state: state
    __.proxy("POST", "user/movie", parameters).then (error, response) ->
      Atoms.Url.back()

  # -- Private events ----------------------------------------------------------
  show: (@entity) =>
    console.log @entity
    style = if entity.poster then "big" else "hiden"
    @info.poster.refresh url: entity.poster, style: style
    @info.extra.title.el.html entity.title
    @info.extra.year.el.html entity.year.toString()
    @info.extra.runtime.el.html entity.runtime
    @info.extra.director.el.html entity.director
    @info.extra.actors.el.html entity.actors
    @info.extra.summary.el.html entity.plot
    Atoms.Url.path "film/info"

new Atoms.Organism.Film()
