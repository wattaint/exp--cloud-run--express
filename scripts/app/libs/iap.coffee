
# https://developers.google.com/identity/protocols/OAuth2ServiceAccount
# https://stackoverflow.com/questions/44507801/getting-google-idtoken-for-service-account
_         = require 'lodash'
axios     = require 'axios'
colors    = require 'colors'
fsx       = require 'fs-extra'
jws       = require 'jws'
jwt       = require 'jsonwebtoken'
moment    = require 'moment'
qs        = require 'querystring'

self = (aFilePath) ->
  unless await fsx.pathExists aFilePath
    console.log colors.red "Service account file not found! #{filePath}"
    return process.exit 1

  { client_id, client_email, private_key } = await fsx.readJson aFilePath

  me = {
    buildSignedHeadersJWTToken: (url) ->
      header = { alg: "RS256", typ: "JWT" }
      payload = {
        aud: 'https://www.googleapis.com/oauth2/v4/token'
        exp: moment().add(1, 'hours').unix()
        iat: moment().unix()
        iss: client_email
        target_audience: "863016118673-08v4207jrjsh5jum70404bqq1u3keig4.apps.googleusercontent.com"
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
