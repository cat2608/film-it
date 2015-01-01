class Atoms.Organism.Main extends Atoms.Organism.Article

  @scaffold "assets/scaffold/main.json"

  render: ->
    super
    @films.list.el.hide()
    @context_id = "search"
    new __.Entity.Film()
    __.Entity.Film.bind "change", @countFilms

  fetch: ->
    __.proxy("GET", "user/movies").then (error, response) =>
      __.Entity.Film.create movie for movie in (response?.movies or [])
      Atoms.Url.path "main/films"

  # -- Children bubble events --------------------------------------------------
  onFilm: (atom) ->
    __.Article.Film.show atom.entity

  onFilmIMDB: (atom) ->
    __.Article.Film.search atom.entity

  onContext: (event, button) ->
    @context_id = button.attributes.text.toLowerCase()
    if @context_id is "search"
      @search.el.show()
      @films.search.el.show()
      @films.list.el.hide()
    else
      @search.el.hide()
      @films.search.el.hide()
      @films.list.entity __.Entity.Film[@context_id]()
      @films.list.el.show()

  onSearchSubmit: (event, input) ->
    do @onSearchChange
    parameters = title: input.value()
    __.proxy("GET", "movie/search", parameters).then (error, response) =>
      __.Entity.FilmIMDB.create movie for movie in response?.movies or []
    false

  onSearchChange: (event, input) ->
    __.Entity.FilmIMDB.destroyAll()
    @films.search.destroyChildren()
    false

  onSingout: (event, atom) ->
    window.localStorage.removeItem "filmit"
    Atoms.Url.back()

  # -- Private methods ---------------------------------------------------------
  countFilms: =>
    @context.pending.refresh count: __.Entity.Film.pending().length
    @context.viewed.refresh count: __.Entity.Film.viewed().length
    unless @context_id is "search"
      @films.list.entity __.Entity.Film[@context_id]()

new Atoms.Organism.Main()
