Promise   = require 'bluebird'
_         = require 'lodash'
colors    = require 'colors'
fs        = require 'fs'
fsx       = require 'fs-extra'
moment    = require 'moment'
path      = require 'path'
{ promisify } = require 'util'

readFile  = promisify(fs.readFile)

TOKEN_PATH = "/data/token.json"
REFRESH_TOKEN_PATH = "/data/refresh-token"
APP_SECRET_PATH = "/data/app.json"

{ google } = require 'googleapis'

scope = [
  'https://www.googleapis.com/auth/cloud-platform',
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile'
]

setCredentials = (oauth2Client) ->
  { tokenExists, refreshTokenExists } = await Promise.props {
    tokenExists: fsx.exists TOKEN_PATH
    refreshTokenExists: fsx.exists REFRESH_TOKEN_PATH
  }

  cred = null
  if tokenExists
    cred = await fsx.readJson TOKEN_PATH
    oauth2Client.setCredentials cred
    { expiry_date } = cred
    if moment(expiry_date).isBefore(moment())
      cred = null

  unless cred
    if refreshTokenExists
      tokens = await readFile REFRESH_TOKEN_PATH
      if tokens
        cred = { refresh_token: tokens.toString() }
        oauth2Client.setCredentials cred
  
  cred

self = ({ login, appSecretJsonPath }) ->
  await fsx.ensureDir path.dirname TOKEN_PATH

  { tokenExists, refreshTokenExists, appSecretExists } = await Promise.props {
    tokenExists: fsx.exists TOKEN_PATH
    refreshTokenExists: fsx.exists REFRESH_TOKEN_PATH
    appSecretExists: fsx.exists APP_SECRET_PATH
  }

  client_secret_name = ''
  if appSecretJsonPath
    client_secret_name = path.basename appSecretJsonPath
    appClient = await fsx.readJson appSecretJsonPath
    for prop, value of appClient
      app_type = prop
      
      { client_id, client_secret, redirect_uris, project_id } = value

    await fsx.writeJson APP_SECRET_PATH, {
      client_secret_name, app_type, client_id, client_secret, redirect_uris, project_id
    }

  else if appSecretExists
    { client_secret_name,
      app_type, client_id, client_secret,
      redirect_uris, project_id } = await fsx.readJSON APP_SECRET_PATH

  unless client_id
    console.log colors.red.bold 'No Application Secret Found!'
    return process.exit 1

  oauth2Client = new google.auth.OAuth2(
    client_id,
    client_secret,
    redirect_uris[0]
  )

  unless login
    cred = await setCredentials oauth2Client
    
    unless cred
      console.log colors.red.bold 'Refresh Token not found! Please login!'
      return process.exit(1)

  oauth2Client.on 'tokens', (tokens) ->
    console.log colors.yellow.bold "[Info] Updating token."
    if _.isObject(tokens)
      if _.isString tokens.refresh_token
        await fsx.outputFile REFRESH_TOKEN_PATH, tokens.refresh_token
      
      console.log "write to #{TOKEN_PATH}", tokens
      await fsx.writeJson TOKEN_PATH, tokens

  {
    client_secret_name,
    app_type,
    client_id,
    project_id,
    doLogout: ->
      await fsx.ensureDir path.dirname TOKEN_PATH
      await fsx.emptyDir path.dirname TOKEN_PATH

    oauth2Client,
    oauth2: google.oauth2 {
      version: 'v2',
      auth: oauth2Client
    }
    generateUrl: ->
      oauth2Client.generateAuthUrl {
        access_type: 'offline',
        scope
      }
    
    setCode: (code) ->
      { tokens } = await oauth2Client.getToken code
      oauth2Client.setCredentials tokens
      console.log "Save token to '#{TOKEN_PATH}'"
      await fsx.writeJson TOKEN_PATH, tokens
      if tokens.refresh_token
        await fsx.outputFile REFRESH_TOKEN_PATH, tokens.refresh_token
    
    display: ->
      # { tokenExists, refreshTokenExists } = await Promise.props {
      #   tokenExists: fsx.exists TOKEN_PATH
      #   refreshTokenExists: fsx.exists REFRESH_TOKEN_PATH
      # }

      errors = []
      unless tokenExists
        errors.push "Token file not exists. (#{TOKEN_PATH})"

      unless refreshTokenExists
        errors.push "Token file not exists. (#{REFRESH_TOKEN_PATH})"
      
      if errors.length > 0
        return console.log colors.red.bold errors.join "\n"
      
      printInfo = (obj) ->
        for prop, val of obj
          console.log _.padStart("#{colors.bold prop}", 25, ' ') + ": #{val}"


      ret = {
          'Path': TOKEN_PATH
      }
      if tokenExists
        { expiry_date } = await fsx.readJson TOKEN_PATH
        _.extend ret, {
          'Now': "#{moment()}"
          'Expiry Date': "#{moment(expiry_date)} (#{expiry_date})"
          'Expiry': ( if moment(expiry_date).isBefore(moment())
                        colors.red.bold "#{moment(expiry_date).fromNow()}"
                      else
                         "#{moment(expiry_date).fromNow()}"
                    )

        }

      console.log colors.bold ''
      console.log colors.underline "Token file:"
      printInfo ret
      
      ret = {
        'Path': TOKEN_PATH
      }
      if refreshTokenExists
        token = await readFile REFRESH_TOKEN_PATH
        _.extend ret, {
          'Path': TOKEN_PATH
          'Data': token.toString()
        }
      console.log colors.bold ''
      console.log colors.underline "Refresh Token file:"
      printInfo ret

      console.log ''
  }

module.exports = self
