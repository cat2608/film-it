class Atoms.Organism.Film extends Atoms.Organism.Article

  @scaffold "assets/scaffold/film.json"

  STATE =
    pending: 0
    viewed : 1

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
    __.proxy("POST", "user/movie", parameters, background = true).then (error, response) =>
      @entity.updateAttributes state: state
      Atoms.Url.back()
      message =
        title       : "Saved #{@entity.title} at #{[Object.keys(STATE)[state]]} list"
        description : @entity.title
        image       : @entity.poster
        timeout     : 4000
      __.Dialog.Push.show message, timeout = 2000

  onDelete: (event, atom) ->
    __.proxy("DELETE", "user/movie", id: @entity.id).then (error, response) =>
      @entity.destroy()
      Atoms.Url.back()

  # -- Private events ----------------------------------------------------------
  show: (@entity) =>
    @info.extra.button.pending.el.show()
    @info.extra.button.viewed.el.show()
    @info.extra.button.delete.el.hide()

    if @entity.state isnt undefined
      for key, value of STATE when @entity.state isnt value
        @info.extra.button[key].el.show()
        @info.extra.button[Object.keys(STATE)[@entity.state]].el.hide()
        @info.extra.button.delete.el.show()

    style = if @entity.poster then "big" else "hidden"
    @info.poster.refresh url: @entity.poster, style: style
    @info.extra.title.el.html @entity.title
    @info.extra.year.el.html @entity.year.toString()
    @info.extra.runtime.el.html @entity.runtime
    @info.extra.director.el.html @entity.director
    @info.extra.actors.el.html @entity.actors
    @info.extra.summary.el.html @entity.plot or ""

    Atoms.Url.path "film/info"

new Atoms.Organism.Film()
