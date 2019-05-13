Helper = require '/app/helper'
{
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: Helper.typeName __filename
  fields: -> {
    name: {
      type: GraphQLString
    }
    fullName: {
      type: GraphQLString
    }
    endPoint: {
      type: GraphQLString
      description: """
        Job endpoint

        **Example:**

        "view/acm-inter-staging/job/vn_operation_authcenter/job/biz_customer_session"
      """
    }
  }
}