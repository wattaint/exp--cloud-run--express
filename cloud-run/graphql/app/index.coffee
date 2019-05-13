express       = require 'express'
graphqlHTTP   = require 'express-graphql'
#GraphQLSchema = require './schema/schema'

app = express()

schema = require './schema/schema'

main = ->
  app.use '/graphql', graphqlHTTP {
    schema: await schema()
    graphiql: true
  }

  port = process.env.PORT || 80
  app.listen port, ->
    console.log "GraphQL Api Listened at port: #{port}"

main()