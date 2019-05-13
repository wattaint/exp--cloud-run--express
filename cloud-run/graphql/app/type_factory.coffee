_ = require 'lodash'
Mfec2Api = require "/app/helpers/mfec2api_helper"
CONST = require "/app/constant"
PageInfoType = require "/app/types/page_info"

{
  GraphQLInputObjectType
  GraphQLList
  GraphQLString
  GraphQLNonNull
  GraphQLObjectType
  GraphQLInt
} = require 'graphql'

self = {
  paginationType: (aType, aName) ->
    me = @
    name = _.upperFirst _.camelCase "#{aType}"
    name = _.upperFirst _.camelCase "#{aName}" if aName
      
    new GraphQLObjectType {
      name: "#{name}Page"
      description: "Pagination for #{name}"
      fields: -> {
        totalCount: {
          type: new GraphQLNonNull GraphQLInt
          resolve: (obj, args, ctx, meta) -> _.get obj, 'totalCount', 0
        }
        edges: {
          resolve: (obj, args, ctx, meta) -> _.get obj, 'edges'
          type: new GraphQLList new GraphQLObjectType {
            name: "#{name}Edge"
            fields: -> {
              node: {
                type: aType
                resolve: (obj) -> _.get obj, 'node'
              }
              cursor: {
                type: new GraphQLNonNull GraphQLString
                resolve: (obj, args, ctx) -> _.get obj, 'cursor'
              }
            }
          }
        }
        pageInfo: {
          type: new GraphQLNonNull PageInfoType
          resolve: (obj, args, ctx, meta) ->
            rows = await obj.edgesResolver obj, args, ctx, meta
            
            startCursor     = _.get (_.first  rows), 'cursor'
            endCursor       = _.get (_.last   rows), 'cursor'
            hasNextPage     = _.get (_.first  rows), 'hasNextPage', false
            hasPreviousPage = _.get (_.first  rows), 'hasPreviousPage', false
            { startCursor, endCursor, hasNextPage, hasPreviousPage }
        }
      }
    }

  listQuery: ({ filename, model, description, type, filterFields, resolveFn }) ->
    { FileName, ApiName, InputFilterTypeName } = CONST.name filename

    InputType = new GraphQLInputObjectType {
      name: InputFilterTypeName
      fields: filterFields
    }

    {
      name: ApiName
      description: description
      args: Mfec2Api.paginationArgs {
          "#{CONST.PAGING_ARGS_FILTER}": {
            type: InputType
          }
      }, {
        order: true
      }
      type: Mfec2Api.paginationType type, FileName
      resolve: (root, args, { abossModels }, meta) ->
        Mfec2Api.paginationResolver ApiName, model, args
    }
}

module.exports = self