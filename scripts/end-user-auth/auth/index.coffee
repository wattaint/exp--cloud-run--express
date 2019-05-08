#!/usr/bin/env coffee
axios     = require 'axios'
colors    = require 'colors'
inquirer  = require('inquirer')
program   = require 'commander'
{ promisify } = require 'util'

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
  .command 'user'
  .action ->
    { oauth2 } = await require('./libs/auth')()
    
    { data } = await oauth2.userinfo.get {
      fields: "email,id,name"
    }
    console.log colors.bold '______________________________________________________________'
    console.log data
    console.log colors.bold '______________________________________________________________'

program
  .command 'invoke'
  .option '--sa <service-account-file>'
  .action ({ sa }) ->

    url = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app/env"

    doRevoke = (token) ->
      console.log ''
      console.log colors.underline("Send Request to: ") + url
      conf = {
        url,
        method: 'get'
        headers: {
          Authorization: "Bearer #{token}"
        }
      }
      console.log conf
      { data } = await axios.request conf

      console.log ''
      console.log colors.underline 'Response:'
      console.log data

    if sa
      { buildJWTToken, fetchIdToken } = await require('./libs/sa')(sa)
      jwt = await buildJWTToken(url)
      { id_token } = await fetchIdToken jwt
      await doRevoke id_token

    else
      { oauth2Client, oauth2 } = await require('./libs/auth')()
      console.log ''
      console.log colors.underline 'Fetching User Info'
      { data } = await oauth2.userinfo.get {
        fields: "email,id,name"
      }
      console.log data
      
      { id_token } = oauth2Client.credentials
      
      await doRevoke id_token

program.parse process.argv
