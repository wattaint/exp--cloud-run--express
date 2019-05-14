_         = require 'lodash'
axios     = require 'axios'
http      = require 'http'
httpProxy = require 'http-proxy'
JWT       = require 'jsonwebtoken'

ExpectedAud = "/projects/863016118673/global/backendServices/6645180094119552343"
proxy = httpProxy.createProxyServer({})

PublickKeyCache = {}
getPublicKey = ({ alg, typ, kid }, callback) ->
  pem = _(PublickKeyCache).get kid
  unless _.isString pem
    { data } = await axios.get "https://www.gstatic.com/iap/verify/public_key"
    pem = _(data).get kid
    if _.isString pem then PublickKeyCache = data
  
  callback null, pem
  
validate = (token) ->
  new Promise (resolve, reject) ->
    return reject('---') unless token
    JWT.verify token, getPublicKey, {}, (err, decoded) ->
      return reject(err) if err
      aud = _(decoded).get 'aud'
      return reject('Signed Header JWT Audience, Invalid') unless aud == ExpectedAud
      resolve()
      
proxy.on 'proxyReq', (proxyReq, req, res, options) ->
  apiAcct   = _(req.headers).get 'x-goog-authenticated-user-email'
  if apiAcct
    authBasic = _(req.headers).get 'x-jenkins-auth-basic'
    if authBasic
      proxyReq.setHeader 'Authorization', "Basic #{authBasic}"
      
server = http.createServer (req, res) ->
  assertion = _(req.headers).get 'x-goog-iap-jwt-assertion'

  errMsg = null
  try
    errMsg = await validate assertion
  catch e
    errMsg = "(#{e.message})"
  
  if errMsg
    res.writeHead 401, { "Content-Type": "text/plain" }
    res.write "IAP Unauthorized. #{errMsg}"
    res.end()
  else
    proxy.web req, res, {
      target: 'http://jenkins:8080'
    }
  
server.listen 80