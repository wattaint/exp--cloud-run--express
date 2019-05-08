
# https://developers.google.com/identity/protocols/OAuth2ServiceAccount
_         = require 'lodash'
base64url = require 'base64url'
crypto    = require 'crypto'
fsx       = require 'fs-extra'
jwt       = require 'jsonwebtoken'
moment    = require 'moment'
CryptoJS  = require 'crypto-js'
jws       = require 'jws'
sha256    = require 'sha256'
{ JWT }   = require 'google-auth-library'

EX = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3NjEzMjY3OTgwNjktcjVtbGpsbG4xcmQ0bHJiaGc3NWVmZ2lncDM2bTc4ajVAZGV2ZWxvcGVyLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJzY29wZSI6Imh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL2F1dGgvcHJlZGljdGlvbiIsImF1ZCI6Imh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29hdXRoMi92NC90b2tlbiIsImV4cCI6MTMyODU1NDM4NSwiaWF0IjoxMzI4NTUwNzg1fQ======UFUt59SUM2_AW4cRU8Y0BYVQsNTo4n7AFsNrqOpYiICDu37vVt-tw38UKzjmUKtcRsLLjrR3gFW3dNDMx_pL9DVjgVHDdYirtrCekUHOYoa1CMR66nxep5q5cBQ4y4u2kIgSvChCTc9pmLLNoIem-ruCecAJYgI9Ks7pTnW1gkOKs0x3YpiLpzplVHAkkHztaXiJdtpBcY1OXyo6jTQCa3Lk2Q3va1dPkh_d--GU2M5flgd8xNBPYw4vxyt0mP59XZlHMpztZt0soSgObf7G3GXArreF_6tpbFsS3z2t5zkEiHuWJXpzcYr5zWTRPDEHsejeBSG8EgpLDce2380ROQ
"

self = (aFilePath) ->
  unless await fsx.pathExists aFilePath
    console.log colors.red "Service account file not found! #{filePath}"
    return process.exit 1

  { client_id, client_email, private_key, private_key_id } = await fsx.readJson aFilePath

  me = {
    fetchToken: (aAccessToken) ->
      header = me.getHeaderObj()
      header = _.extend header, {
        #kid: private_key_id
      }

      claimSet = me.getClaimSetObj()
      payload = _.extend me.getClaimSetObj(), {
        sub: client_email
        #aud: "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
        target_audience: "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
      }
      console.log '-- header  --'
      console.log header
      console.log '-- payload --'
      console.log payload

      token = jws.sign({ header, payload, secret: private_key })
      console.log token
      token

    toJwt: ->
      console.log 'to-jwt', aFilePath

      header =  me.getHeaderObj()
      payload = me.getClaimSetObj()
      token = jws.sign({ header, payload, secret: private_key })
      
      token

    getHeaderObj: ->
      { alg: "RS256", typ: "JWT" }

    getClaimSetObj: ->
      ret = {
        iss: client_email
        #scope: 'https://www.googleapis.com/auth/cloud-platform'
        aud: 'https://www.googleapis.com/oauth2/v4/token'
        #target_audience: client_id
        #aud: "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
        #target_audience: "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
        exp: moment().add(1, 'hours').unix()
        iat: moment().unix()
      }

      ret
    
  }

module.exports = self
