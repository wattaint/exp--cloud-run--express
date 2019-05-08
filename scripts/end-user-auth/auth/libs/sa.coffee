
# https://developers.google.com/identity/protocols/OAuth2ServiceAccount
# https://stackoverflow.com/questions/44507801/getting-google-idtoken-for-service-account
_         = require 'lodash'
axios     = require 'axios'
colors    = require 'colors'
fsx       = require 'fs-extra'
jws       = require 'jws'
moment    = require 'moment'
qs        = require 'querystring'

self = (aFilePath) ->
  unless await fsx.pathExists aFilePath
    console.log colors.red "Service account file not found! #{filePath}"
    return process.exit 1

  { client_id, client_email, private_key, private_key_id } = await fsx.readJson aFilePath

  me = {
    buildJWTToken: (url) ->
      header = { alg: "RS256", typ: "JWT" }
      payload = {
        iss: client_email
        aud: 'https://www.googleapis.com/oauth2/v4/token'
        target_audience: url
        exp: moment().add(1, 'hours').unix()
        iat: moment().unix()
      }

      token = jws.sign { header, payload, secret: private_key }
      token

    fetchIdToken: (jwt) ->
      conf = {
        url: "https://www.googleapis.com/oauth2/v4/token",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
        method: "post"
        data: qs.stringify {
          grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
          assertion: jwt
        }
      }
      
      { data } = await axios.request conf
      data
  }

module.exports = self
