_         = require 'lodash'
http      = require 'http'
httpProxy = require 'http-proxy'

proxy = httpProxy.createProxyServer({})

proxy.on 'proxyReq', (proxyReq, req, res, options) ->
  apiAcct   = _(req.headers).get 'x-goog-authenticated-user-email'
  authBasic = _(req.headers).get 'x-jenkins-auth-basic'
  if apiAcct && authBasic
    if apiAcct in [
      'accounts.google.com:test-invoke-cloud-run@dataplatform-1363.iam.gserviceaccount.com'
    ]
      console.log '--found service-account --'
      console.log req.headers
      console.log '-- end header --'
      proxyReq.setHeader 'Authorization', "Basic #{authBasic}"
      
server = http.createServer (req, res) ->
  proxy.web req, res, {
    target: 'http://jenkins:8080'
  }

server.listen 80