_               = require 'lodash'
Promise         = require 'bluebird'
chai            = require 'chai'
fs              = require 'fs'
yaml            = require 'js-yaml'
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

expect          = chai.expect

self = {
  loadConfig: (file) ->
    config = yaml.safeLoad fs.readFileSync(file, 'utf8')
    envNames = _.keys config

    {
      envNames,
      getConfig: (env) ->
        config[env]
    }
}

module.exports = _.extend self, {
  _, expect, Promise, yaml
}
