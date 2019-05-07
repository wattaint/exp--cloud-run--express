_ = require 'lodash'
axios = require 'axios'

receivingServiceURL = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
metadataServerTokenURL =
  'http://metadata/computeMetadata/v1/instance/service-accounts/default/identity?audience='

fetchIdentityTokens = ->
  config = {
    url: metadataServerTokenURL + receivingServiceURL
    method: 'get'
    headers: {
      'Metadata-Flavor': 'Google'
    }
  }

  { data } = await axios.request config

  data

invokeCloudRun = (token) ->
  config = {
    url: receivingServiceURL
    method: 'get'
    headers: {
      'Authorization': "bearer #{token}"
    }
  }
  { data } = await axios.request config

  data

self = (req, res) ->
  token   = await fetchIdentityTokens()
  runResp = await invokeCloudRun token

  res.status(200).json { token, runResp }

if (require.main == module)
    self {}, {
      status: (code) ->
        console.log '--- code -- ', code
        {
          send: (message) ->
            console.log "Message: #{message}"

          json: (data) ->
            console.log "JSON: #{data}"
        }
    }

module.exports = self