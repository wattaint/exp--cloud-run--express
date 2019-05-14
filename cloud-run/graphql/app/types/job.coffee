FuncHelper = require '/app/func_helper'
{
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

XML     = require 'pixl-xml'

{ getInstance, jobFullNameFromUrl, jobInfoLoader } = require('/app/libs/jenkins')

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    name: {
      type: GraphQLString
    }
    _class: {
      type: GraphQLString
    }
    url: {
      type: GraphQLString
    }
    fullName: {
      type: GraphQLString
    }
    color: { type: GraphQLString }
    info: {
      type: require('/app/types/job_info')
      resolve1: ({ url }) ->
        fullName = jobFullNameFromUrl url
        jenkins = await getInstance()
        resp = await jenkins.job.getAsync fullName
        console.log '------------------ job get ----------------'
        console.log resp
        console.log '---'
        resp

      resolve: ({ url }) ->
        fullName = jobFullNameFromUrl url
        jobInfoLoader().load url
    }
    config: {
      type: require('/app/types/job_config')
      resolve: ({ fullName }) ->
        fullName = jobFullNameFromUrl url
        jenkins = await getInstance()
        res = await jenkins.job.configAsync fullName
        XML.parse res
    }
  }
}