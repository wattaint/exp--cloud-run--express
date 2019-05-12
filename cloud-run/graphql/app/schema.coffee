{
  graphql,
  GraphQLSchema,
  GraphQLObjectType,
  GraphQLString
} = require 'graphql'

schema = new GraphQLSchema {
  query: new GraphQLObjectType {
    name: 'RootQueryType'
    fields: {
      hello: {
        type: GraphQLString
        resolve: ->
          'world'
      }
    }
  }
}

module.exports = schema
