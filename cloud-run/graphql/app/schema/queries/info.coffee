_ = require 'lodash'
Helper = require "/app/func_helper"
Jenkins = require '../../libs/jenkins'

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
    jenkins = await Jenkins.getInstance()

    resp = await jenkins.infoAsync()
    resp
}
