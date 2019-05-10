#!/usr/bin/env coffee

Mocha   = require 'mocha'
path    = require 'path'
program = require 'commander'

program
  .command 'login'
  .action ->
    

program
  .command 'test'
  .action ->
    mocha = new Mocha()
    mocha.addFile path.join __dirname, 'test_scripts.coffee'

    await new Promise (resolve) ->
      mocha.run (failures) ->
        process.exitCode = if failures > 0
                            failures + 3
                           else
                            failures
        resolve()
    
program.parse process.argv