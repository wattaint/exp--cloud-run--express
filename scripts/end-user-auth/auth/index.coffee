#!/usr/bin/env coffee
colors    = require 'colors'
fg        = require 'fast-glob'
inquirer  = require('inquirer')
path      = require 'path'
program   = require 'commander'
axios     = require 'axios'

program
  .command 'login'
  .action (cmd) ->
    { oauth2Client,
      generateUrl,
      setCode,
      display } = await require('./libs/auth')({ login: true })
    
    if cmd.info
      return display()

    console.log colors.bold.green ">> Login url"
    console.log generateUrl()
    { code } = await inquirer
      .prompt [{
        message: 'Input Code Here: '
        name: 'code'
      }]
      
    await setCode code

program
  .command 'logout'
  .action ->
    { doLogout } = await require('./libs/auth')()
    await doLogout()
    console.log colors.green 'Bye.'

program
  .command 'token-info'
  .action ->
    { display } = await require('./libs/auth')()
    display()

program
  .command 'account'
  .action ->
    { oauth2 } = await require('./libs/auth')()
    
    { data } = await oauth2.userinfo.get {
      fields: "email,id,name"
    }
    console.log colors.bold '______________________________________________________________'
    console.log data
    console.log colors.bold '______________________________________________________________'

program
  .command 'invoke <url>'
  .action (url) ->
    { oauth2Client, oauth2 } = await require('./libs/auth')()
    console.log 'Fetching User Info'
    { data } = await oauth2.userinfo.get {
      fields: "email,id,name"
    }
    console.log data
    console.log '-----'
    console.log "Invoking: #{url} "
    { access_token } = oauth2Client.credentials

    { data } = await axios.request {
      url,
      header: "Authorize: Bearer #{access_token}"
    }

    console.log 'Response:'
    console.log data

program.parse process.argv
