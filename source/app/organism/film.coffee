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
    parameters = imdb: @entity.imdb
    action = atom.attributes.action
    __.proxy("POST", "user/movie", parameters).then (error, response) ->
      console.log "POST/movie/#{action}", error, response
      Atoms.Url.back()

  # -- Private events ----------------------------------------------------------
  show: (@entity) =>
    @info.poster.el.hide()
    unless entity.poster is "N/A"
      @info.poster.refresh url: entity.poster
      @info.poster.el.show()
    @info.extra.title.el.html entity.title
    @info.extra.year_director.el.html "#{entity.year} - #{entity.director}"
    @info.extra.actors.el.html entity.actors
    @info.extra.summary.el.html entity.plot
    Atoms.Url.path "film/info"

new Atoms.Organism.Film()
