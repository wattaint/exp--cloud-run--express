_ = require 'lodash'
Helper = require "/app/helper"
{
  GraphQLEnumType
} = require 'graphql'

module.exports = new GraphQLEnumType {
  name: Helper.enumTypeName __filename
  #description: "Aboss Client Account"
  values: {
    APPEND: {
      description: "Append"
    }
    ETC: {
      description: "Etc."
    }
  }
}