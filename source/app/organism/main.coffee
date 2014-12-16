class Atoms.Organism.Main extends Atoms.Organism.Article

  @scaffold "assets/scaffold/main.json"

  render: ->
    super
    setTimeout ->
      __.proxy("GET", "list", {}, background = true).then (error, response) ->
        console.log ">>>", error, response
    , 100


  # -- Children bubble events --------------------------------------------------
  onFilm: (event, dispatcher, hierarchy...) ->

  onFilmIMDB: (atom) ->
    __.Article.Film.search atom.entity

  onContext: (event, button) ->
    context = button.attributes.text.toLowerCase()
    if context is "search"
      @search.el.show()
      @films.search.el.show()
      @films.list.el.hide()
    else
      @search.el.hide()
      @films.search.el.hide()
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

new Atoms.Organism.Main()
