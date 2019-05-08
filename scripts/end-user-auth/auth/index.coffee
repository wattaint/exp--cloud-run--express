#!/usr/bin/env coffee
axios     = require 'axios'
colors    = require 'colors'
fg        = require 'fast-glob'
fs        = require 'fs'
fsx       = require 'fs-extra'
querystring = require('querystring')
inquirer  = require('inquirer')
path      = require 'path'
program   = require 'commander'
{ promisify } = require 'util'

readFile  = promisify(fs.readFile)

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
  .action ->
    url = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app/env"
    { oauth2Client, oauth2 } = await require('./libs/auth')()
    console.log 'Fetching User Info'
    { data } = await oauth2.userinfo.get {
      fields: "email,id,name"
    }
    console.log '-----------'
    console.log data
    console.log '-----------'
    console.log "Send Request to: #{url} "
    { id_token } = oauth2Client.credentials
    
    conf = {
      url,
      method: 'get'
      headers: {
        Authorization: "Bearer #{id_token}"
      }
    }
    console.log conf
    { data } = await axios.request conf

    console.log 'Response:'
    console.log data

program
  .command "service-account <file-path>"
  .option '--to-jwt'
  .action (filePath, { toJwt }) ->
    { toJwt, fetchToken } = await require('./libs/sa')(filePath)
    jwt = await toJwt(url, data)

    #url = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"

    jwt = fetchToken(data, url)
    url = "https://www.googleapis.com/oauth2/v4/token"
    conf = {
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
      method: "post"
      data: querystring.stringify {
        grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
        assertion: jwt
      }
    }
    console.log conf
    { data } = await axios.request conf
    console.log '------'
    console.log data

    # console.log '------ y ---------'
    # url = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
    # token2 = await fetchToken(data, url)

    # console.log '------ x ------', token2
    # url = "https://www.googleapis.com/oauth2/v4/token"
    # conf = {
    #   url,
    #   headers: {
    #     Authorization: "Bearer #{data.access_token}"
    #     'Content-Type': 'application/x-www-form-urlencoded'
    #   }
    #   method: "post"
    #   data: querystring.stringify {
    #     grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer"
    #     assertion: token2
    #   }
    # }
    # console.log conf
    # console.log await axios.request conf
    # process.exit(1)
    # conf = {
    #   url,
    #   method: 'get'
    #   headers: {
    #     Authorization: "Bearer #{data.access_token}"
    #   }
    # }
    # console.log conf
    # { data } = await axios.request conf

    # console.log 'Response:'
    # console.log data

    url = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app/env"
    conf = {
      url,
      method: 'get'
      headers: {
        Authorization: "Bearer #{data.id_token}"
      }
    }
    console.log conf
    { data } = await axios.request conf

    console.log 'Response:'
    console.log data

program.parse process.argv
