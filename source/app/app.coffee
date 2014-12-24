"use strict"

Atoms.$ ->
  console.log "------------------------------------------------------------"
  console.log "Atoms v#{Atoms.version} (Atoms.App v#{Atoms.App.version})"
  console.log "------------------------------------------------------------"

  # COOKIE Getting session (if exists)
  __.session = window.localStorage.getItem "filmit"
  unless __.session
    new Atoms.Organism.Session()
    Atoms.Url.path "session/credentials"
  else
    __.Article.Main.fetch()

