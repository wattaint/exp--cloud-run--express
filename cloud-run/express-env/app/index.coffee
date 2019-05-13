LISTEN_PORT = process.env.PORT || 80

_ = require 'lodash'
axios     = require 'axios'
express   = require 'express'
jws       = require 'jws'
publicIp  = require 'public-ip'
qs        = require 'querystring'

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

fetchIdToken = (assertion) ->
  conf = {
    url: "https://www.googleapis.com/oauth2/v4/token",
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
    method: "post"
    data: qs.stringify {
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
      assertion
    }
  }
  
  { data } = await axios.request conf
  data

buildSignedHeadersJWTToken = ->
  header = { alg: "RS256", typ: "JWT" }
  payload = {
    aud: 'https://www.googleapis.com/oauth2/v4/token'
    exp: moment().add(1, 'hours').unix()
    iat: moment().unix()
    iss: client_email
    target_audience: process.env.IAP_TARGET_AUDIENCE
  }

  jws.sign { header, payload, secret: private_key }

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
  ipv4 = await publicIp.v4()
  resp.json { hello: 'world', ipv4, reqHeaders: req.headers }

app.get '/env', (req, resp) ->
  ipv4 = await publicIp.v4()
  resp.json { ipv4, env: process.env, reqHeaders: req.headers }

app.get '/test', (req, resp) ->
  url = "https://dpapi-staging-dp.ascendanalyticshub.com"
  
  try
    jwt = await buildSignedHeadersJWTToken()
    id_token = await fetchIdToken(jwt)
    data = await callIdp url, id_token

    resp.json { data }
  catch e
    console.log '--- error -----'
    resp.json {
      error: e.message
    }

app.listen LISTEN_PORT, ->
  console.log "listened1: #{LISTEN_PORT}"