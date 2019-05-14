{
  graphql
  GraphQLSchema
  GraphQLObjectType
  GraphQLList
  GraphQLString
} = require 'graphql'
Promise = require 'bluebird'
path = require 'path'
_ = require 'lodash'

fg = require 'fast-glob'

BASE_QUERY_DIR = "/app/schema/queries"
BASE_MUTATION_DIR = "/app/schema/mutations"

getRootQueryType = (aRootDirPath) ->
  files = await fg [
    path.join(aRootDirPath, "*.coffee"),
    path.join(aRootDirPath, "*.js"),
  ]

  types = _.filter files, (m) ->
    a = (m.endsWith ".coffee") and m.split(".").length == 2
    b = (m.endsWith ".js") and m.split(".").length == 2
    a || b

  res = _.map types, (filepath) ->
    fieldName = _.camelCase _.first path.basename(filepath).split('.')
    
    {
      type, resolve, args, description
    } = require(filepath)

    { fieldName, filepath, type, resolve, args, description }

  rootQueryFields = {}
  for e in res
    rootQueryFields[e.fieldName] = e

  rootQueryFields

module.exports = ->
  
  { rootQueryFields, mutationFields } = await Promise.props {
    rootQueryFields: getRootQueryType(BASE_QUERY_DIR)
    mutationFields: getRootQueryType(BASE_MUTATION_DIR)
  }
  
  new GraphQLSchema {
    query: new GraphQLObjectType {
      name: 'RootQueryType'
      fields: rootQueryFields
    }
    mutation: new GraphQLObjectType {
      name: 'RootMutationType'
      fields: mutationFields
    }
  }
