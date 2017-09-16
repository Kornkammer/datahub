http = require("request")
test = require("tape")

hub = require("./hub")

# crash test dummy
tx =
  time: 1234567
  inputs: [
    { account: "Kasse", product: "Cash", price: 1, amount: 9.8, unit: "Cash" }
  outputs: [
    { account: "Lager", product: "Reis", price: 2.5, amount: 1, unit: "Kg" }
    { account: "Lager", product: "Wein", price: 7.3, amount: 1, unit: "L" }
  ]

tx = JSON.stringify tx



hub.start 3333, () ->

  test "get csv for shiny", (t) ->
    http "http://localhost:3333/kornumsatz.csv", (res, enc, body) ->
      t.ok body
      t.ok body.split("\n").length > 1, "there should be lines!"
      t.ok body.split("\n")[1].split(",").length > 1, "columns"
      t.end()

  test "empty hub", (t) ->
    http "http://localhost:3333/korns.csv", (res, enc, body) ->
      t.equal body.length, 0, "there no lines"
      t.end()

  test "post txn", (t) ->
    http.post "http://localhost:3333", body: tx, (err, res, body) ->
      t.equal res.headers.status, "200"
      t.end()

  hash = null
  test "get two csv lines", (t) ->
    http "http://localhost:3333/korns.csv", (res, enc, body) ->
      lines = body.split("\n")
      t.equal lines.length, 2, "there be two lines"
      t.equal lines[0].split(","), 4, "four columns"
      hash = lines[1].split(",")[0]
      t.equal hash.length, 5, "hash"
      t.end()

  test "no new lines", (t) ->
    http "http://localhost:3333/korns.csv?since=#{hash}", (res, enc, body) ->
      t.equal body.length, 0, "there no lines"
      t.end()

  test "post next txn", (t) ->
    http.post "http://localhost:3333", body: tx, (err, res, body) ->
      http "http://localhost:3333/korns.csv?since=#{hash}", (res, enc, body) ->
        lines = body.split("\n")
        t.equal lines.length, 2, "there be two lines"
        t.end()

  test "shut down", (t) ->
    hub.stop()
    console.log JSON.stringify tx
    t.end()
