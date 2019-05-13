FuncHelper = require '/app/func_helper'
{
  GraphQLObjectType
  GraphQLString
  GraphQLInt
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
  }
}