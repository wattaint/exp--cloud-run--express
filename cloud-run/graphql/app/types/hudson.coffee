_ = require 'lodash'
Promise = require 'bluebird'
FuncHelper = require '/app/func_helper'
{
  GraphQLInt
  GraphQLList
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

{ jobFullNameFromUrl } = require '/app/libs/jenkins'

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
        jobs.map (job) ->
          fullName = _(job).get 'fullName'
          unless fullName
            fullName = jobFullNameFromUrl job.url
            _.extend job, { fullName }
          job
    }
  }
}