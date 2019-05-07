_               = require 'lodash'
chai            = require 'chai'
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

expect        = chai.expect

axios = require 'axios'
keys = require("./service-accounts/dataplatform-1363-2d03bde2ea4a.json")
{ JWT } = require 'google-auth-library'

request = require('request-promise')
receivingServiceURL = 
authen = ->
  false
  #https://stackoverflow.com/questions/55205823/postman-and-google-service-account-how-to-authorize

client = null
url = 'https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app'

describe 'test axios', ->
  before ->
    client = new JWT(
      keys.client_email,
      null,
      keys.private_key,
      ['https://www.googleapis.com/auth/cloud-platform']
    )
    
  it 's', ->
    resp = await client.request { url }
    expect(1).to.equal 1
