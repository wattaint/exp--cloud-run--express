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

  FileName: (filename) ->
    path.basename filename

  name: (filename) ->
    FileName  = _.first path.basename(filename).split '.'
    ApiName   = _.upperFirst _.camelCase FileName

    ret = { ApiName }
    ret
}

module.exports = _.extend self, {
  _
}