
http = require "http"
fs = require "fs"

server = null

txns = []

module.exports =

  start: (port, done) ->
    server = http.createServer (req, res) ->
      if req.method == "POST"
        req.on "data", (tx) ->
          tx = JSON.parse tx
          for t in tx.txn
            t.date = tx.date
            txns.push t
          res.setHeader "status", 200
          res.end()
      else
        if req.url == "/korns.csv"
          res.end txns.map((t) ->
            t.date + "," + t.product + "," + t.menge
          ).join "\n"
        else
          fs.createReadStream("./kornumsatz.csv").pipe res
    server.listen port, done

  stop: () -> server.close()
