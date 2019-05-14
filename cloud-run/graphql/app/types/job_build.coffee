FuncHelper = require '/app/func_helper'
{
  GraphQLList
  GraphQLObjectType
  GraphQLString
  GraphQLInt
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    _class: { type: GraphQLString }
    number: { type: GraphQLInt }
    url: { type: GraphQLString }
  }
}