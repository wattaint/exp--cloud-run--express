FuncHelper = require '/app/func_helper'
{
  GraphQLList
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    _class: { type: GraphQLString }
    name: { type: GraphQLString }
    url: { type: GraphQLString }
  }
}