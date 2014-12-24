"use strict"

Atoms.$ ->
  console.log "------------------------------------------------------------"
  console.log "Atoms v#{Atoms.version} (Atoms.App v#{Atoms.App.version})"
  console.log "------------------------------------------------------------"

  # Getting session (if exists)
  for cookie in document.cookie.split ";"
    values = cookie.split "="
    if values[0].trim() is "filmit"
      __.session = values[1].trim()
      break

  unless __.session
    new Atoms.Organism.Session()
    Atoms.Url.path "session/credentials"
  else
    __.Article.Main.fetch()

