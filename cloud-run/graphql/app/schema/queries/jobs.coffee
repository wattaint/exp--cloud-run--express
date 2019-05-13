_ = require 'lodash'
Helper = require "/app/func_helper"
RequestHelper = require '/app/request_helper'

{
  GraphQLInputObjectType
  GraphQLInt
  GraphQLList
  GraphQLString
} = require 'graphql'

{ apiName, inputTypeName } = Helper.name __filename

Type = require "/app/types/job"
module.exports = {
  name: apiName
  type: new GraphQLList Type
  args1: {
    input: {
      type: new GraphQLInputObjectType {
        name: "InputA"
        fields: -> {
          a: {
            type: GraphQLString
          }
        }
      }
    }
  }
  resolve: (root, args, ctx, meta) ->
    resp = await RequestHelper.getJenkins 'jobs'
    _.get resp, 'jobs'
}
