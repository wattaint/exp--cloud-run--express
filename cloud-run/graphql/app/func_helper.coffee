_ = require 'lodash'
path = require 'path'

self = {
  DEFAULT_GRAPHQL_PAGINATION_QUERY_LIMIT: 100
  PAGING_ARGS_FILTER: 'filter'
  PAGING_ARGS_SORT: 'sorts'
  PAGING_ARGS_LAST: 'last'
  PAGING_ARGS_AFTER: 'after'
  PAGING_ARGS_FIRST: 'first'
  PAGING_ARGS_BEFORE: 'before'

  fileName: (filepath) ->
    "#{_.camelCase path.basename filepath, '.coffee'}"

  typeName: (name) ->
    "#{self.fileName name}Type"

  inputTypeName: (name) ->
    "#{self.fileName name}InputType"

  enumTypeName: (filename) ->
    "#{self.fileName filename}EnumType"

  name: (aFileName) ->
    apiName       = _.upperFirst _.camelCase aFileName
    fileName      = self.fileName aFileName
    typeName      = self.typeName aFileName
    inputTypeName = self.inputTypeName aFileName
    enumTypeName  = self.enumTypeName aFileName

    { apiName, fileName, typeName, inputTypeName, enumTypeName }
}

module.exports = _.extend self, {
  _
}