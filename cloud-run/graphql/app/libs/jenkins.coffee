Promise   = require 'bluebird'
URL       = require 'url'
_         = require 'lodash'


{ buildSignedHeadersJWTToken, fetchIdToken } = require './request'

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

SERVICE_ACCOUNT = {
  client_email: "test-invoke-cloud-run@dataplatform-1363.iam.gserviceaccount.com"
  private_key: """
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDg/crGRE77mKR0
In25EpBWBzlherVrDTb49V2+BBEQspX/XW3ZVcQ5MXQmqwzMHRwWj0OkEaOrWp1N
Lph0cnq3wsY2ggsBLJXmqAmrIOzGlcm7acJN4OXUMhZibur9x6hAdHio7CAUHmTy
HNGClyNKOl3ESIMZdWQBEdKyR47uD8iBjkqcGgf8UEXDGxn9MxrUOtsG0u5pCJ8g
+VYl4z4AN2msIsKaXWgnqyeFx1uYyI/xEK/a9yxXAb318uoHTWRJT9GIVB6dAh53
SoobfQqNtFgkvS6tvMF1iLCwv63h8AoEzICXjvCwdPQw5eV/ofhZMUXSVxaUS5vt
hNWIod5jAgMBAAECggEAG0i7q+KBv4IJw2mhXG2zYjNbEoaqdHJ0TamXtiDRHvjB
NugSF66Obq8gGkZY9XG8Q8IY3k8jTXbeJ4t0gn6Vgi5VEiwgAILzJLcRARcrj4N/
pMIVBZO12089pq8zwRXSwgo9zaJg23+6FyBGifMhHPHKCDEQ8Ofq+jQ6nFMQMq8u
CYsjWazE8D7CK9qf3ogXvWGYJufSMPjNogyYEe8HN7IlyBN/R/vUGLCudLMHkBzZ
qdxRs3wRHA/0coYPPQNCnpimafbx2A2cQqxhOPWjzv+bVTLpS6WZAU+JwMmC4ybX
OXYIzwNdtEgvRch4HsHYlxMYkuj9qb6rW1N7XsP8XQKBgQD7FMfe1sxpvUo5lMR7
x8cTGJ2kwvSPkXYpWj4QyRUMAJ30Oc8X78+vyv2XUomwyYE9IxV8RqV7CVLqWtGB
oMEogxQ2PQD9domxtr/tkbMAZnisPHd1DaLKXOgrn+btwlG+PkcUmiW7JtoLghzR
/8tI76LdaLxRz01LQZMqcvAZnwKBgQDlZiqFcv/O0gvQ7K6YoY6NVJdhccluEZGi
oqnfeh1ZlDolYMM8QybJPX0IOT+wJvX29pFzEwezMyN+9IRSD0VlegMTRyhsYUo1
HSkoxpOYAfu8wpfhY3NpTfvaZj8lFbjbt+vMCu8jF3vW2tOlBetrC9TNEqn4VRSR
5l1UGySMvQKBgQDFFsbd0VacGg5NrM2fLG7EOqpkTvSSTeinBUN7AZ0X0tQqhcZe
T8yDfaAaTJvwvfxI9WVELGBxeBwyAiA61OlK17nh6XkBfS8Q5Rc7cQdF5SoMaVqL
86w5lTxaIiavs71ezJwXO/kqM5EtP3FIFraIBjOeATzyKvvNeyf+RkLamQKBgQCV
So8juDrIw6QS/OWHyaR3T/UQ4refnWl1OX1qRhOxx6iryLRmlKE6WHz1jCRppIFw
jvkLtffN5NsV9VXj/bJBH02/DxE8r3hW5rpxogJN7ASDzPSBJ3Lltm3Qrbgsj112
CNU5PmhxIwhiRJl2jUqvqMx+BcZ+KgiwBwb4BI4d1QKBgQCtnA95EejIqin0KWHk
m2UJB5YAs21INQYkVfkR7sgpxfbEbWylCjAdKCmWx42lOh16dtiUsKeTYy04kKd0
FdbB9tM4vCd11uU9SHygkYyjt+MzLznGOT5iLKBmBYg4KQIYpmTaYSKDzy6N1Dir
EKM+mNRziC5oYo8AqxxrX174CA==
-----END PRIVATE KEY-----
"""
}

JenkinsConfigure = (name) ->
  data = {
    'acm-prod': {
      userId: 'wattana.int@ascendcorp.com'
      apiToken: '90ee27b01ecc0b7791a2533769ce2eda'
      url: 'jenkins-acm-prod.ascendanalyticshub.com'
      protocol: 'https'
      skipIdToken: true
    }
    'dp-ci': {
      userId: 'wattana.int@ascendcorp.com'
      apiToken: '11894de468f40f0a2fdb55cb84f726de01'
      url: 'jenkins-dp-development.ascendanalyticshub.com'
      protocol: 'https'
      skipIdToken: true
    }
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

selfJenkins = null
self = {
  jobFullNameFromUrl: (url) ->
    myURL = URL.parse url
    name = myURL.pathname.split('/job/').join('/').slice(1, -1)
    decodeURI name

  buildJenkinsInstance: (name, id_token) ->
    { userId, apiToken, url, protocol, skipIdToken } = JenkinsConfigure name
    jenkinsToken = Buffer.from("#{userId}:#{apiToken}").toString 'base64'
    options = {
      baseUrl: "#{protocol}://#{url}"
      #crumbIssuer: false
      # headers: {
        
      # }
    }

    if skipIdToken
      # _.extend options.headers, {
      #   headers: {
      #     Authorization: "Basic #{jenkinsToken}"
      #   }
      # }
      options.baseUrl = "#{protocol}://#{userId}:#{apiToken}@#{url}"
    else
      _.extend options.headers, {
        Authorization: "Bearer #{id_token}"
        'X-Jenkins-Auth-Basic': jenkinsToken
      }
    console.log options
    jenkins = require('jenkins') options

    Promise.promisifyAll jenkins
    Promise.promisifyAll jenkins.job
    Promise.promisifyAll jenkins.view

    jenkins

  getInstance: ->
    return selfJenkins if selfJenkins

    USE_JENKINS = 'acm-prod'
    token = await buildSignedHeadersJWTToken {
      client_email: SERVICE_ACCOUNT.client_email
      private_key: SERVICE_ACCOUNT.private_key
      target_audience: "863016118673-08v4207jrjsh5jum70404bqq1u3keig4.apps.googleusercontent.com"
    }
    { id_token } = await fetchIdToken token
    selfJenkins = self.buildJenkinsInstance USE_JENKINS, id_token
    selfJenkins
}

module.exports = self