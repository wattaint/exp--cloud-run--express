_ = require 'lodash'
Helper = require "/app/helper"

{
  GraphQLInputObjectType
  GraphQLInt
  GraphQLString
} = require 'graphql'

{ ApiName } = Helper.name __filename

Type = require "/app/types/job"
module.exports = {
  name: ApiName
  type: Type
  args: {
    "#{Helper.PAGING_ARGS_FILTER}": {
      type: new GraphQLInputObjectType {
        name: "#{ApiName}Input"
        fields: -> {
          id: {
            type: GraphQLInt
            description: "id ของ table"
          }
          code: {
            type: GraphQLString
            description: "ClientCode + AccountSubCode เช่น 16212 + 4 = '162124' "
          }
          clientAccountCode: {
            type: GraphQLString
            description: "Ex. 99073641"
          }
        }
      }
    }
  }
  resolve: (root, args, ctx, meta) ->
    console.log '-- resolve --'
    {}
}