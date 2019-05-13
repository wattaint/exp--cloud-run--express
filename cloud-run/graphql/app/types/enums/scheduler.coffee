_ = require 'lodash'
FuncHelper = require "/app/func_helper"
{
  GraphQLEnumType
} = require 'graphql'

module.exports = new GraphQLEnumType {
  name: FuncHelper.enumTypeName __filename
  #description: "Aboss Client Account"
  values: {
    TRIGGER: {
      description: "Trigger"
    }
    ETC: {
      description: "Etc."
    }
  }
}