FuncHelper = require '/app/func_helper'
{
  GraphQLBoolean
  GraphQLList
  GraphQLObjectType
  GraphQLString
} = require 'graphql'

module.exports = new GraphQLObjectType {
  name: FuncHelper.typeName __filename
  fields: -> {
    _class: { type: GraphQLString }
    actions: {
      type: new GraphQLList require('/app/types/job_action')
    }
    description: { type: GraphQLString }
    displayName: { type: GraphQLString }
    displayNameOrNull: { type: GraphQLString }
    fullDisplayName: { type: GraphQLString }
    fullName: { type: GraphQLString }
    name: { type: GraphQLString }
    url: { type: GraphQLString }
    ## ----- FreeStyleProject -----
    buildable: { type: GraphQLBoolean }
    builds: { type: new GraphQLList require('/app/types/job_build') }
    firstBuild: { type: require('/app/types/job_build') }
    lastBuild: { type: require('/app/types/job_build') }
    lastCompletedBuild: { type: require('/app/types/job_build') }
    lastFailedBuild: { type: require('/app/types/job_build') }
    lastStableBuild: { type: require('/app/types/job_build') }
    lastSuccessfulBuild: { type: require('/app/types/job_build') }
    lastUnstableBuild: { type: require('/app/types/job_build') }
    nextBuildNumber: { type: require('/app/types/job_build') }

    healthReport: {
      type: new GraphQLList GraphQLString
    }
    jobs: {
      type: new GraphQLList require('/app/types/job')
    }
    primaryView: {
      type: require('/app/types/job_view')
    }
    view: {
      type: require('/app/types/job_view')
    }

    downstreamProjects: {
      type: new GraphQLList require('/app/types/job')
    }
    upstreamProjects: {
      type: new GraphQLList require('/app/types/job')
    }
  }
}