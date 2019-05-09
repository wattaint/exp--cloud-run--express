LISTEN_PORT = process.env.PORT || 80

_ = require 'lodash'
express   = require 'express'
publicIp  = require 'public-ip'

app = express()

app.all '/', (req, resp) ->
  resp.json { hello: 'world', reqHeaders: req.headers }

app.get '/env', (req, resp) ->
  ipv4 = await publicIp.v4()
  resp.json { ipv4, env: process.env, reqHeaders: req.headers }

app.listen LISTEN_PORT, ->
  console.log "listened: #{LISTEN_PORT}"