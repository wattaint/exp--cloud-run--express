require("util").inspect.defaultOptions.depth = null
# process.on 'unhandledRejection', (reason, p) ->
#   console.log 'Unhandled Rejection at: Promise'
#   console.log p
_               = require 'lodash'
chai            = require 'chai'
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

expect        = chai.expect

Promise       = require 'bluebird'
fs            = require 'fs'
Path          = require 'path'

self = {}

module.exports = _.extend {
  _
  expect
  Promise
}, self