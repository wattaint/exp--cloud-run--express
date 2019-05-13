FuncHelper = require '/app/func_helper'
{
  GraphQLObjectType
  GraphQLNonNull
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    name: {
      type: new GraphQLNonNull GraphQLString
    }
  }
}