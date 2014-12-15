class Atoms.Organism.Main extends Atoms.Organism.Article

  @scaffold "assets/scaffold/main.json"


  # -- Children bubble events --------------------------------------------------
  onFilm: (event, dispatcher, hierarchy...) ->

  onFilmIMDB: (atom) ->
    __.Article.Film.show atom.entity

  onContext: (event, button) ->
    context = button.attributes.text.toLowerCase()
    if context is "search"
      @search.el.show()
    else
      @search.el.hide()

  onSearchSubmit: (event, input) ->
    __.Entity.FilmIMDB.destroyAll()
    parameters = title: input.value()
    __.proxy("GET", "movie/search", parameters).then (error, response) =>
      __.Entity.FilmIMDB.create movie for movie in response?.movies or []

  # -- Private events ----------------------------------------------------------

new Atoms.Organism.Main()
