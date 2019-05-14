FuncHelper = require '/app/func_helper'
{
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    actions: { type: GraphQLString }
    properties: { type: GraphQLString }
    icon: { type: require('/app/types/icon') }
    primaryView: { type: GraphQLString }
    description: { type: GraphQLString }
  }
}