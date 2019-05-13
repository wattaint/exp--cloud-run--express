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

Type = require "/app/types/hudson"
module.exports = {
  name: apiName
  type: Type
  resolve: (root, args, ctx, meta) ->
    resp = await RequestHelper.getJenkins 'jobs'
    resp
}
