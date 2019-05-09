#!/usr/bin/env coffee
axios     = require 'axios'
colors    = require 'colors'
inquirer  = require('inquirer')
program   = require 'commander'
{ promisify } = require 'util'

program
  .command 'login <app-secret-json-path>'
  .action (appSecretJsonPath, cmd) ->
    { oauth2Client,
      generateUrl,
      setCode,
      display } = await require('./libs/auth')({ login: true, appSecretJsonPath })
    
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
    { doLogout } = await require('./libs/auth') {}
    await doLogout()
    console.log colors.green 'Bye.'

program
  .command 'token-info'
  .action ->
    { display } = await require('./libs/auth')({})
    display()

program
  .command 'user'
  .action ->
    { oauth2, client_id, project_id, client_secret_name } = await require('./libs/auth') {}
    
    { data } = await oauth2.userinfo.get {
      fields: "email,id,name"
    }
    console.log ''
    console.log colors.bold '______________________________________________________________'
    console.log colors.bold(' Project ID: '), project_id
    console.log colors.bold('  Client ID: '), client_id
    console.log colors.bold('Secret File: '), client_secret_name
    console.log ''
    console.log data
    console.log ''

program
  .command 'invoke-iap-gce'
  .option '--path <url-path>'
  .option '--sa <service-account-file>'
  .action ({ sa, path }) ->
    url = "https://dpapi-staging-dp.ascendanalyticshub.com"
    if path then url = url + "#{path}"
    
    doRequest = (token) ->
      process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'
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
      { buildSignedHeadersJWTToken, fetchIdToken } = await require('./libs/iap')(sa)
      jwt = await buildSignedHeadersJWTToken url, {
        
      }
      
      { id_token } = await fetchIdToken jwt
      console.log 'ID Token => ', id_token
      await doRequest id_token

    else
      { oauth2Client, oauth2 } = await require('./libs/auth') {}
      console.log ''
      console.log colors.underline 'Fetching User Info'
      { data } = await oauth2.userinfo.get {
        fields: "email,id,name"
      }
      console.log data
      
      { id_token } = oauth2Client.credentials
      
      await doRequest id_token
    
program
  .command 'invoke-cloud-run'
  .option '--sa <service-account-file>'
  .option '--path <url-path>'
  .action ({ sa, path }) ->
    url = "https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app"
    if path
      url = url + "#{path}"
    
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
      { oauth2Client, oauth2 } = await require('./libs/auth') {}
      console.log ''
      console.log colors.underline 'Fetching User Info'
      { data } = await oauth2.userinfo.get {
        fields: "email,id,name"
      }
      console.log data
      
      { id_token } = oauth2Client.credentials
      
      await doRevoke id_token

program.parse process.argv
