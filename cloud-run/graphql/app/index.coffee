express     = require 'express'
graphqlHTTP = require 'express-graphql'
GraphQLSchema = require './schema'

app = express()

app.use '/graphql', graphqlHTTP {
  schema: GraphQLSchema
  graphiql: true
}

port = process.env.PORT || 80
app.listen port, ->
  console.log "Listened at port: #{port}"