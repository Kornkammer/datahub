get = require("request")
test = require("tape")

hub = require("./hub")

hub.start 3333, () ->

  test "get csv for shiny", (t) ->
    get "http://localhost:3333/kornumsatz.csv", (res, enc, body) ->
      t.ok body
      t.ok body.split("\n").length > 1, "there should be lines!"
      t.ok body.split("\n")[1].split(",").length > 1, "columns"
      t.end()

  test "shut down", (t) ->
    hub.stop()
    t.end()
