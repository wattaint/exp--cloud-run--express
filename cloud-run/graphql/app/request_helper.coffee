# https://developers.google.com/identity/protocols/OAuth2ServiceAccount
# https://stackoverflow.com/questions/44507801/getting-google-idtoken-for-service-account
_         = require 'lodash'
axios     = require 'axios'
jws       = require 'jws'
Promise = require 'bluebird'
moment    = require 'moment'
qs        = require 'querystring'

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

JenkinsConfigure = (name) ->
  data = {
    local: {
      userId: 'admin'
      apiToken: '11c4c6917703574b40cd598e2ca4b49e58'
      url: '10.164.18.62:8080'
      protocol: 'http'
    }
    remote_iap: {
      userId: 'admin'
      apiToken: '1101c2b1a0e9a6fc62fa6c6d3d297fd65c'
      url: 'dpapi-staging-dp.ascendanalyticshub.com'
      protocol: 'https'
    }
    remote_int: {
      userId: 'admin'
      apiToken: '1101c2b1a0e9a6fc62fa6c6d3d297fd65c'
      url: "10.148.0.32"
      protocol: 'http'
    }
  }

  data[name]

buildJenkinsInstance = (name, aOpts) ->
  { userId, apiToken, url, protocol } = JenkinsConfigure name
  options = {
    baseUrl: "#{protocol}://#{userId}:#{apiToken}@#{url}"
    crumbIssuer: false
  }
  console.log options
  _.extend options, aOpts if _.isObject(aOpts)
  require('jenkins') options

SERVICE_ACCOUNT = {
  client_email: "test-invoke-cloud-run@dataplatform-1363.iam.gserviceaccount.com"
  private_key: "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDg/crGRE77mKR0\nIn25EpBWBzlherVrDTb49V2+BBEQspX/XW3ZVcQ5MXQmqwzMHRwWj0OkEaOrWp1N\nLph0cnq3wsY2ggsBLJXmqAmrIOzGlcm7acJN4OXUMhZibur9x6hAdHio7CAUHmTy\nHNGClyNKOl3ESIMZdWQBEdKyR47uD8iBjkqcGgf8UEXDGxn9MxrUOtsG0u5pCJ8g\n+VYl4z4AN2msIsKaXWgnqyeFx1uYyI/xEK/a9yxXAb318uoHTWRJT9GIVB6dAh53\nSoobfQqNtFgkvS6tvMF1iLCwv63h8AoEzICXjvCwdPQw5eV/ofhZMUXSVxaUS5vt\nhNWIod5jAgMBAAECggEAG0i7q+KBv4IJw2mhXG2zYjNbEoaqdHJ0TamXtiDRHvjB\nNugSF66Obq8gGkZY9XG8Q8IY3k8jTXbeJ4t0gn6Vgi5VEiwgAILzJLcRARcrj4N/\npMIVBZO12089pq8zwRXSwgo9zaJg23+6FyBGifMhHPHKCDEQ8Ofq+jQ6nFMQMq8u\nCYsjWazE8D7CK9qf3ogXvWGYJufSMPjNogyYEe8HN7IlyBN/R/vUGLCudLMHkBzZ\nqdxRs3wRHA/0coYPPQNCnpimafbx2A2cQqxhOPWjzv+bVTLpS6WZAU+JwMmC4ybX\nOXYIzwNdtEgvRch4HsHYlxMYkuj9qb6rW1N7XsP8XQKBgQD7FMfe1sxpvUo5lMR7\nx8cTGJ2kwvSPkXYpWj4QyRUMAJ30Oc8X78+vyv2XUomwyYE9IxV8RqV7CVLqWtGB\noMEogxQ2PQD9domxtr/tkbMAZnisPHd1DaLKXOgrn+btwlG+PkcUmiW7JtoLghzR\n/8tI76LdaLxRz01LQZMqcvAZnwKBgQDlZiqFcv/O0gvQ7K6YoY6NVJdhccluEZGi\noqnfeh1ZlDolYMM8QybJPX0IOT+wJvX29pFzEwezMyN+9IRSD0VlegMTRyhsYUo1\nHSkoxpOYAfu8wpfhY3NpTfvaZj8lFbjbt+vMCu8jF3vW2tOlBetrC9TNEqn4VRSR\n5l1UGySMvQKBgQDFFsbd0VacGg5NrM2fLG7EOqpkTvSSTeinBUN7AZ0X0tQqhcZe\nT8yDfaAaTJvwvfxI9WVELGBxeBwyAiA61OlK17nh6XkBfS8Q5Rc7cQdF5SoMaVqL\n86w5lTxaIiavs71ezJwXO/kqM5EtP3FIFraIBjOeATzyKvvNeyf+RkLamQKBgQCV\nSo8juDrIw6QS/OWHyaR3T/UQ4refnWl1OX1qRhOxx6iryLRmlKE6WHz1jCRppIFw\njvkLtffN5NsV9VXj/bJBH02/DxE8r3hW5rpxogJN7ASDzPSBJ3Lltm3Qrbgsj112\nCNU5PmhxIwhiRJl2jUqvqMx+BcZ+KgiwBwb4BI4d1QKBgQCtnA95EejIqin0KWHk\nm2UJB5YAs21INQYkVfkR7sgpxfbEbWylCjAdKCmWx42lOh16dtiUsKeTYy04kKd0\nFdbB9tM4vCd11uU9SHygkYyjt+MzLznGOT5iLKBmBYg4KQIYpmTaYSKDzy6N1Dir\nEKM+mNRziC5oYo8AqxxrX174CA==\n-----END PRIVATE KEY-----\n"

}

self = {
  buildSignedHeadersJWTToken: ->
    header = { alg: "RS256", typ: "JWT" }
    payload = {
      aud: 'https://www.googleapis.com/oauth2/v4/token'
      exp: moment().add(1, 'hours').unix()
      iat: moment().unix()
      iss: SERVICE_ACCOUNT.client_email
      target_audience: "863016118673-08v4207jrjsh5jum70404bqq1u3keig4.apps.googleusercontent.com"
    }

    jws.sign { header, payload, secret: SERVICE_ACCOUNT.private_key }
    
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

  getJenkins: ->
    USER_JENKINS = 'remote_iap'
    token = await self.buildSignedHeadersJWTToken()
    { id_token } = await self.fetchIdToken token
    
    { userId, apiToken, url, protocol } = JenkinsConfigure USER_JENKINS

    config = {
      url: "#{protocol}://#{userId}:#{apiToken}@#{url}/login"
      #url: "#{protocol}://#{url}/login"
      #url: "#{protocol}://#{url}/api/json?tree=jobs[name]"
      auth: {
          username: userId
          password: apiToken
      }
      method: 'get'
      headers: {
        Authorization: "Bearer #{id_token}"
      }
    }

    axios.interceptors.request.use (request) ->
      console.log('Starting Request', request)
      return request
    
    # console.log '-x-', config
    # { data } = await axios.request config
    # console.log '-y-', { data }
    # return resp

    console.log '--1---1--'
    jenkins = buildJenkinsInstance USER_JENKINS, {
      headers: {
        Authorization: "Bearer #{id_token}"
      }
    }

    console.log '----------------------'
    res = await new Promise (resolve, reject) ->
      jenkins.info (err, results) ->
        if err
          console.log '--err---'
          reject err
        else
          console.log '--results--------'
          console.log results
          resolve results
    
    console.log res
    res
}

module.exports = self