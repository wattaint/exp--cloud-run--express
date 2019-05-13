_ = require 'lodash'
Helper = require "/app/helper"
{
  GraphQLEnumType
} = require 'graphql'

module.exports = new GraphQLEnumType {
  name: Helper.enumTypeName __filename
  #description: "Aboss Client Account"
  values: {
    DATAFLOW: {
      description: "DataFlow"
    }
    ETC: {
      description: "Etc."
    }
  }
}