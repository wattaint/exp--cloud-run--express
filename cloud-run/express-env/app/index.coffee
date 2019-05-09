LISTEN_PORT = process.env.PORT || 80

_ = require 'lodash'
axios     = require 'axios'
express   = require 'express'
publicIp  = require 'public-ip'

metadataServerTokenURL =
  'http://metadata/computeMetadata/v1/instance/service-accounts/default/identity?audience='

fetchIdentityTokens = (receivingServiceURL) ->
  console.log '-- fetchIdentityTokens --  ', receivingServiceURL
  config = {
    url: metadataServerTokenURL + receivingServiceURL
    method: 'get'
    headers: {
      'Metadata-Flavor': 'Google'
    }
  }

  { data } = await axios.request config
  console.log '-- result - ', data
  data

callIdp = (url, token) ->
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'
  console.log ''
  console.log "Send Request to: #{url}"
  conf = {
    url,
    method: 'get'
    headers: {
      Authorization: "Bearer #{token}"
    }
  }
  console.log conf
  { data } = await axios.request conf

  console.log ''
  console.log 'Response:'
  console.log data
  data

app = express()

app.all '/', (req, resp) ->
  resp.json { hello: 'world', reqHeaders: req.headers }

app.get '/env', (req, resp) ->
  ipv4 = await publicIp.v4()
  console.log "-- ip v4 --", ipv4
  resp.json { ipv4, env: process.env, reqHeaders: req.headers }

app.get '/test', (req, resp) ->
  url = "https://dpapi-staging-dp.ascendanalyticshub.com/env"
  try
    data = await fetchIdentityTokens(url)
    data = await callIdp url, data
    console.log '---x---'
    resp.json { data }
  catch e
    console.log '--- error -----'
    resp.json {
      error: e.message
    }

app.listen LISTEN_PORT, ->
  console.log "listened1: #{LISTEN_PORT}"