
http = require "http"
fs = require "fs"

server = null

module.exports =

  start: (port, done) ->
    server = http.createServer (req, res) ->
      fs.createReadStream("./kornumsatz.csv").pipe res
    server.listen port, done

  stop: () -> server.close()
