FuncHelper = require '/app/func_helper'
{
  GraphQLInt
  GraphQLList
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    _class: {
      type: GraphQLString
    }
    mode: {
      type: GraphQLString
    }
    numExecutors: {
      type: GraphQLInt
    }
    nodeDescription: {
      type: GraphQLString
    }
    assignedLabels: {
      type: new GraphQLList require('/app/types/assigned_label')
      resolve: ({ assignedLabels }) ->
        assignedLabels
    }
    jobs: {
      type: new GraphQLList require('/app/types/job')
      resolve: ({ jobs }) ->
        #console.log '--- resi --', arguments
        jobs
    }
  }
}