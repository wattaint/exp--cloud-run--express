jws     = require 'jws'
moment  = require 'moment'
qs      = require 'querystring'
axios   = require 'axios'

self = {
  buildSignedHeadersJWTToken: ({ client_email, private_key, target_audience }) ->
    header = { alg: "RS256", typ: "JWT" }
    payload = {
      aud: 'https://www.googleapis.com/oauth2/v4/token',
      exp: moment().add(1, 'hours').unix(),
      iat: moment().unix(),
      iss: client_email,
      target_audience
    }

    jws.sign { header, payload, secret: private_key }
    
  fetchIdToken: (assertion) ->
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
}

module.exports = self