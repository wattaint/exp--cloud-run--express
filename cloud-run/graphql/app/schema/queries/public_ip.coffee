publicIp  = require 'public-ip'
FuncHelper = require '/app/func_helper'
{ apiName, inputTypeName } = FuncHelper.name __filename

{
  GraphQLString
} = require 'graphql'

module.exports = {
  name: apiName
  type: GraphQLString
  resolve: (root, args, ctx, meta) ->
    publicIp.v4()
}