FuncHelper = require '/app/func_helper'
{
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    class: {
      type: GraphQLString
    }
  }
}